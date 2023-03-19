import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_s3_explorer/features/s3/controllers/s3_objects_controller.dart';
import 'package:flutter_s3_explorer/features/s3/providers/s3_favorite_objects_provider.dart';
import 'package:flutter_s3_explorer/features/s3/providers/s3_objects_provider.dart';
import 'package:flutter_s3_explorer/features/s3/views/modal/s3_create_folder_view.dart';
import 'package:flutter_s3_explorer/features/s3/views/modal/s3_delete_confirm_view.dart';

class S3ObjectsButtonsWidget extends ConsumerWidget {
  const S3ObjectsButtonsWidget({
    super.key,
    required this.space,
  });

  final double space;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(s3BucketObjectSelectedProvider);
    if (selected == null) const SizedBox();

    return Wrap(
      spacing: space,
      children: [
        Consumer(
          builder: (context, ref, child) {
            final list = ref.watch(s3BucketObjectSelectedListProvider);

            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _iconButton(
                  context,
                  Icons.delete_rounded,
                  callback: list.isEmpty
                      ? null
                      : () {
                          showDialog(
                            context: context,
                            builder: (context) => const S3DeleteConfirmView(),
                          );
                        },
                  iconColor: Colors.white,
                  backgroundColor: const Color.fromARGB(255, 192, 30, 30),
                  tooltip: 'Delete',
                ),
                SizedBox(width: space),
                _iconButton(
                  context,
                  Icons.download_rounded,
                  callback: list.isEmpty
                      ? null
                      : () {
                          ref.read(s3ObjectsController).downloadObjects();
                        },
                  iconColor: Colors.white,
                  backgroundColor: const Color(0xff15253d),
                  tooltip: 'Download',
                ),
              ],
            );
          },
        ),
        Consumer(
          builder: (context, ref, child) {
            final favorites = ref.watch(s3FavoriteListProvider);
            final isFavorite = favorites.indexWhere(
                  (x) =>
                      selected!.bucket?.bucket?.name == x.bucketName &&
                      selected.prefix == x.prefix,
                ) >=
                0;
            return _iconButton(
              context,
              isFavorite ? Icons.star_rounded : Icons.star_outline_outlined,
              callback: () {
                // お気に入り更新
                ref
                    .read(s3FavoriteObjectsStateNotifier.notifier)
                    .update(selected!);
              },
              iconColor: isFavorite ? Colors.orange : null,
              tooltip: 'Favorite',
            );
          },
        ),
        _iconButton(
          context,
          Icons.create_new_folder_outlined,
          callback: () {
            showDialog(
              context: context,
              builder: (context) => const S3CreateFolderView(),
            );
          },
          tooltip: 'Create Folder',
        ),
        _iconButton(
          context,
          Icons.upload_rounded,
          callback: () async {
            await ref.read(s3ObjectsController).uploadFile();
          },
          tooltip: 'Upload File',
        ),
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
