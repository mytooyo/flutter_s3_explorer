pub mod profile;
pub mod s3;

use super::utils;

use aws_config::meta::region::RegionProviderChain;
pub use profile::get_sts_session_token;
pub use profile::CredentialProvider;

/// AWS SDK configを生成
pub async fn get_aws_config(
    provider: profile::CredentialProvider,
    region: String,
) -> aws_types::SdkConfig {
    let region_provider =
        RegionProviderChain::first_try(std::env::var(region).ok().map(aws_sdk_s3::Region::new))
            .or_default_provider()
            .or_else(aws_sdk_s3::Region::new("ap-northeast-1"));
    aws_config::from_env()
        .region(region_provider)
        .credentials_provider(provider.credential_provider())
        .load()
        .await
}
