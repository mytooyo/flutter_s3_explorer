import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';
import 'package:flutter_s3_explorer/bridge/ffi.dart';
import 'package:flutter_s3_explorer/common/providers/error_provider.dart';
import 'package:flutter_s3_explorer/features/profiles/providers/profile_select_provider.dart';
import 'package:flutter_s3_explorer/features/s3/providers/s3_downloading_provider.dart';
import 'package:flutter_s3_explorer/features/s3/providers/s3_objects_provider.dart';
import 'package:flutter_s3_explorer/features/settings/providers/settings_provider.dart';

final s3ObjectsController = Provider.autoDispose<S3ObjectsController>(
  (ref) => S3ObjectsController(ref),
);

class S3ObjectsController {
  final Ref ref;

  S3ObjectsController(this.ref);

  /// フォルダ作成
  Future<bool> createFolder(String name) async {
    final profile = ref.read(awsProfileSelectedProvider);
    final object = ref.read(s3BucketObjectSelectedProvider);
    if (profile == null || object == null) return false;

    final result = await api.s3CreateFolder(
      profile: profile.toNative,
      bucketName: object.bucketName!,
      prefix: '${object.prefix}$name/',
    );

    if (result) {
      // 成功した場合は表示をリフレッシュ
      final _ = ref.refresh(s3BucketObjectListProvider);
    }
    return result;
  }

  /// ファイルアップロード
  Future<void> uploadFile() async {
    final profile = ref.read(awsProfileSelectedProvider);
    final object = ref.read(s3BucketObjectSelectedProvider);
    if (profile == null || object == null) return;

    final result = await FilePicker.platform.pickFiles(
      dialogTitle: 'Select file to upload',
    );
    if (result == null || result.files.single.path == null) return;

    await api.s3UploadFile(
      profile: profile.toNative,
      bucketName: object.bucketName!,
      filePath: result.files.single.path!,
      prefix: object.prefix,
    );
    // 表示をリフレッシュ
    final _ = ref.refresh(s3BucketObjectListProvider);
  }

  /// オブジェクト削除
  Future<void> deleteObjects() async {
    // 選択中のオブジェクト
    final list = ref.read(s3BucketObjectSelectedListProvider);
    if (list.isEmpty) return;

    final profile = ref.read(awsProfileSelectedProvider);
    final object = ref.read(s3BucketObjectSelectedProvider);
    if (profile == null || object == null) return;

    // 削除対象のプレフィックスを整形
    final target = list
        .map((e) => object.prefix == null ? e.key : '${object.prefix}${e.key}')
        .toList();

    // 削除リクエスト
    final result = await api.s3DeleteObjects(
      profile: profile.toNative,
      bucketName: object.bucketName!,
      prefixes: target,
    );

    if (result) {
      // 表示をリフレッシュ
      final _ = ref.refresh(s3BucketObjectListProvider);
      ref.read(s3BucketObjectSelectedListProvider.notifier).state = [];
    }
  }

  /// オブジェクトダウンロード
  Future<void> downloadObjects() async {
    // 選択中のオブジェクト
    final list = ref.read(s3BucketObjectSelectedListProvider);
    if (list.isEmpty) return;

    // プロファイルを取得
    final profile = ref.read(awsProfileSelectedProvider);
    final object = ref.read(s3BucketObjectSelectedProvider);
    if (profile == null || object == null) return;

    // 対象のプレフィックスを整形
    final target = list
        .map((e) => object.prefix == null ? e.key : '${object.prefix}${e.key}')
        .toList();

    // アプリの設定情報取得
    final settings = ref.read(appSettingsProvider);

    // ダウンロード開始
    ref.read(s3DownloadingStateNotifier.notifier).start();

    // リクエスト
    try {
      final _ = await api.s3GetObjects(
        profile: profile.toNative,
        bucketName: object.bucketName!,
        prefixes: target,
        config: S3GetObjectConfig(
          saveDir: settings.downloadDir,
          zipForFolder: settings.zipCompression,
        ),
      );

      // ダウンロード終了
      ref.read(s3DownloadingStateNotifier.notifier).end();
    } on FfiException catch (ex) {
      ref.read(errorStateNotifier.notifier).setup(
            ErrorState(
              type: ErrorStateType.popup,
              message: ex.message,
              retry: null,
            ),
          );
      // ダウンロードエラー
      ref.read(s3DownloadingStateNotifier.notifier).error();
    }
  }
}
