import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_s3_explorer/bridge/ffi.dart';
import 'package:flutter_s3_explorer/features/profiles/providers/profile_select_provider.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 's3_buckets_provider.dart';
import 's3_favorite_objects_provider.dart';

part 's3_objects_provider.freezed.dart';

@freezed
class S3ViewObjects with _$S3ViewObjects {
  const S3ViewObjects._();

  const factory S3ViewObjects({
    /// 選択中のバケット
    S3SelectedBucket? bucket,

    /// 表示するプレフィックス
    String? prefix,
  }) = _S3ViewObjects;

  List<String> get pathes {
    String? p = prefix;
    if (prefix?.endsWith('/') ?? false) {
      p = prefix!.substring(0, prefix!.length - 1);
    }

    return [
      bucket?.bucket?.name ?? '',
      ...(p?.split('/').toList() ?? []),
    ];
  }

  String? get bucketName {
    return bucket?.bucket?.name;
  }
}

/// オブジェクトの表示履歴
@freezed
class S3ViewObjectsHistory with _$S3ViewObjectsHistory {
  const S3ViewObjectsHistory._();

  const factory S3ViewObjectsHistory({
    @Default([]) List<S3ViewObjects> histories,
  }) = _S3ViewObjectsHistory;
}

/// オブジェクト表示履歴管理用のProvider
final s3ObjectsHistoryStateNotifier = StateNotifierProvider.autoDispose<
    S3ViewObjectsHistoryStateNotifier, S3ViewObjectsHistory>(
  (ref) => S3ViewObjectsHistoryStateNotifier(ref),
);

class S3ViewObjectsHistoryStateNotifier
    extends StateNotifier<S3ViewObjectsHistory> {
  final Ref ref;
  S3ViewObjectsHistoryStateNotifier(this.ref)
      : super(const S3ViewObjectsHistory());

  /// バケット選択時の初期化
  void init(S3SelectedBucket bucket) {
    final list = [S3ViewObjects(bucket: bucket)];
    state = state.copyWith(histories: list);
  }

  /// 前のページに戻る
  void previous() {
    final list = [...state.histories];
    if (list.length <= 1) return;

    list.removeLast();
    state = state.copyWith(histories: list);
  }

  /// ページ遷移
  void _move(S3ViewObjects next) {
    final list = [...state.histories];
    list.add(next);
    state = state.copyWith(histories: list);

    ref.read(s3BucketObjectSelectedListProvider.notifier).state = [];
  }

  /// 指定のプレフィックスへページ遷移
  Future<void> move(String prefix) async {
    final page = state.histories.last;
    final p = '${page.prefix ?? ''}$prefix';

    // 次のページを追加
    _move(
      S3ViewObjects(
        bucket: page.bucket,
        prefix: p,
      ),
    );
  }

  /// パスから指定のページへ遷移
  Future<void> moveByPath(S3ViewObjects obj, String? p) async {
    _move(
      S3ViewObjects(
        bucket: obj.bucket,
        prefix: p,
      ),
    );
  }

  /// 指定のお気に入りのページへ遷移
  Future<void> moveByFavorite(S3FavoriteObject item) async {
    /// S3リストから対象のバケットを取得
    final bucketList = await ref.read(s3BucketListProvider.future);
    final bucket = bucketList.firstWhereOrNull(
      (x) => x.name == item.bucketName,
    );
    // バケットが存在しない場合は移動しない
    if (bucket == null) return;

    final profile = ref.read(awsProfileSelectedProvider);
    if (profile == null) return;

    ref.read(s3BucketSelectStateNotifier.notifier).setBucket(profile, bucket);

    // 次のページを追加
    _move(
      S3ViewObjects(
        bucket: S3SelectedBucket(
          bucket: bucket,
          profile: profile,
        ),
        prefix: item.prefix,
      ),
    );
  }
}

final s3BucketObjectSelectedProvider = Provider.autoDispose<S3ViewObjects?>(
  (ref) {
    final list = ref.watch(
      s3ObjectsHistoryStateNotifier.select((x) => x.histories),
    );
    if (list.isEmpty) return null;
    return list.last;
  },
);

/// S3オブジェクトを取得するProvider
final s3BucketObjectListProvider = FutureProvider.autoDispose<List<S3Object>>(
  (ref) async {
    final list = ref.watch(
      s3ObjectsHistoryStateNotifier.select((x) => x.histories),
    );
    if (list.isEmpty) return [];

    // 表示しているページのオブジェクト取得
    final next = list.last;

    // プロファイル取得
    final profile = ref.read(awsProfileSelectedProvider)?.toNative;
    if (profile == null) return [];

    final data = await api.s3ListObjects(
      profile: profile,
      bucket: next.bucket!.bucket!,
      prefix: next.prefix,
    );
    return data;

    // TODO Mock Data
    // return [
    //   S3Object(
    //     isFolder: true,
    //     key: 'folder-1',
    //     lastModified: '1677628800000',
    //   ),
    //   S3Object(
    //     isFolder: true,
    //     key: 'folder-2',
    //     lastModified: '1677628800000',
    //   ),
    //   S3Object(
    //     isFolder: true,
    //     key: 'folder-3',
    //     lastModified: '1677628800000',
    //   ),
    //   S3Object(
    //     isFolder: true,
    //     key: 'folder-4',
    //     lastModified: '1677628800000',
    //   ),
    //   S3Object(
    //     isFolder: false,
    //     key: 'file-1',
    //     lastModified: '1680307200000',
    //   ),
    //   S3Object(
    //     isFolder: false,
    //     key: 'file-2',
    //     lastModified: '1680307200000',
    //   ),
    //   S3Object(
    //     isFolder: false,
    //     key: 'file-3',
    //     lastModified: '1680307200000',
    //   ),
    // ];
  },
);

/// リスト内で選択しているインデックス
final s3BucketObjectSelectedListProvider =
    StateProvider.autoDispose<List<S3Object>>(
  (ref) => [],
);
