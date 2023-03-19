// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_aws_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocalAWSProfile _$LocalAWSProfileFromJson(Map<String, dynamic> json) =>
    LocalAWSProfile(
      name: json['name'] as String,
      region: json['region'] as String,
      accessKeyId: json['accessKeyId'] as String,
      secretAccessKey: json['secretAccessKey'] as String,
      sessionToken: json['sessionToken'] as String?,
      mfaSerial: json['mfaSerial'] as String?,
      expiration: json['expiration'] as String?,
      stsAccessKeyId: json['stsAccessKeyId'] as String?,
      stsSecretAccessKey: json['stsSecretAccessKey'] as String?,
    );

Map<String, dynamic> _$LocalAWSProfileToJson(LocalAWSProfile instance) =>
    <String, dynamic>{
      'name': instance.name,
      'region': instance.region,
      'accessKeyId': instance.accessKeyId,
      'secretAccessKey': instance.secretAccessKey,
      'sessionToken': instance.sessionToken,
      'mfaSerial': instance.mfaSerial,
      'expiration': instance.expiration,
      'stsAccessKeyId': instance.stsAccessKeyId,
      'stsSecretAccessKey': instance.stsSecretAccessKey,
    };
