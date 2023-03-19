// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 's3_buckets_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$S3SelectedBucket {
  /// 選択中のバケット
  S3Bucket? get bucket => throw _privateConstructorUsedError;
  LocalAWSProfile? get profile => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $S3SelectedBucketCopyWith<S3SelectedBucket> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $S3SelectedBucketCopyWith<$Res> {
  factory $S3SelectedBucketCopyWith(
          S3SelectedBucket value, $Res Function(S3SelectedBucket) then) =
      _$S3SelectedBucketCopyWithImpl<$Res, S3SelectedBucket>;
  @useResult
  $Res call({S3Bucket? bucket, LocalAWSProfile? profile});
}

/// @nodoc
class _$S3SelectedBucketCopyWithImpl<$Res, $Val extends S3SelectedBucket>
    implements $S3SelectedBucketCopyWith<$Res> {
  _$S3SelectedBucketCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bucket = freezed,
    Object? profile = freezed,
  }) {
    return _then(_value.copyWith(
      bucket: freezed == bucket
          ? _value.bucket
          : bucket // ignore: cast_nullable_to_non_nullable
              as S3Bucket?,
      profile: freezed == profile
          ? _value.profile
          : profile // ignore: cast_nullable_to_non_nullable
              as LocalAWSProfile?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_S3SelectedBucketCopyWith<$Res>
    implements $S3SelectedBucketCopyWith<$Res> {
  factory _$$_S3SelectedBucketCopyWith(
          _$_S3SelectedBucket value, $Res Function(_$_S3SelectedBucket) then) =
      __$$_S3SelectedBucketCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({S3Bucket? bucket, LocalAWSProfile? profile});
}

/// @nodoc
class __$$_S3SelectedBucketCopyWithImpl<$Res>
    extends _$S3SelectedBucketCopyWithImpl<$Res, _$_S3SelectedBucket>
    implements _$$_S3SelectedBucketCopyWith<$Res> {
  __$$_S3SelectedBucketCopyWithImpl(
      _$_S3SelectedBucket _value, $Res Function(_$_S3SelectedBucket) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bucket = freezed,
    Object? profile = freezed,
  }) {
    return _then(_$_S3SelectedBucket(
      bucket: freezed == bucket
          ? _value.bucket
          : bucket // ignore: cast_nullable_to_non_nullable
              as S3Bucket?,
      profile: freezed == profile
          ? _value.profile
          : profile // ignore: cast_nullable_to_non_nullable
              as LocalAWSProfile?,
    ));
  }
}

/// @nodoc

class _$_S3SelectedBucket extends _S3SelectedBucket {
  const _$_S3SelectedBucket({this.bucket, this.profile}) : super._();

  /// 選択中のバケット
  @override
  final S3Bucket? bucket;
  @override
  final LocalAWSProfile? profile;

  @override
  String toString() {
    return 'S3SelectedBucket(bucket: $bucket, profile: $profile)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_S3SelectedBucket &&
            (identical(other.bucket, bucket) || other.bucket == bucket) &&
            (identical(other.profile, profile) || other.profile == profile));
  }

  @override
  int get hashCode => Object.hash(runtimeType, bucket, profile);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_S3SelectedBucketCopyWith<_$_S3SelectedBucket> get copyWith =>
      __$$_S3SelectedBucketCopyWithImpl<_$_S3SelectedBucket>(this, _$identity);
}

abstract class _S3SelectedBucket extends S3SelectedBucket {
  const factory _S3SelectedBucket(
      {final S3Bucket? bucket,
      final LocalAWSProfile? profile}) = _$_S3SelectedBucket;
  const _S3SelectedBucket._() : super._();

  @override

  /// 選択中のバケット
  S3Bucket? get bucket;
  @override
  LocalAWSProfile? get profile;
  @override
  @JsonKey(ignore: true)
  _$$_S3SelectedBucketCopyWith<_$_S3SelectedBucket> get copyWith =>
      throw _privateConstructorUsedError;
}
