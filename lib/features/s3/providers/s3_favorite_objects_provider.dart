import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_s3_explorer/features/profiles/providers/profile_select_provider.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_io/io.dart';

import 's3_objects_provider.dart';

part 's3_favorite_objects_provider.freezed.dart';

@freezed
class S3FavoriteObject with _$S3FavoriteObject {
  const S3FavoriteObject._();

  const factory S3FavoriteObject({
    // プロファイル名
    required String profileName,

    /// バケット名
    required String bucketName,

    /// 表示するプレフィックス
    required String? prefix,
  }) = _S3FavoriteObject;

  Map<String, dynamic> get toJson => {
        'profileName': profileName,
        'bucketName': bucketName,
        'prefix': prefix,
      };
}

/// 選択中のプロファイル内でお気に入り登録しているリストを返却するProvider
final s3FavoriteListProvider = Provider.autoDispose<List<S3FavoriteObject>>(
  (ref) {
    // 選択中プロファイル
    final profile = ref.watch(awsProfileSelectedProvider);
    if (profile == null) return [];

    // お気に入りの全リスト
    final favoriteMap = ref.watch(s3FavoriteObjectsStateNotifier);

    if (favoriteMap.containsKey(profile.name)) {
      return [...favoriteMap[profile.name]!];
    }
    return [];

    // TODO Mock Data
    // return [
    //   const S3FavoriteObject(
    //     bucketName: 'aws-s3-bucket',
    //     profileName: 'develop',
    //     prefix: 'folder-1',
    //   ),
    //   const S3FavoriteObject(
    //     bucketName: 'aws-s3-bucket',
    //     profileName: 'develop',
    //     prefix: 'folder-4',
    //   ),
    // ];
  },
);

final s3FavoriteObjectsStateNotifier = StateNotifierProvider.autoDispose<
    S3FavoriteObjectsStateNotifier, Map<String, List<S3FavoriteObject>>>(
  (ref) => S3FavoriteObjectsStateNotifier(ref),
);

/// お気に入り登録されたオブジェクト(フォルダを管理)
class S3FavoriteObjectsStateNotifier
    extends StateNotifier<Map<String, List<S3FavoriteObject>>> {
  final Ref ref;
  S3FavoriteObjectsStateNotifier(this.ref) : super({}) {
    fetch();
  }

  Future<File> get _file async {
    // 各OSに対応したドキュメントディレクトリを取得
    final dir = await getApplicationSupportDirectory();
    final file = File('${dir.path}/aws/favorites.json');

    // 存在しない場合は作成
    if (!file.existsSync()) {
      await file.create(recursive: true);
    }
    return file;
  }

  /// 選択中のプロファイルを取得
  Future<void> fetch() async {
    final file = await _file;
    // ファイルの存在チェック
    if (!file.existsSync()) return;

    // ファイルを読み込み、ローカル用のAWS Profile形式に変換
    // ファイルを読み込み、ローカル用のAWS Profile形式に変換
    final data = await file.readAsString();
    if (data.isEmpty) {
      state = {};
      return;
    }
    final result = json.decode(data) as Map<String, dynamic>;
    if (!result.containsKey('favorites')) {
      state = {};
      return;
    }

    Map<String, List<S3FavoriteObject>> map = {};
    final list = result['favorites'] as List<dynamic>;

    for (final x in list) {
      final data = Map<String, dynamic>.from(x);
      final item = S3FavoriteObject(
        profileName: data['profileName'],
        bucketName: data['bucketName'],
        prefix: data['prefix'],
      );

      if (map.containsKey(item.profileName)) {
        map[item.profileName]!.add(item);
      } else {
        map[item.profileName] = [item];
      }
    }
    state = map;
  }

  /// ファイルを更新
  Future<String?> _updateFile(Map<String, List<S3FavoriteObject>> map) async {
    try {
      final list = map.values.expand((x) => x).map((e) => e.toJson).toList();
      final data = {'favorites': list};

      // ファイル書き込みを実施し、完了後にstateを更新
      final file = await _file;
      await file.writeAsString(json.encode(data));

      state = map;
    } catch (ex) {
      return ex.toString();
    }
    return null;
  }

  /// お気に入りリスト更新
  Future<void> update(S3ViewObjects item) async {
    /// バケットとプレフィックスは必須のため未設定の場合は処理なし
    if (item.bucket == null) return;

    // プロファイル取得
    final profile = ref.read(awsProfileSelectedProvider)?.toNative;
    if (profile == null) return;

    final list = state.values.expand((x) => x).toList();
    // 該当のデータが存在するか確認し、追加か削除かを決定する
    final index = list.indexWhere(
      (x) =>
          x.bucketName == item.bucket!.bucket?.name &&
          x.prefix == item.prefix &&
          x.profileName == profile.name,
    );

    final obj = S3FavoriteObject(
      profileName: profile.name,
      bucketName: item.bucket!.bucket!.name,
      prefix: item.prefix,
    );

    if (index < 0) {
      _add(obj);
    } else {
      _remove(obj);
    }
  }

  /// お気に入りリスト追加
  Future<void> _add(S3FavoriteObject obj) async {
    final map = {...state};

    if (map.containsKey(obj.profileName)) {
      map[obj.profileName]!.add(obj);
    } else {
      map[obj.profileName] = [obj];
    }

    // ファイル更新
    await _updateFile(map);
  }

  /// お気に入りリスト削除
  Future<void> _remove(S3FavoriteObject obj) async {
    final map = {...state};

    if (map.containsKey(obj.profileName)) {
      map[obj.profileName]!.remove(obj);
    } else {
      return;
    }

    // ファイル更新
    await _updateFile(map);
  }
}
