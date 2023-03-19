import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_s3_explorer/features/s3/providers/s3_downloading_provider.dart';

class S3DownloadingWidget extends ConsumerStatefulWidget {
  const S3DownloadingWidget({super.key});

  @override
  ConsumerState<S3DownloadingWidget> createState() =>
      _S3DownloadingWidgetState();
}

class _S3DownloadingWidgetState extends ConsumerState<S3DownloadingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  Widget? contents;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      s3DownloadingStateNotifier,
      (prev, next) {
        if (next == S3DownloadingType.downloading) {
          controller.forward();
        } else if (next == S3DownloadingType.finish) {
          controller.reverse();
        }
      },
    );

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return SlideTransition(
          position: controller
              .drive(
                CurveTween(curve: Curves.easeInOutCubic),
              )
              .drive(
                Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero),
              ),
          child: child!,
        );
      },
      child: _container(),
    );
  }

  Widget _container() {
    return Consumer(
      builder: (context, ref, child) {
        final t = ref.watch(s3DownloadingStateNotifier);
        switch (t) {
          case S3DownloadingType.downloading:
            contents = _card(_downloading(context));
            break;
          case S3DownloadingType.complete:
            contents = _card(_finish(context));
            break;
          case S3DownloadingType.failed:
            contents = _card(_error(context));
            break;
          case S3DownloadingType.finish:
            break;
          default:
            return const SizedBox();
        }
        if (contents == null) return const SizedBox();
        return contents!;
      },
    );
  }

  Widget _card(Widget child) {
    return Card(
      elevation: 8,
      margin: EdgeInsets.zero,
      child: Container(
        height: 56 + MediaQuery.of(context).padding.bottom,
        constraints: const BoxConstraints(
          maxWidth: 600,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }

  Widget _error(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.error_rounded,
          size: 20,
          color: Theme.of(context).colorScheme.error,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(
            'Download failed...😢',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      ],
    );
  }

  Widget _finish(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.check_circle_rounded,
          size: 20,
          color: Theme.of(context).primaryColor,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(
            'Complete!',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ],
    );
  }

  Widget _downloading(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: const LinearProgressIndicator(
              minHeight: 6,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 24),
          child: Text(
            'Downloading...',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}
