import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_s3_explorer/common/providers/init_provider.dart';
import 'package:flutter_s3_explorer/models/local_aws_profile.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_io/io.dart';

import 'profile_select_provider.dart';

/// 登録されているプロファイルのリストを取得
final awsProfileListProvider =
    StateNotifierProvider<AWSProfileListStateNotifier, List<LocalAWSProfile>>(
  (ref) => AWSProfileListStateNotifier(ref),
);

class AWSProfileListStateNotifier extends StateNotifier<List<LocalAWSProfile>> {
  AWSProfileListStateNotifier(this.ref) : super([]) {
    fetch();
  }

  final Ref ref;

  Future<File> get _profileFile async {
    // 各OSに対応したドキュメントディレクトリを取得
    final dir = await getApplicationSupportDirectory();
    final file = File('${dir.path}/aws/profiles.json');

    // 存在しない場合は作成
    if (!file.existsSync()) {
      await file.create(recursive: true);
    }
    return file;
  }

  /// リスト取得
  Future<void> fetch() async {
    final file = await _profileFile;
    // ファイルの存在チェック
    if (!file.existsSync()) {
      state = [];
      return;
    }

    // ファイルを読み込み、ローカル用のAWS Profile形式に変換
    final data = await file.readAsString();
    if (data.isNotEmpty) {
      final result = json.decode(data) as Map<String, dynamic>;
      if (result.containsKey('profiles')) {
        state = (result['profiles'] as List<dynamic>)
            .map((x) => LocalAWSProfile.fromJson(Map<String, dynamic>.from(x)))
            .toList();
      } else {
        state = [];
      }
    } else {
      state = [];
    }

    ref.read(initProvider.notifier).state = true;
  }

  /// ファイルを更新
  Future<String?> _updateFile(List<LocalAWSProfile> list) async {
    try {
      // 書き込み用にJSON形式に変換
      final map = {'profiles': list.map((x) => x.toJson).toList()};

      // ファイル書き込みを実施し、完了後にstateを更新
      final file = await _profileFile;
      await file.writeAsString(json.encode(map));

      state = list;
    } catch (ex) {
      return ex.toString();
    }
    return null;
  }

  /// 新たなプロファイルを追加
  Future<String?> _add(LocalAWSProfile p) async {
    // 既に登録されているリストに対して追加
    final list = [...state];

    // 追加可能かのチェック
    if (list.indexWhere((x) => x.name == p.name) >= 0) {
      return 'Error, A profile with the same name has already been registered.';
    }

    list.add(p);
    return await _updateFile(list);
  }

  /// 新たなプロファイルを追加
  Future<String?> remove(LocalAWSProfile p) async {
    // 既に登録されているリストに対して追加
    // 削除時は存在確認はせずにそのまま更新する
    final list = [...state];
    list.removeWhere((x) => x.name == p.name);

    final result = await _updateFile(list);

    // ファイル更新に成功した場合は選択状態の確認
    if (result == null) {
      // 選択中のプロファイルが削除された場合は選択情報を解除
      if (ref.read(awsProfileSelectedProvider)?.name == p.name) {
        await ref.read(awsProfileSelectedProvider.notifier).reset();
      }
    }
    return result;
  }

  /// 指定プロファイルの更新
  Future<String?> update(LocalAWSProfile p) async {
    final list = [...state];

    // 存在するかチェックを行い、存在しない場合は追加処理
    final index = list.indexWhere((x) => x.name == p.name);
    if (index < 0) {
      return await _add(p);
    }
    list[index] = p;
    final result = await _updateFile(list);
    // ファイル更新に成功した場合は選択状態の確認
    if (result == null) {
      // 選択中のプロファイルが削除された場合は選択情報を解除
      if (ref.read(awsProfileSelectedProvider)?.name == p.name) {
        await ref.read(awsProfileSelectedProvider.notifier).select(p);
      }
    }

    return result;
  }
}
