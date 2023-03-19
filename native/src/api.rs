use std::error::Error;

use crate::aws;
use anyhow::bail;
pub use aws::profile::AWSProfile;

#[tokio::main(flavor = "current_thread")]
pub async fn get_aws_credential(
    profile: AWSProfile,
    mfa_code: Option<String>,
) -> anyhow::Result<AWSProfile> {
    let provider = aws::CredentialProvider::new(&profile.access_key_id, &profile.secret_access_key);
    let config = aws::get_aws_config(provider, profile.region.clone()).await;

    match aws::get_sts_session_token(&config, profile, mfa_code).await {
        Ok(p) => anyhow::Ok(p),
        Err(err) => {
            println!("profile error: {:?}", err);
            let err_str = format!("{:?}", err.source().unwrap());
            bail!(err_str);
        }
    }
}

#[tokio::main(flavor = "current_thread")]
pub async fn s3_list_buckets(profile: AWSProfile) -> anyhow::Result<Vec<aws::s3::S3Bucket>> {
    match aws::s3::list_buckets(profile).await {
        Ok(list) => anyhow::Ok(list),
        Err(err) => {
            println!("s3 list bucket error: {:?}", err);
            let err_str = format!("{:?}", err.source().unwrap());
            bail!(err_str);
        }
    }
}

#[tokio::main(flavor = "current_thread")]
pub async fn s3_list_objects(
    profile: AWSProfile,
    bucket: aws::s3::S3Bucket,
    prefix: Option<String>,
) -> anyhow::Result<Vec<aws::s3::S3Object>> {
    match aws::s3::list_objects(profile, bucket, prefix).await {
        Ok(list) => anyhow::Ok(list),
        Err(err) => {
            println!("s3 list object error: {:?}", err);
            let err_str = format!("{:?}", err.source().unwrap());
            bail!(err_str);
        }
    }
}

#[tokio::main(flavor = "current_thread")]
pub async fn s3_create_folder(
    profile: AWSProfile,
    bucket_name: String,
    prefix: String,
) -> anyhow::Result<bool> {
    match aws::s3::create_folder(profile, bucket_name, prefix).await {
        Ok(list) => anyhow::Ok(list),
        Err(err) => {
            println!("s3 create folder error: {:?}", err);
            let err_str = format!("{:?}", err.source().unwrap());
            bail!(err_str);
        }
    }
}

#[tokio::main(flavor = "current_thread")]
pub async fn s3_upload_file(
    profile: AWSProfile,
    bucket_name: String,
    prefix: Option<String>,
    file_path: String,
) -> anyhow::Result<bool> {
    match aws::s3::upload_file(profile, bucket_name, prefix, file_path).await {
        Ok(list) => anyhow::Ok(list),
        Err(err) => {
            println!("s3 upload file error: {:?}", err);
            let err_str = format!("{:?}", err.source().unwrap());
            bail!(err_str);
        }
    }
}

#[tokio::main(flavor = "current_thread")]
pub async fn s3_delete_objects(
    profile: AWSProfile,
    bucket_name: String,
    prefixes: Vec<String>,
) -> anyhow::Result<bool> {
    match aws::s3::delete_objects(profile, bucket_name, prefixes).await {
        Ok(list) => anyhow::Ok(list),
        Err(err) => {
            println!("s3 delete objects error: {:?}", err);
            let err_str = format!("{:?}", err.source().unwrap());
            bail!(err_str);
        }
    }
}

#[tokio::main(flavor = "current_thread")]
pub async fn s3_get_objects(
    profile: AWSProfile,
    bucket_name: String,
    prefixes: Vec<String>,
    config: aws::s3::S3GetObjectConfig,
) -> anyhow::Result<Vec<String>> {
    // 指定分をダウンロード
    for prefix in prefixes.clone() {
        // フォルダの場合
        if prefix.ends_with("/") {
            let res = aws::s3::get_objects_folder(
                profile.clone(),
                bucket_name.clone(),
                prefix,
                config.clone(),
            )
            .await;
            if res.is_err() {
                return Err(anyhow::Error::new(res.err().unwrap()));
            }
        } else {
            let res =
                aws::s3::get_object(profile.clone(), bucket_name.clone(), prefix, config.clone())
                    .await;
            if res.is_err() {
                let err_str = format!("{:?}", res.err().unwrap().source().unwrap());
                bail!(err_str);
            }
        }
    }
    anyhow::Ok(prefixes)
}
