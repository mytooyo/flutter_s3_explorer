// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

AppSetting _$AppSettingFromJson(Map<String, dynamic> json) {
  return _AppSetting.fromJson(json);
}

/// @nodoc
mixin _$AppSetting {
  String? get downloadDir => throw _privateConstructorUsedError;
  bool get zipCompression => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AppSettingCopyWith<AppSetting> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppSettingCopyWith<$Res> {
  factory $AppSettingCopyWith(
          AppSetting value, $Res Function(AppSetting) then) =
      _$AppSettingCopyWithImpl<$Res, AppSetting>;
  @useResult
  $Res call({String? downloadDir, bool zipCompression});
}

/// @nodoc
class _$AppSettingCopyWithImpl<$Res, $Val extends AppSetting>
    implements $AppSettingCopyWith<$Res> {
  _$AppSettingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? downloadDir = freezed,
    Object? zipCompression = null,
  }) {
    return _then(_value.copyWith(
      downloadDir: freezed == downloadDir
          ? _value.downloadDir
          : downloadDir // ignore: cast_nullable_to_non_nullable
              as String?,
      zipCompression: null == zipCompression
          ? _value.zipCompression
          : zipCompression // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_AppSettingCopyWith<$Res>
    implements $AppSettingCopyWith<$Res> {
  factory _$$_AppSettingCopyWith(
          _$_AppSetting value, $Res Function(_$_AppSetting) then) =
      __$$_AppSettingCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? downloadDir, bool zipCompression});
}

/// @nodoc
class __$$_AppSettingCopyWithImpl<$Res>
    extends _$AppSettingCopyWithImpl<$Res, _$_AppSetting>
    implements _$$_AppSettingCopyWith<$Res> {
  __$$_AppSettingCopyWithImpl(
      _$_AppSetting _value, $Res Function(_$_AppSetting) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? downloadDir = freezed,
    Object? zipCompression = null,
  }) {
    return _then(_$_AppSetting(
      downloadDir: freezed == downloadDir
          ? _value.downloadDir
          : downloadDir // ignore: cast_nullable_to_non_nullable
              as String?,
      zipCompression: null == zipCompression
          ? _value.zipCompression
          : zipCompression // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_AppSetting extends _AppSetting {
  const _$_AppSetting({this.downloadDir, this.zipCompression = false})
      : super._();

  factory _$_AppSetting.fromJson(Map<String, dynamic> json) =>
      _$$_AppSettingFromJson(json);

  @override
  final String? downloadDir;
  @override
  @JsonKey()
  final bool zipCompression;

  @override
  String toString() {
    return 'AppSetting(downloadDir: $downloadDir, zipCompression: $zipCompression)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_AppSetting &&
            (identical(other.downloadDir, downloadDir) ||
                other.downloadDir == downloadDir) &&
            (identical(other.zipCompression, zipCompression) ||
                other.zipCompression == zipCompression));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, downloadDir, zipCompression);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_AppSettingCopyWith<_$_AppSetting> get copyWith =>
      __$$_AppSettingCopyWithImpl<_$_AppSetting>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_AppSettingToJson(
      this,
    );
  }
}

abstract class _AppSetting extends AppSetting {
  const factory _AppSetting(
      {final String? downloadDir, final bool zipCompression}) = _$_AppSetting;
  const _AppSetting._() : super._();

  factory _AppSetting.fromJson(Map<String, dynamic> json) =
      _$_AppSetting.fromJson;

  @override
  String? get downloadDir;
  @override
  bool get zipCompression;
  @override
  @JsonKey(ignore: true)
  _$$_AppSettingCopyWith<_$_AppSetting> get copyWith =>
      throw _privateConstructorUsedError;
}
