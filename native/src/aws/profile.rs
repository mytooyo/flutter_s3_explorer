use std::time::UNIX_EPOCH;

pub struct CredentialProvider {
    access_key_id: String,
    secret_access_key: String,
    session_token: Option<String>,
}

impl CredentialProvider {
    pub fn new(access_key_id: impl Into<String>, secret_access_key: impl Into<String>) -> Self {
        CredentialProvider {
            access_key_id: access_key_id.into(),
            secret_access_key: secret_access_key.into(),
            session_token: None,
        }
    }

    pub fn set_token(mut self, token: Option<String>) -> Self {
        self.session_token = token;
        self
    }

    pub fn credential_provider(self) -> aws_credential_types::Credentials {
        aws_credential_types::Credentials::new(
            self.access_key_id,
            self.secret_access_key,
            self.session_token,
            None,
            "flutter_s3_explorer",
        )
    }
}

#[derive(Debug, Clone)]
pub struct AWSProfile {
    pub name: String,
    pub region: String,
    pub access_key_id: String,
    pub secret_access_key: String,
    pub session_token: Option<String>,
    pub mfa_serial: Option<String>,
    pub expiration: Option<String>,
}

pub async fn get_sts_session_token(
    config: &aws_types::SdkConfig,
    profile: AWSProfile,
    mfa_code: Option<String>,
) -> Result<AWSProfile, aws_sdk_sts::types::SdkError<aws_sdk_sts::error::GetSessionTokenError>> {
    // AWS Client
    let client = aws_sdk_sts::Client::new(config);

    // セッショントークン取得リクエスト
    let result = client
        .get_session_token()
        .set_duration_seconds(Some(43200))
        .set_serial_number(profile.mfa_serial.clone())
        .set_token_code(mfa_code)
        .send()
        .await;

    match result {
        Ok(data) => {
            // 新しいプロファイルを定義
            let mut new_profile = profile.clone();

            // STSの結果からクレデンシャルを取得
            let cred = data.credentials().unwrap();

            // 必要な値を更新
            new_profile.access_key_id = cred.access_key_id().unwrap().to_string();
            new_profile.secret_access_key = cred.secret_access_key().unwrap().to_string();
            new_profile.session_token = Some(cred.session_token().unwrap().to_string());

            // 期限がある場合は追加
            if let Some(system_time) = cred.expiration() {
                if let Ok(dtime) = std::time::SystemTime::try_from(*system_time) {
                    if let Ok(time) = dtime.duration_since(UNIX_EPOCH) {
                        new_profile.expiration = Some(time.as_millis().to_string());
                    }
                }
            }

            Ok(new_profile)
        }
        Err(err) => Err(err),
    }
}
