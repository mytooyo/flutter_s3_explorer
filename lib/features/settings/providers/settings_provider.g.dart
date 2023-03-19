// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_provider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_AppSetting _$$_AppSettingFromJson(Map<String, dynamic> json) =>
    _$_AppSetting(
      downloadDir: json['downloadDir'] as String?,
      zipCompression: json['zipCompression'] as bool? ?? false,
    );

Map<String, dynamic> _$$_AppSettingToJson(_$_AppSetting instance) =>
    <String, dynamic>{
      'downloadDir': instance.downloadDir,
      'zipCompression': instance.zipCompression,
    };
