import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 初期処理済みか管理するためのプロバイダー
final initProvider = StateProvider<bool>((ref) => false);
