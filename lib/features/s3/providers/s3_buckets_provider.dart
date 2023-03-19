import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_s3_explorer/bridge/ffi.dart';
import 'package:flutter_s3_explorer/features/profiles/providers/profile_select_provider.dart';
import 'package:flutter_s3_explorer/models/local_aws_profile.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 's3_objects_provider.dart';

part 's3_buckets_provider.freezed.dart';

final s3BucketListProvider = FutureProvider<List<S3Bucket>>(
  (ref) async {
    final profile = ref.watch(awsProfileSelectedProvider);
    if (profile == null) return [];

    // 期限切れの場合は空を返却
    if (profile.expired) return [];
    return await api.s3ListBuckets(profile: profile.toNative);

    // TODO Mock Data
    // return [
    //   S3Bucket(
    //     location: 'ap-northeast-1',
    //     createdAt: null,
    //     name: 'aws-s3-bucket',
    //   ),
    //   S3Bucket(
    //     location: 'ap-northeast-1',
    //     createdAt: null,
    //     name: 'aws-s3-bucket-dev01',
    //   ),
    //   S3Bucket(
    //     location: 'ap-northeast-1',
    //     createdAt: null,
    //     name: 'aws-s3-bucket-dev02',
    //   ),
    //   S3Bucket(
    //     location: 'ap-northeast-1',
    //     createdAt: null,
    //     name: 'aws-s3-bucket-dev03',
    //   ),
    // ];
  },
);

@freezed
class S3SelectedBucket with _$S3SelectedBucket {
  const S3SelectedBucket._();

  const factory S3SelectedBucket({
    /// 選択中のバケット
    S3Bucket? bucket,
    LocalAWSProfile? profile,
  }) = _S3SelectedBucket;
}

/// サイドメニューで選択されたバケットを管理するためのProvider
final s3BucketSelectStateNotifier = StateNotifierProvider.autoDispose<
    S3BucketSelectStateNotifier, S3SelectedBucket>(
  (ref) => S3BucketSelectStateNotifier(ref),
);

class S3BucketSelectStateNotifier extends StateNotifier<S3SelectedBucket> {
  final Ref ref;

  S3BucketSelectStateNotifier(this.ref) : super(const S3SelectedBucket());

  /// バケット選択
  void setBucket(LocalAWSProfile profile, S3Bucket? bucket) {
    state = state.copyWith(
      bucket: bucket,
      profile: profile,
    );
    ref.read(s3ObjectsHistoryStateNotifier.notifier).init(state);
  }
}
