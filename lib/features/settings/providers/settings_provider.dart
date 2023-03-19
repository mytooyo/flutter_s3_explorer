import 'dart:convert';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_io/io.dart';

part 'settings_provider.freezed.dart';
part 'settings_provider.g.dart';

@freezed
class AppSetting with _$AppSetting {
  const AppSetting._();

  const factory AppSetting({
    String? downloadDir,
    @Default(false) bool zipCompression,
  }) = _AppSetting;

  factory AppSetting.fromJson(Map<String, dynamic> json) =>
      _$AppSettingFromJson(json);
}

final appSettingsProvider =
    StateNotifierProvider<AppSettingStateNotifier, AppSetting>(
  (ref) => AppSettingStateNotifier(ref),
);

class AppSettingStateNotifier extends StateNotifier<AppSetting> {
  AppSettingStateNotifier(this.ref) : super(const AppSetting()) {
    fetch();
  }

  final Ref ref;

  Future<File> get _file async {
    // 各OSに対応したドキュメントディレクトリを取得
    final dir = await getApplicationSupportDirectory();
    final file = File('${dir.path}/app/settings.json');

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
    final data = await file.readAsString();
    if (data.isNotEmpty) {
      final result = json.decode(data) as Map<String, dynamic>;
      state = AppSetting.fromJson(result);
    } else {
      Directory? download;
      if (Platform.isIOS) {
        download = await getApplicationDocumentsDirectory();
      } else {
        download = await getDownloadsDirectory();
      }
      state = state.copyWith(
        downloadDir: download?.path,
      );
    }
  }

  /// ファイル更新
  Future<void> update(String? dir, bool zip) async {
    final data = state.copyWith(
      downloadDir: dir,
      zipCompression: zip,
    );

    try {
      final map = data.toJson();
      // ファイル書き込みを実施し、完了後にstateを更新
      final file = await _file;
      await file.writeAsString(json.encode(map));
    } catch (ex) {
      log(ex.toString());
    }

    state = data;
  }
}
