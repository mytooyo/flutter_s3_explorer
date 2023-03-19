import 'package:flutter_riverpod/flutter_riverpod.dart';

enum S3DownloadingType { none, downloading, complete, failed, finish }

final s3DownloadingStateNotifier = StateNotifierProvider.autoDispose<
    S3DownloadingStateNotifier, S3DownloadingType>(
  (ref) => S3DownloadingStateNotifier(ref),
);

class S3DownloadingStateNotifier extends StateNotifier<S3DownloadingType> {
  final Ref ref;

  S3DownloadingStateNotifier(this.ref) : super(S3DownloadingType.none);

  void start() {
    state = S3DownloadingType.downloading;
  }

  void end() {
    state = S3DownloadingType.complete;
    _completion(3);
  }

  void error() {
    state = S3DownloadingType.failed;
    _completion(5);
  }

  void _completion(int seconds) {
    Future<void>.delayed(Duration(seconds: seconds)).then((_) {
      state = S3DownloadingType.finish;

      Future<void>.delayed(const Duration(seconds: 1)).then((_) {
        state = S3DownloadingType.none;
      });
    });
  }
}
