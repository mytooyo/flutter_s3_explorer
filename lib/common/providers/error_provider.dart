import 'package:flutter_riverpod/flutter_riverpod.dart';

final errorStateNotifier =
    StateNotifierProvider.autoDispose<ErrorStateNotifier, ErrorState?>(
  (ref) => ErrorStateNotifier(ref),
);

class ErrorStateNotifier extends StateNotifier<ErrorState?> {
  final Ref ref;
  ErrorStateNotifier(this.ref) : super(null);

  /// 例外設定
  void setup(ErrorState err) {
    state = err;
  }

  void reset() => state = null;
}

class ErrorState {
  final ErrorStateType type;
  final String message;
  final void Function()? retry;

  ErrorState({
    required this.type,
    required this.message,
    required this.retry,
  });
}

enum ErrorStateType { popup, display }
