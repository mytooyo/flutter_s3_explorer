// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 's3_objects_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$S3ViewObjects {
  /// 選択中のバケット
  S3SelectedBucket? get bucket => throw _privateConstructorUsedError;

  /// 表示するプレフィックス
  String? get prefix => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $S3ViewObjectsCopyWith<S3ViewObjects> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $S3ViewObjectsCopyWith<$Res> {
  factory $S3ViewObjectsCopyWith(
          S3ViewObjects value, $Res Function(S3ViewObjects) then) =
      _$S3ViewObjectsCopyWithImpl<$Res, S3ViewObjects>;
  @useResult
  $Res call({S3SelectedBucket? bucket, String? prefix});

  $S3SelectedBucketCopyWith<$Res>? get bucket;
}

/// @nodoc
class _$S3ViewObjectsCopyWithImpl<$Res, $Val extends S3ViewObjects>
    implements $S3ViewObjectsCopyWith<$Res> {
  _$S3ViewObjectsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bucket = freezed,
    Object? prefix = freezed,
  }) {
    return _then(_value.copyWith(
      bucket: freezed == bucket
          ? _value.bucket
          : bucket // ignore: cast_nullable_to_non_nullable
              as S3SelectedBucket?,
      prefix: freezed == prefix
          ? _value.prefix
          : prefix // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $S3SelectedBucketCopyWith<$Res>? get bucket {
    if (_value.bucket == null) {
      return null;
    }

    return $S3SelectedBucketCopyWith<$Res>(_value.bucket!, (value) {
      return _then(_value.copyWith(bucket: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_S3ViewObjectsCopyWith<$Res>
    implements $S3ViewObjectsCopyWith<$Res> {
  factory _$$_S3ViewObjectsCopyWith(
          _$_S3ViewObjects value, $Res Function(_$_S3ViewObjects) then) =
      __$$_S3ViewObjectsCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({S3SelectedBucket? bucket, String? prefix});

  @override
  $S3SelectedBucketCopyWith<$Res>? get bucket;
}

/// @nodoc
class __$$_S3ViewObjectsCopyWithImpl<$Res>
    extends _$S3ViewObjectsCopyWithImpl<$Res, _$_S3ViewObjects>
    implements _$$_S3ViewObjectsCopyWith<$Res> {
  __$$_S3ViewObjectsCopyWithImpl(
      _$_S3ViewObjects _value, $Res Function(_$_S3ViewObjects) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bucket = freezed,
    Object? prefix = freezed,
  }) {
    return _then(_$_S3ViewObjects(
      bucket: freezed == bucket
          ? _value.bucket
          : bucket // ignore: cast_nullable_to_non_nullable
              as S3SelectedBucket?,
      prefix: freezed == prefix
          ? _value.prefix
          : prefix // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$_S3ViewObjects extends _S3ViewObjects {
  const _$_S3ViewObjects({this.bucket, this.prefix}) : super._();

  /// 選択中のバケット
  @override
  final S3SelectedBucket? bucket;

  /// 表示するプレフィックス
  @override
  final String? prefix;

  @override
  String toString() {
    return 'S3ViewObjects(bucket: $bucket, prefix: $prefix)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_S3ViewObjects &&
            (identical(other.bucket, bucket) || other.bucket == bucket) &&
            (identical(other.prefix, prefix) || other.prefix == prefix));
  }

  @override
  int get hashCode => Object.hash(runtimeType, bucket, prefix);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_S3ViewObjectsCopyWith<_$_S3ViewObjects> get copyWith =>
      __$$_S3ViewObjectsCopyWithImpl<_$_S3ViewObjects>(this, _$identity);
}

abstract class _S3ViewObjects extends S3ViewObjects {
  const factory _S3ViewObjects(
      {final S3SelectedBucket? bucket,
      final String? prefix}) = _$_S3ViewObjects;
  const _S3ViewObjects._() : super._();

  @override

  /// 選択中のバケット
  S3SelectedBucket? get bucket;
  @override

  /// 表示するプレフィックス
  String? get prefix;
  @override
  @JsonKey(ignore: true)
  _$$_S3ViewObjectsCopyWith<_$_S3ViewObjects> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$S3ViewObjectsHistory {
  List<S3ViewObjects> get histories => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $S3ViewObjectsHistoryCopyWith<S3ViewObjectsHistory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $S3ViewObjectsHistoryCopyWith<$Res> {
  factory $S3ViewObjectsHistoryCopyWith(S3ViewObjectsHistory value,
          $Res Function(S3ViewObjectsHistory) then) =
      _$S3ViewObjectsHistoryCopyWithImpl<$Res, S3ViewObjectsHistory>;
  @useResult
  $Res call({List<S3ViewObjects> histories});
}

/// @nodoc
class _$S3ViewObjectsHistoryCopyWithImpl<$Res,
        $Val extends S3ViewObjectsHistory>
    implements $S3ViewObjectsHistoryCopyWith<$Res> {
  _$S3ViewObjectsHistoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? histories = null,
  }) {
    return _then(_value.copyWith(
      histories: null == histories
          ? _value.histories
          : histories // ignore: cast_nullable_to_non_nullable
              as List<S3ViewObjects>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_S3ViewObjectsHistoryCopyWith<$Res>
    implements $S3ViewObjectsHistoryCopyWith<$Res> {
  factory _$$_S3ViewObjectsHistoryCopyWith(_$_S3ViewObjectsHistory value,
          $Res Function(_$_S3ViewObjectsHistory) then) =
      __$$_S3ViewObjectsHistoryCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<S3ViewObjects> histories});
}

/// @nodoc
class __$$_S3ViewObjectsHistoryCopyWithImpl<$Res>
    extends _$S3ViewObjectsHistoryCopyWithImpl<$Res, _$_S3ViewObjectsHistory>
    implements _$$_S3ViewObjectsHistoryCopyWith<$Res> {
  __$$_S3ViewObjectsHistoryCopyWithImpl(_$_S3ViewObjectsHistory _value,
      $Res Function(_$_S3ViewObjectsHistory) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? histories = null,
  }) {
    return _then(_$_S3ViewObjectsHistory(
      histories: null == histories
          ? _value._histories
          : histories // ignore: cast_nullable_to_non_nullable
              as List<S3ViewObjects>,
    ));
  }
}

/// @nodoc

class _$_S3ViewObjectsHistory extends _S3ViewObjectsHistory {
  const _$_S3ViewObjectsHistory(
      {final List<S3ViewObjects> histories = const []})
      : _histories = histories,
        super._();

  final List<S3ViewObjects> _histories;
  @override
  @JsonKey()
  List<S3ViewObjects> get histories {
    if (_histories is EqualUnmodifiableListView) return _histories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_histories);
  }

  @override
  String toString() {
    return 'S3ViewObjectsHistory(histories: $histories)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_S3ViewObjectsHistory &&
            const DeepCollectionEquality()
                .equals(other._histories, _histories));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_histories));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_S3ViewObjectsHistoryCopyWith<_$_S3ViewObjectsHistory> get copyWith =>
      __$$_S3ViewObjectsHistoryCopyWithImpl<_$_S3ViewObjectsHistory>(
          this, _$identity);
}

abstract class _S3ViewObjectsHistory extends S3ViewObjectsHistory {
  const factory _S3ViewObjectsHistory({final List<S3ViewObjects> histories}) =
      _$_S3ViewObjectsHistory;
  const _S3ViewObjectsHistory._() : super._();

  @override
  List<S3ViewObjects> get histories;
  @override
  @JsonKey(ignore: true)
  _$$_S3ViewObjectsHistoryCopyWith<_$_S3ViewObjectsHistory> get copyWith =>
      throw _privateConstructorUsedError;
}
