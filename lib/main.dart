import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';
import 'package:flutter_s3_explorer/bridge/ffi.dart';
import 'package:flutter_s3_explorer/common/providers/error_provider.dart';
import 'package:flutter_s3_explorer/features/profiles/providers/profile_list_provider.dart';
import 'package:flutter_s3_explorer/features/profiles/providers/profile_select_provider.dart';
import 'package:flutter_s3_explorer/features/profiles/views/input_mfa_code_view.dart';
import 'package:flutter_s3_explorer/features/s3/views/s3_main_view.dart';
import 'package:flutter_s3_explorer/models/local_aws_profile.dart';
import 'package:flutter_s3_explorer/ui/error_scope_widget.dart';
import 'package:flutter_s3_explorer/ui/init_view.dart';
import 'package:flutter_s3_explorer/ui/loading_view.dart';

import 'common/providers/init_provider.dart';

void main() {
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter S3 Explorer',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        primaryColor: const Color(0xff13253b),
        scaffoldBackgroundColor: const Color(0xFFe9edf0),
      ),
      debugShowCheckedModeBanner: false,
      home: const ErrorScopeWidget(child: MainPage()),
    );
  }
}

class MainPage extends ConsumerWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      awsProfileSelectedProvider,
      (previous, next) => _profileListen(context, ref, next),
    );

    return const ContentsView();
  }

  void _profileListen(
    BuildContext context,
    WidgetRef ref,
    LocalAWSProfile? p,
  ) async {
    if (p == null) return;

    // 期限チェック
    if (!p.expired) {
      return;
    }

    String? mfaCode;
    // MFAデバイスが設定されている場合はコード入力Widgetを表示
    if (p.mfaSerial != null) {
      final result = await showDialog<String?>(
        context: context,
        builder: (_) => InputMFACodeView(profile: p),
      );
      if (result == null) {
        // メッセージを表示して終了
        return;
      }
      mfaCode = result;
    }

    // ローディング表示
    // ignore: use_build_context_synchronously
    showLoading(context);

    // トークンを更新
    try {
      final nativeProfile = await api.getAwsCredential(
        profile: p.toStsNative,
        mfaCode: mfaCode,
      );

      final newProfile = LocalAWSProfile.fromNative(p, nativeProfile);

      // セッション情報を更新
      ref.read(awsProfileListProvider.notifier).update(newProfile);
      ref.read(errorStateNotifier.notifier).reset();
    } on FfiException catch (ex) {
      ref.read(errorStateNotifier.notifier).setup(
            ErrorState(
              type: ErrorStateType.display,
              message: ex.message,
              retry: () => _profileListen(context, ref, p),
            ),
          );
    } finally {
      hideLoading();
    }
  }
}

class ContentsView extends ConsumerWidget {
  const ContentsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = ref.watch(awsProfileListProvider);

    // 未初期化の場合はローディングを表示
    final inited = ref.watch(initProvider);
    if (!inited) {
      return Scaffold(
        body: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Text(
                  'LOADING...',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (list.isEmpty) {
      return const InitView();
    }

    return const S3MainView();
  }
}
