import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class BaseDialogView<T> extends ConsumerStatefulWidget {
  const BaseDialogView({super.key});
}

abstract class BaseDialogViewState<T extends BaseDialogView>
    extends ConsumerState<T> {
  double get width;
  double get height;

  EdgeInsetsGeometry? get padding => null;

  @override
  Widget build(BuildContext context) {
    final buttons = actionButtons;
    Widget? actions;
    if (buttons.isNotEmpty) {
      actions = Container(
        height: 32,
        padding: const EdgeInsets.only(right: 32),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < buttons.length; i++) ...[
              buttons[i],
              if (i != buttons.length - 1) const SizedBox(width: 8),
            ],
          ],
        ),
      );
    }

    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(16),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: width,
          maxHeight: height,
        ),
        child: Card(
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
          child: Padding(
            padding: padding ?? const EdgeInsets.all(32),
            child: Stack(
              children: [
                Positioned.fill(
                  child: contents(context),
                ),
                if (actions != null)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: actions,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget titleWidget(String text) {
    return SizedBox(
      height: 32,
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              height: 1.5,
            ),
      ),
    );
  }

  Widget contents(BuildContext context);

  List<Widget> get actionButtons => [];
}
