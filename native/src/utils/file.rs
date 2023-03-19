use std::{
    ffi::OsStr,
    io::{Read, Write},
    path::{Path, PathBuf},
};

/// ダウンロードディレクトリ
pub fn download_dir(save_dir: Option<String>, child_dir: Option<String>) -> std::path::PathBuf {
    // 保存先ディレクトリが指定されている場合はそのまま利用し、
    // 指定がない場合はダウンロードディレクトリを使用する
    let mut _dir = match save_dir {
        Some(sd) => std::path::PathBuf::from(sd),
        None => platform_dirs::UserDirs::new().unwrap().download_dir,
    };

    if let Some(cd) = child_dir {
        _dir = _dir.join(cd);
    }
    _dir
}

/// ファイル保存
pub fn save_file(bytes: Vec<u8>, path: &std::path::PathBuf) -> std::io::Result<std::path::PathBuf> {
    // ダウンロード先のディレクトリを作成
    let parent = path.parent().unwrap();
    std::fs::create_dir_all(parent)?;

    // 保存するパス
    let mut new_path = path.clone();

    // ファイルの存在確認を行い、存在する場合は別名のファイルを作成
    if path.exists() {
        loop {
            // 存在しなくなるまでファイル生成をリトライする
            let (p, _) = __new_name_file(&new_path);
            new_path = p.clone();
            if !p.exists() {
                break;
            }
        }
    }

    // ファイルを作成
    let mut file = std::fs::File::create(new_path)?;
    let _ = file.write_all(&bytes)?;

    Ok(path.clone())
}

/// 同一のパス名が存在するかチェックし、存在した場合は新たな名前を払い出す
pub fn build_new_name(path: &PathBuf) -> (PathBuf, String) {
    // 最新パス
    let mut new_path = path.clone();
    let mut file_name = path
        .file_name()
        .unwrap_or(OsStr::new("/"))
        .to_str()
        .unwrap()
        .to_string();

    // ファイルの存在確認を行い、存在する場合は別名のファイルを作成
    if path.exists() {
        loop {
            // 存在しなくなるまでファイル生成をリトライする
            let (p, n) = __new_name_file(&new_path);
            new_path = p.clone();
            if !p.exists() {
                file_name = n;
                break;
            }
        }
    }
    (new_path, file_name)
}

/// ファイル名のチェックおよびファイル名生成
/// 同一のファイル名が存在する場合は新しいファイルを付与
fn __new_name_file(base_path: &PathBuf) -> (PathBuf, String) {
    let user_dirs = PathBuf::from(base_path.parent().unwrap());

    // ファイル名
    let name = base_path.file_name().unwrap().to_str().unwrap();
    let new_name = match base_path.extension() {
        Some(ext) => {
            let r = format!(".{}", ext.to_str().unwrap());
            let replaced = name.replace(r.as_str(), "");
            format!("{}_copy.{}", replaced, ext.to_str().unwrap())
        }
        None => {
            format!("{}_copy", name)
        }
    };

    (user_dirs.join(&new_name), new_name)
}

/// 指定ディレクトリをZIPファイル化
pub fn to_zip_file(save_dir: Option<String>, data_dir: PathBuf, dir_name: String) {
    // ZIPファイル生成
    let dl_dir = download_dir(save_dir, None);
    let zip_file_path = dl_dir.join(format!("{}.zip", &dir_name));
    let zip_file = std::fs::File::create(&zip_file_path).unwrap();
    let mut zip = zip::ZipWriter::new(zip_file);

    // 保存する時にディレクトリ名が入らないよう、置換用のパスを定義
    let parent_dir = data_dir.parent().unwrap().to_str().unwrap().to_string();

    // ZIPファイルに追加するディレクトリのパス
    let add_dir = data_dir.as_path().to_str().unwrap().to_string();
    let walk_dir = walkdir::WalkDir::new(&add_dir);

    // 対象のディレクトリ内のファイルに対して処理
    let mut buffer = Vec::new();
    for entry in walk_dir.into_iter().filter_map(|x| x.ok()) {
        let path = entry.path();
        let name = path
            .strip_prefix(Path::new(&parent_dir))
            .unwrap()
            .as_os_str()
            .to_str()
            .unwrap();

        // ファイル書き込み時のオプション
        let mut options = zip::write::FileOptions::default();

        // ファイルの場合は読み込んでデータを追加
        if path.is_file() {
            println!("adding file {:?} as {:?} ...", path, name);

            // ファイル読み込み
            let mut f = std::fs::File::open(path).expect("file open error");
            f.read_to_end(&mut buffer).expect("file read error");

            // ファイルのメタデータから更新日時を取得
            if let Ok(metadata) = f.metadata() {
                if let Ok(modified) = metadata.modified() {
                    // ローカルタイムに一旦変換
                    let local_dt: chrono::DateTime<chrono::Local> = modified.into();
                    let ts = local_dt.naive_local().timestamp();
                    let t = time::OffsetDateTime::from_unix_timestamp(ts).unwrap();
                    if let Ok(date_time) = zip::DateTime::try_from(t) {
                        options = options.last_modified_time(date_time);
                    }
                }
            }
            // ファイル書き込みを行う
            zip.start_file(name, options).expect("start file error");
            // ZIPファイルに書き込み
            zip.write_all(&*buffer).expect("file write error");
            // バッファをクリア
            buffer.clear();
        } else {
            println!("adding dir {:?} as {:?} ...", path, name);
            zip.add_directory(name, options)
                .expect("error zip add directory");
        }
    }

    // ZIPファイルクローズ
    zip.flush().expect("error zip flush");

    // ZIP化する前のディレクトリを削除
    let _ = std::fs::remove_dir_all(data_dir);
}
