import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_s3_explorer/common/providers/error_provider.dart';

class ErrorScopeWidget extends ConsumerStatefulWidget {
  const ErrorScopeWidget({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  ConsumerState<ErrorScopeWidget> createState() => _ErrorScopeWidgetState();
}

class _ErrorScopeWidgetState extends ConsumerState<ErrorScopeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    // )..addStatusListener((status) {
    //     if (status == AnimationStatus.dismissed) {
    //       ref.read(errorStateNotifier.notifier).reset();
    //     }
    //   });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(errorStateNotifier, (previous, next) {
      if (next != null && next.type == ErrorStateType.popup) {
        controller.forward();

        Future<void>.delayed(const Duration(seconds: 5)).then((_) {
          controller.reverse();
        });
      } else {
        controller.reverse();
      }
    });

    return Stack(
      children: [
        Positioned.fill(child: widget.child),
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 16),
            child: AnimatedBuilder(
              animation: controller,
              builder: (context, child) {
                return SlideTransition(
                  position: controller
                      .drive(
                        CurveTween(curve: Curves.easeInOut),
                      )
                      .drive(
                        Tween<Offset>(
                          begin: const Offset(0, -1.2),
                          end: Offset.zero,
                        ),
                      ),
                  child: FadeTransition(
                    opacity: controller
                        .drive(
                          CurveTween(curve: Curves.easeInOut),
                        )
                        .drive(
                          Tween<double>(begin: 0, end: 1),
                        ),
                    child: _contents(),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _contents() {
    return _card(
      Consumer(
        builder: (context, ref, child) {
          final ex = ref.watch(errorStateNotifier);
          return Row(
            children: [
              Icon(
                Icons.error_outline_rounded,
                color: Theme.of(context).colorScheme.error,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  ex?.message ?? '',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _card(Widget content) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 480,
          ),
          child: Card(
            elevation: 12,
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              width: double.infinity,
              child: content,
            ),
          ),
        ),
      ),
    );
  }
}

class ErrorDisplayWidget extends ConsumerWidget {
  const ErrorDisplayWidget({super.key, required this.err});

  final ErrorState err;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 440,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 72,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                err.message,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      height: 1.6,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  err.retry?.call();
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  fixedSize: const Size(120, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('RETRY'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
