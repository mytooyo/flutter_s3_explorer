import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_s3_explorer/common/extensions/media_query_extension.dart';
import 'package:flutter_s3_explorer/features/s3/providers/s3_objects_provider.dart';
import 'package:flutter_s3_explorer/ui/components/link_text.dart';

import 's3_objects_buttons_widget.dart';

class S3ObjectsHeaderWidget extends ConsumerWidget {
  const S3ObjectsHeaderWidget({super.key});

  static const double space = 8;

  static const int maxPathCount = 4;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(s3BucketObjectSelectedProvider);

    if (selected == null) {
      return const SizedBox();
    }

    return SizedBox(
      height: 40,
      child: Row(
        children: [
          Consumer(
            builder: (context, ref, child) {
              final list = ref.watch(
                s3ObjectsHistoryStateNotifier.select((x) => x.histories),
              );
              return _iconButton(
                context,
                Icons.arrow_back_rounded,
                callback: list.length <= 1
                    ? null
                    : () {
                        ref
                            .read(s3ObjectsHistoryStateNotifier.notifier)
                            .previous();
                      },
                tooltip: 'Back Page',
              );
            },
          ),
          const SizedBox(width: space),
          Expanded(
            child: _linkPath(context, ref, selected),
          ),
          if (!MediaQuery.of(context).isSmall) ...[
            const SizedBox(width: space),
            const S3ObjectsButtonsWidget(space: space),
          ],
        ],
      ),
    );
  }

  Widget _linkPath(
    BuildContext context,
    WidgetRef ref,
    S3ViewObjects selected,
  ) {
    final style = Theme.of(context).textTheme.bodyMedium?.copyWith(
          height: 1.05,
        );

    List<Widget> children = [];
    bool shortening = false;
    for (var i = 0; i < selected.pathes.length; i++) {
      // プレフィックス部分を取得して同一かを判定
      final pathes = selected.pathes.sublist(1, i + 1);
      final prefix = pathes.isEmpty ? null : '${pathes.join('/')}/';
      final same = prefix == selected.prefix;

      // 最大表示数を超過している場合は間のプレフィックスは短縮表示
      if (selected.pathes.length > maxPathCount) {
        final diff = selected.pathes.length - maxPathCount;
        if (i != 0 && diff >= i) {
          if (!shortening) {
            children.add(
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: LinkText(
                  text: '...',
                  style: style,
                  onClick: () {
                    final pathes = selected.pathes.sublist(1, diff + 1);
                    final prefix =
                        pathes.isEmpty ? null : '${pathes.join('/')}/';

                    if (selected.prefix == prefix) return;

                    ref.read(s3ObjectsHistoryStateNotifier.notifier).moveByPath(
                          selected,
                          prefix,
                        );
                  },
                ),
              ),
            );
            shortening = true;
          }

          continue;
        }
      }

      children.add(
        LinkText(
          text: selected.pathes[i],
          style: style?.copyWith(
            fontWeight: i == 0 ? FontWeight.w600 : null,
          ),
          onClick: same
              ? null
              : () {
                  if (selected.prefix == prefix) return;

                  ref.read(s3ObjectsHistoryStateNotifier.notifier).moveByPath(
                        selected,
                        prefix,
                      );
                },
        ),
      );
    }

    return Wrap(
      runSpacing: 4,
      clipBehavior: Clip.antiAlias,
      children: [
        for (var i = 0; i < children.length; i++) ...[
          children[i],
          if (i != children.length - 1)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                '/',
                style: style,
              ),
            ),
        ],
      ],
    );
  }

  Widget _iconButton(
    BuildContext context,
    IconData icon, {
    required void Function()? callback,
    Color? iconColor,
    Color? backgroundColor,
    required String tooltip,
  }) {
    final disabled = callback == null;

    return Material(
      color: disabled
          ? Colors.white.withOpacity(0.2)
          : backgroundColor ?? Colors.white,
      borderRadius: BorderRadius.circular(8),
      clipBehavior: Clip.antiAlias,
      child: Tooltip(
        message: tooltip,
        child: InkWell(
          onTap: callback,
          child: Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            child: Opacity(
              opacity: disabled ? 0.4 : 1.0,
              child: Icon(
                icon,
                size: 20,
                color: disabled ? null : iconColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
