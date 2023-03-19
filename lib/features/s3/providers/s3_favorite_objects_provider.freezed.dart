// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 's3_favorite_objects_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$S3FavoriteObject {
// プロファイル名
  String get profileName => throw _privateConstructorUsedError;

  /// バケット名
  String get bucketName => throw _privateConstructorUsedError;

  /// 表示するプレフィックス
  String? get prefix => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $S3FavoriteObjectCopyWith<S3FavoriteObject> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $S3FavoriteObjectCopyWith<$Res> {
  factory $S3FavoriteObjectCopyWith(
          S3FavoriteObject value, $Res Function(S3FavoriteObject) then) =
      _$S3FavoriteObjectCopyWithImpl<$Res, S3FavoriteObject>;
  @useResult
  $Res call({String profileName, String bucketName, String? prefix});
}

/// @nodoc
class _$S3FavoriteObjectCopyWithImpl<$Res, $Val extends S3FavoriteObject>
    implements $S3FavoriteObjectCopyWith<$Res> {
  _$S3FavoriteObjectCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileName = null,
    Object? bucketName = null,
    Object? prefix = freezed,
  }) {
    return _then(_value.copyWith(
      profileName: null == profileName
          ? _value.profileName
          : profileName // ignore: cast_nullable_to_non_nullable
              as String,
      bucketName: null == bucketName
          ? _value.bucketName
          : bucketName // ignore: cast_nullable_to_non_nullable
              as String,
      prefix: freezed == prefix
          ? _value.prefix
          : prefix // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_S3FavoriteObjectCopyWith<$Res>
    implements $S3FavoriteObjectCopyWith<$Res> {
  factory _$$_S3FavoriteObjectCopyWith(
          _$_S3FavoriteObject value, $Res Function(_$_S3FavoriteObject) then) =
      __$$_S3FavoriteObjectCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String profileName, String bucketName, String? prefix});
}

/// @nodoc
class __$$_S3FavoriteObjectCopyWithImpl<$Res>
    extends _$S3FavoriteObjectCopyWithImpl<$Res, _$_S3FavoriteObject>
    implements _$$_S3FavoriteObjectCopyWith<$Res> {
  __$$_S3FavoriteObjectCopyWithImpl(
      _$_S3FavoriteObject _value, $Res Function(_$_S3FavoriteObject) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileName = null,
    Object? bucketName = null,
    Object? prefix = freezed,
  }) {
    return _then(_$_S3FavoriteObject(
      profileName: null == profileName
          ? _value.profileName
          : profileName // ignore: cast_nullable_to_non_nullable
              as String,
      bucketName: null == bucketName
          ? _value.bucketName
          : bucketName // ignore: cast_nullable_to_non_nullable
              as String,
      prefix: freezed == prefix
          ? _value.prefix
          : prefix // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$_S3FavoriteObject extends _S3FavoriteObject {
  const _$_S3FavoriteObject(
      {required this.profileName,
      required this.bucketName,
      required this.prefix})
      : super._();

// プロファイル名
  @override
  final String profileName;

  /// バケット名
  @override
  final String bucketName;

  /// 表示するプレフィックス
  @override
  final String? prefix;

  @override
  String toString() {
    return 'S3FavoriteObject(profileName: $profileName, bucketName: $bucketName, prefix: $prefix)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_S3FavoriteObject &&
            (identical(other.profileName, profileName) ||
                other.profileName == profileName) &&
            (identical(other.bucketName, bucketName) ||
                other.bucketName == bucketName) &&
            (identical(other.prefix, prefix) || other.prefix == prefix));
  }

  @override
  int get hashCode => Object.hash(runtimeType, profileName, bucketName, prefix);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_S3FavoriteObjectCopyWith<_$_S3FavoriteObject> get copyWith =>
      __$$_S3FavoriteObjectCopyWithImpl<_$_S3FavoriteObject>(this, _$identity);
}

abstract class _S3FavoriteObject extends S3FavoriteObject {
  const factory _S3FavoriteObject(
      {required final String profileName,
      required final String bucketName,
      required final String? prefix}) = _$_S3FavoriteObject;
  const _S3FavoriteObject._() : super._();

  @override // プロファイル名
  String get profileName;
  @override

  /// バケット名
  String get bucketName;
  @override

  /// 表示するプレフィックス
  String? get prefix;
  @override
  @JsonKey(ignore: true)
  _$$_S3FavoriteObjectCopyWith<_$_S3FavoriteObject> get copyWith =>
      throw _privateConstructorUsedError;
}
