import 'dart:convert';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_s3_explorer/models/local_aws_profile.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_io/io.dart';

/// 選択中のプロファイル情報
final awsProfileSelectedProvider =
    StateNotifierProvider<AWSProfileSelectStateNotifier, LocalAWSProfile?>(
  (ref) => AWSProfileSelectStateNotifier(ref),
);

class AWSProfileSelectStateNotifier extends StateNotifier<LocalAWSProfile?> {
  AWSProfileSelectStateNotifier(this.ref) : super(null) {
    fetch();
  }

  final Ref ref;

  Future<File> get _file async {
    // 各OSに対応したドキュメントディレクトリを取得
    final dir = await getApplicationSupportDirectory();
    final file = File('${dir.path}/aws/selected.json');

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

    final data = await file.readAsString();
    if (data.isNotEmpty) {
      // ファイルを読み込み、ローカル用のAWS Profile形式に変換
      final result = json.decode(data) as Map<String, dynamic>;
      state = LocalAWSProfile.fromJson(result);
    }
  }

  /// 指定のプロファイルを選択状態として登録
  Future<String?> select(LocalAWSProfile p) async {
    try {
      // ファイル書き込みを実施し、完了後にstateを更新
      final file = await _file;
      await file.writeAsString(json.encode(p.toJson));

      state = p;
    } catch (ex, stackTrace) {
      log('update select file error', error: ex, stackTrace: stackTrace);
      return ex.toString();
    }
    return null;
  }

  /// 選択状態を解除
  Future<void> reset() async {
    final file = await _file;
    // ファイルが存在した場合は削除
    if (file.existsSync()) {
      file.deleteSync();
    }
    state = null;
  }
}
