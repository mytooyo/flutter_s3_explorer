import 'dart:convert';

import 'package:flutter_s3_explorer/bridge/bridge_definitions.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'local_aws_profile.g.dart';

@JsonSerializable()
class LocalAWSProfile {
  final String name, region, accessKeyId, secretAccessKey;
  final String? sessionToken,
      mfaSerial,
      expiration,
      stsAccessKeyId,
      stsSecretAccessKey;

  LocalAWSProfile({
    required this.name,
    required this.region,
    required this.accessKeyId,
    required this.secretAccessKey,
    this.sessionToken,
    this.mfaSerial,
    this.expiration,
    this.stsAccessKeyId,
    this.stsSecretAccessKey,
  });

  factory LocalAWSProfile.fromNative(LocalAWSProfile base, AWSProfile p) {
    return LocalAWSProfile(
      name: base.name,
      region: base.region,
      accessKeyId: base.accessKeyId,
      secretAccessKey: base.secretAccessKey,
      sessionToken: p.sessionToken,
      mfaSerial: base.mfaSerial,
      expiration: p.expiration,
      stsAccessKeyId: p.accessKeyId,
      stsSecretAccessKey: p.secretAccessKey,
    );
  }

  factory LocalAWSProfile.fromJson(Map<String, dynamic> json) =>
      _$LocalAWSProfileFromJson(json);

  /// Connect the generated [_$LocalAWSProfile] function to the `toJson` method.
  Map<String, dynamic> get toJson => _$LocalAWSProfileToJson(this);

  AWSProfile get toNative {
    return AWSProfile(
      name: name,
      region: region,
      accessKeyId: stsAccessKeyId!,
      secretAccessKey: stsSecretAccessKey!,
      sessionToken: sessionToken,
      mfaSerial: mfaSerial,
      expiration: expiration,
    );
  }

  AWSProfile get toStsNative {
    return AWSProfile(
      name: name,
      region: region,
      accessKeyId: accessKeyId,
      secretAccessKey: secretAccessKey,
      sessionToken: sessionToken,
      mfaSerial: mfaSerial,
      expiration: expiration,
    );
  }

  @override
  String toString() {
    return json.encode(toJson);
  }

  String get maskedSecretAccessKey {
    // 最初と最後の4文字のみを表示
    if (secretAccessKey.length < 8) {
      return secretAccessKey;
    }
    final len = secretAccessKey.length;
    final s = secretAccessKey.substring(0, 4);
    final e = secretAccessKey.substring(len - 4, len);

    return s.padRight(len - 8, '*') + e;
  }

  /// 期限切れチェック
  bool get expired {
    if (expiration == null) return true;

    final exp = DateTime.fromMillisecondsSinceEpoch(
      int.parse(expiration!),
    );
    // 期限内であった場合はまだ利用可能であるため再取得は行わない
    return exp.isBefore(DateTime.now());
  }
}
