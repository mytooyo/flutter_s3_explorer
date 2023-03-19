import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_s3_explorer/bridge/bridge_definitions.dart';
import 'package:flutter_s3_explorer/common/extensions/media_query_extension.dart';
import 'package:flutter_s3_explorer/features/s3/providers/s3_objects_provider.dart';
import 'package:flutter_s3_explorer/models/aws_s3.dart';
import 'package:flutter_s3_explorer/ui/components/image_with_text_widget.dart';
import 'package:flutter_s3_explorer/ui/components/link_text.dart';

class S3ObjectListWidget extends ConsumerStatefulWidget {
  const S3ObjectListWidget({super.key});

  static const EdgeInsetsGeometry horizontalPaddig =
      EdgeInsets.symmetric(horizontal: 16);

  @override
  ConsumerState<S3ObjectListWidget> createState() => _S3ObjectListWidgetState();
}

class _S3ObjectListWidgetState extends ConsumerState<S3ObjectListWidget> {
  @override
  Widget build(BuildContext context) {
    final asyncValue = ref.watch(s3BucketObjectListProvider);

    return asyncValue.when(
      data: (list) {
        // 選択中のバケットが存在しない場合はWelcomeメッセージ
        if (ref.read(s3BucketObjectSelectedProvider) == null) {
          return const Align(
            alignment: Alignment.topCenter,
            child: ImageWithTextWidget(
              path: 'assets/images/fs3_welcome.svg',
              message: 'Select a bucket to view from the list on the left',
              subMessage:
                  'If the bucket does not exist, create it from the AWS console!',
            ),
          );
        }

        if (list.isEmpty) {
          return const Align(
            alignment: Alignment.topCenter,
            child: ImageWithTextWidget(
              path: 'assets/images/fs3_no_data.svg',
              message: 'Selected bucket or folder has no content',
              subMessage:
                  'You can create folders and upload files from the button on the upper right. You can also register as a favorite, so try using it in various ways!',
            ),
          );
        }

        return Consumer(
          builder: (context, ref, child) {
            final selected = ref.watch(s3BucketObjectSelectedListProvider);
            return _builder(list, selected);
          },
        );
      },
      error: (ex, stackTrace) => Container(),
      loading: () => const Center(
        child: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only(top: 40),
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }

  Widget _builder(List<S3Object> list, List<S3Object> selected) {
    return Column(
      children: [
        _header(list, selected),
        Expanded(
          child: SingleChildScrollView(
            child: Card(
              margin: EdgeInsets.zero,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              clipBehavior: Clip.antiAlias,
              elevation: 0,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: list.length,
                itemBuilder: (context, index) => S3ObjectItem(
                  obj: list[index],
                  selected: selected,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _header(List<S3Object> list, List<S3Object> selected) {
    final style = Theme.of(context).textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.bold,
          height: 1.1,
        );
    return Container(
      height: 48,
      width: double.infinity,
      padding: S3ObjectListWidget.horizontalPaddig,
      decoration: const BoxDecoration(
        color: Color(0xffe1e5e8),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
          bottomLeft: Radius.zero,
          bottomRight: Radius.zero,
        ),
      ),
      child: Row(
        children: [
          SizedBox.fromSize(
            size: const Size(20, 20),
            child: Transform.scale(
              scale: 0.7,
              child: Checkbox(
                value: selected.length == list.length,
                onChanged: (val) {
                  if (val == null) return;
                  ref.read(s3BucketObjectSelectedListProvider.notifier).state =
                      val ? list : [];
                },
                side: const BorderSide(width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(_ListItemType.name.title, style: style),
          ),
          SizedBox(
            width: _ListItemType.size.width,
            child: Text(_ListItemType.size.title, style: style),
          ),
          if (!MediaQuery.of(context).isSmall)
            SizedBox(
              width: _ListItemType.changeAt.width,
              child: Text(_ListItemType.changeAt.title, style: style),
            ),
        ],
      ),
    );
  }
}

enum _ListItemType { name, size, changeAt }

extension _ListItemTypeExtension on _ListItemType {
  String get title {
    switch (this) {
      case _ListItemType.name:
        return 'NAME';
      case _ListItemType.size:
        return 'SIZE';
      case _ListItemType.changeAt:
        return 'CHANGED AT';
    }
  }

  double? get width {
    switch (this) {
      case _ListItemType.name:
        return null;
      case _ListItemType.size:
        return 80;
      case _ListItemType.changeAt:
        return 128;
    }
  }
}

class S3ObjectItem extends ConsumerStatefulWidget {
  const S3ObjectItem({
    super.key,
    required this.obj,
    required this.selected,
  });

  final S3Object obj;
  final List<S3Object> selected;

  @override
  ConsumerState<S3ObjectItem> createState() => _S3ObjectItemState();
}

class _S3ObjectItemState extends ConsumerState<S3ObjectItem>
    with SingleTickerProviderStateMixin {
  S3Object get obj => widget.obj;
  List<S3Object> get selected => widget.selected;

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).textTheme.bodyMedium?.color,
        );

    return MouseRegion(
      onHover: (event) => _controller.forward(),
      onExit: (event) => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            height: 48,
            padding: S3ObjectListWidget.horizontalPaddig,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).dividerColor.withOpacity(0.1),
                  width: 0.4,
                ),
              ),
              color: const Color(0xfff2f4f7).withOpacity(_controller.value),
            ),
            child: child,
          );
        },
        child: Row(
          children: [
            SizedBox.fromSize(
              size: const Size(20, 20),
              child: Transform.scale(
                scale: 0.7,
                child: Checkbox(
                  value: selected.contains(obj),
                  onChanged: (val) {
                    final s = [...selected];
                    if (s.contains(obj)) {
                      s.remove(obj);
                    } else {
                      s.add(obj);
                    }
                    ref
                        .read(s3BucketObjectSelectedListProvider.notifier)
                        .state = s;
                  },
                  side: const BorderSide(width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 8),
              child: obj.icon,
            ),
            Expanded(
              child: LinkText(
                text: obj.formatKey,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      height: 1.05,
                    ),
                onClick: () {
                  // フォルダの場合は階層を変更
                  if (obj.isFolder) {
                    ref
                        .read(s3ObjectsHistoryStateNotifier.notifier)
                        .move(obj.key);
                  }
                },
              ),
            ),
            SizedBox(
              width: _ListItemType.size.width,
              child: Text(obj.formatSize, style: style),
            ),
            if (!MediaQuery.of(context).isSmall)
              SizedBox(
                width: _ListItemType.changeAt.width,
                child: Text(obj.formatTime, style: style),
              ),
          ],
        ),
      ),
    );
  }
}
