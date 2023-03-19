use std::{
    collections::HashMap,
    path::{Path, PathBuf},
    time::UNIX_EPOCH,
};

use aws_sdk_s3::{model::ObjectIdentifier, types::ByteStream};
use futures::StreamExt;

use super::profile::AWSProfile;
use crate::aws;

/// Parse date string from aws datetime
fn parse_datetime(datetime: &aws_smithy_types::DateTime) -> Option<String> {
    match std::time::SystemTime::try_from(*datetime) {
        Ok(dtime) => {
            if let Ok(time) = dtime.duration_since(UNIX_EPOCH) {
                Some(time.as_millis().to_string())
            } else {
                None
            }
        }
        Err(_) => None,
    }
}

/// S3 Client生成
async fn _init_client(profile: AWSProfile) -> aws_sdk_s3::client::Client {
    let provider = aws::CredentialProvider::new(profile.access_key_id, profile.secret_access_key)
        .set_token(profile.session_token);
    let s3_config = aws::get_aws_config(provider, profile.region).await;
    aws_sdk_s3::Client::new(&s3_config)
}

/// プレフィックスをフォーマット
fn _format_prefix(prefix: Option<String>) -> Option<String> {
    match prefix {
        Some(v) => {
            if v.len() == 0 {
                None
            } else {
                if v.ends_with("/") {
                    Some(v)
                } else {
                    Some(format!("{}/", v))
                }
            }
        }
        None => None,
    }
}

#[derive(serde::Serialize)]
pub struct S3Bucket {
    pub name: String,
    pub created_at: Option<String>,
    pub location: String,
}

/// S3バケットリスト取得
pub async fn list_buckets(profile: AWSProfile) -> Result<Vec<S3Bucket>, aws_sdk_s3::Error> {
    let client = _init_client(profile).await;

    match client.list_buckets().send().await {
        Ok(res) => {
            let mut list = Vec::<S3Bucket>::new();

            let buckets = res.buckets().unwrap_or_default();
            for b in buckets {
                if let (Some(name), Some(creation)) = (b.name(), b.creation_date()) {
                    // バケットの詳細情報を取得
                    // ロケーション情報
                    let r = match client
                        .get_bucket_location()
                        .bucket(name.clone())
                        .send()
                        .await
                    {
                        Ok(v) => v,
                        Err(err) => return Err(err.into()),
                    };

                    let location = r.location_constraint().unwrap().as_str();
                    let created_at = parse_datetime(creation);
                    list.push(S3Bucket {
                        name: name.to_string(),
                        created_at,
                        location: location.to_string(),
                    });
                }
            }

            Ok(list)
        }
        Err(err) => {
            println!("s3 list bucket error: {:?}", err);
            Err(err.into())
        }
    }
}

#[derive(serde::Serialize)]
pub struct S3Object {
    pub key: String,
    pub last_modified: Option<String>,
    pub size: Option<i64>,
    pub storage_class: Option<String>,
    pub is_folder: bool,
}

/// S3バケット内のオブジェクトを取得
/// prefixを指定しないと全件取得してしまうため、指定のprefix内のデータのみ取得するようにする
pub async fn list_objects(
    profile: AWSProfile,
    bucket: S3Bucket,
    prefix: Option<String>,
) -> Result<Vec<S3Object>, aws_sdk_s3::Error> {
    let client = _init_client(profile).await;

    // バケットインスタンス生成
    let mut bucket = client.list_objects_v2().bucket(&bucket.name).delimiter("/");
    // prefixの指定がある場合は設定
    if let Some(p) = &prefix {
        bucket = bucket.prefix(p);
    }

    // 取得した情報を格納するリスト
    let mut list = Vec::<S3Object>::new();
    // フォルダとして設定済みの階層を格納しておく
    let mut setted = HashMap::<String, bool>::new();

    let fp = _format_prefix(prefix);

    // オブジェクト取得リクエスト
    let mut stream = bucket.into_paginator().send();

    // 取得したリストはページング処理されているため順番に取得
    while let Some(res) = stream.next().await {
        if res.is_err() {
            break;
        }

        let data = res.unwrap();
        let objects = data.contents().unwrap_or_default();

        for obj in objects {
            // 必要な情報が含まれていない場合は無視
            if obj.key().is_none() || obj.last_modified().is_none() || obj.storage_class().is_none()
            {
                continue;
            }

            // prefixが指定されている場合はその部分を除去
            let key_prefix = if let Some(p) = &fp {
                obj.key().unwrap().replace(p.as_str(), "")
            } else {
                obj.key().unwrap().to_string()
            };

            // 置換した結果、空となった場合は無視
            if key_prefix.is_empty() {
                continue;
            }

            // 区切り文字でsplitした最初のアイテムのみ返却する
            let item = key_prefix.split("/").into_iter().collect::<Vec<&str>>();

            // プレフィックスが指定されている場合は1番目の値を取得する
            let data = item[0].to_string();

            // アイテムを生成する
            let mut s3_object = S3Object {
                key: data.to_string(),
                last_modified: parse_datetime(obj.last_modified().unwrap()),
                size: Some(obj.size),
                storage_class: Some(obj.storage_class().unwrap().as_str().to_string()),
                is_folder: false,
            };

            // キーの一番最後の値が"/"の場合はディレクトリと判定
            if key_prefix.ends_with("/") && obj.size() == 0 && setted.get(&data).is_none() {
                s3_object.is_folder = true;
                list.push(s3_object);
                setted.insert(data, true);
                continue;
            }
            // 階層を含むデータであった場合は第一階層をフォルダとして設定
            else if item.len() > 1 {
                if setted.get(&data).is_none() {
                    s3_object.is_folder = true;
                    list.push(s3_object);
                    setted.insert(data, true);
                }
                continue;
            }

            list.push(s3_object);
        }

        // フォルダについては`delimiter`を設定すると`common_prefix`に含まれるため
        // そのデータ内から取得
        let cm_prefix = data.common_prefixes().unwrap_or_default();
        for obj in cm_prefix {
            if let Some(p) = obj.prefix() {
                // prefixが指定されている場合はその部分を除去
                let key_prefix = if let Some(_fp) = &fp {
                    p.replace(_fp.as_str(), "")
                } else {
                    p.to_string()
                };

                let s3_object = S3Object {
                    key: key_prefix.clone(),
                    last_modified: None,
                    size: None,
                    storage_class: None,
                    is_folder: true,
                };

                if setted.get(&key_prefix).is_none() {
                    list.push(s3_object);
                    setted.insert(key_prefix, true);
                }
            }
        }
    }
    list.sort_by(|a, b| {
        let a_folder = if a.is_folder { 1 } else { 0 };
        let b_folder = if b.is_folder { 1 } else { 0 };

        let a_name = a.key.to_ascii_lowercase();
        let b_name = b.key.to_ascii_lowercase();
        b_folder.cmp(&a_folder).then(a_name.cmp(&b_name))
    });

    Ok(list)
}

/// フォルダ作成
pub async fn create_folder(
    profile: AWSProfile,
    bucket_name: String,
    prefix: String,
) -> Result<bool, aws_sdk_s3::Error> {
    let client = _init_client(profile).await;

    // プレフィックスの最後が'/'ではない場合はエラー
    if !&prefix.ends_with('/') {
        return Ok(false);
    }

    // PutObjectでフォルダを作成
    client
        .put_object()
        .bucket(bucket_name)
        .key(prefix)
        .send()
        .await?;

    Ok(true)
}

/// ファイルアップロード
pub async fn upload_file(
    profile: AWSProfile,
    bucket_name: String,
    prefix: Option<String>,
    file_path: String,
) -> Result<bool, aws_sdk_s3::Error> {
    let client = _init_client(profile).await;

    // PutObjectインスタンス生成
    let mut req = client.put_object().bucket(bucket_name);

    // ファイルを取得
    let path_buf = PathBuf::from(&file_path);
    let file_name = path_buf.file_name().unwrap().to_str().unwrap();

    // プレフィックスの指定がある場合は設定
    req = req.key(file_name);
    if let Some(p) = prefix {
        if p.len() > 0 {
            req = req.key(format!("{}{}", p, file_name));
        }
    }

    // ファイルのデータを取得しアップロード
    match ByteStream::from_path(Path::new(file_path.as_str())).await {
        Ok(b) => {
            req.body(b).send().await?;
        }
        Err(_) => {
            return Ok(false);
        }
    }

    Ok(true)
}

/// 指定オブジェクト(フォルダ)を削除
pub async fn delete_objects(
    profile: AWSProfile,
    bucket_name: String,
    prefixes: Vec<String>,
) -> Result<bool, aws_sdk_s3::Error> {
    let client = _init_client(profile).await;

    // 削除対象リスト
    let mut delete_list: Vec<ObjectIdentifier> = vec![];
    for prefix in prefixes {
        // プレフィックスの最後が'/'の場合はフォルダ扱い
        if prefix.ends_with('/') {
            let res = client
                .list_objects_v2()
                .bucket(&bucket_name)
                .prefix(&prefix)
                .send()
                .await?;
            let objs = res.contents().unwrap_or_default();
            for obj in objs {
                let Some(key) = obj.key() else {
                    continue;
                };
                let obj_id = ObjectIdentifier::builder()
                    .set_key(Some(key.to_string()))
                    .build();
                delete_list.push(obj_id);
            }
        } else {
            let obj_id = ObjectIdentifier::builder().set_key(Some(prefix)).build();
            delete_list.push(obj_id);
        }
    }

    // 削除リクエスト
    let delete = aws_sdk_s3::model::Delete::builder()
        .set_objects(Some(delete_list.clone()))
        .build();
    client
        .delete_objects()
        .bucket(bucket_name)
        .delete(delete)
        .send()
        .await?;

    Ok(true)
}

#[derive(Clone)]
pub struct S3GetObjectConfig {
    pub save_dir: Option<String>,
    pub zip_for_folder: bool,
}

async fn __save_object_body(
    res: aws_sdk_s3::output::GetObjectOutput,
    dir: PathBuf,
    file_name: &str,
) -> Result<Option<String>, aws_sdk_s3::Error> {
    let p = &dir.join(file_name);

    let bytes = res.body.collect().await.unwrap().into_bytes().to_vec();
    match super::utils::file::save_file(bytes.to_vec(), &p) {
        Ok(p) => Ok(Some(p.as_path().to_str().unwrap().to_string())),
        Err(_) => Ok(None),
    }
}

/// オブジェクトダウンロード
pub async fn get_object(
    profile: AWSProfile,
    bucket_name: String,
    prefix: String,
    config: S3GetObjectConfig,
) -> Result<Option<String>, aws_sdk_s3::Error> {
    let client = _init_client(profile).await;

    // オブジェクト取得
    let res = client
        .get_object()
        .bucket(bucket_name)
        .key(&prefix)
        .send()
        .await?;

    // プレフィックスからファイル名を取得
    // 区切り文字でsplitした最後のアイテムのみ返却する
    let item = prefix.split("/").into_iter().collect::<Vec<&str>>();
    let file_name = item[item.len() - 1];

    // 保存先のディレクトリ指定
    let download_dir = super::utils::file::download_dir(config.save_dir, None);
    __save_object_body(res, download_dir, file_name).await
}

/// 指定のフォルダのファイルをすべて保存
pub async fn get_objects_folder(
    profile: AWSProfile,
    bucket_name: String,
    prefix: String,
    config: S3GetObjectConfig,
) -> Result<Option<String>, aws_sdk_s3::Error> {
    let client = _init_client(profile).await;

    // 指定されたプレフィックスが複数階層の場合は最後部分のみ取得して
    // それをディレクトリとする
    let p = Path::new(&prefix);
    let dir_name = if let Some(n) = p.file_name() {
        n.to_str().unwrap().to_string()
    } else {
        "".to_string()
    };

    // 保存先のディレクトリ指定
    let download_dir = super::utils::file::download_dir(config.save_dir.clone(), None);
    let (dl_dir, name) = if config.zip_for_folder {
        super::utils::file::build_new_name(&download_dir.join(dir_name.clone()))
    } else {
        (download_dir.join(dir_name.clone()), dir_name.clone())
    };

    // 指定フォルダのオブジェクトリストを取得
    let bucket = client
        .list_objects_v2()
        .bucket(&bucket_name)
        .prefix(&prefix);
    // 指定パス内の情報を取得
    let res = bucket.send().await?;
    let objs = res.contents().unwrap_or_default();

    // 1件ずつオブジェクトをダウンロードして保存
    for obj in objs {
        let Some(key) = obj.key() else {
            continue
        };
        // キーの一番最後の値が"/"の場合はディレクトリのため取得しない
        if key.ends_with("/") {
            continue;
        }

        // オブジェクトを取得
        let out = client
            .get_object()
            .bucket(&bucket_name)
            .key(key.clone())
            .send()
            .await?;

        // ファイル名取得
        let s = &key.split("/").into_iter().collect::<Vec<&str>>();
        let file_name = s[s.len() - 1];

        // ダウンロード先ディレクトリを整形する
        let mut new_dir = dl_dir.clone();
        // ディレクトリ階層を含むオブジェクトの場合はその階層分を作成する
        let obj_prefix = &key.replace(&prefix.clone(), "");
        let key_prefixs = obj_prefix.split("/").into_iter().collect::<Vec<&str>>();
        for i in 0..(key_prefixs.len() - 1) {
            new_dir = new_dir.clone().join(key_prefixs[i]);
            // ディレクトリ作成
            std::fs::create_dir_all(&new_dir).expect("error create sub directory");
        }

        // ファイル名をパスに追加してダウンロード
        __save_object_body(out, new_dir, file_name).await?;
    }

    // ZIPファイル対象の場合は圧縮
    if config.zip_for_folder {
        super::utils::file::to_zip_file(config.save_dir, dl_dir, name)
    }

    Ok(Some(prefix.clone()))
}
