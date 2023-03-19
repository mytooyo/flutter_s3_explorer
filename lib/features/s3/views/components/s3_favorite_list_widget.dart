import 'package:flutter/material.dart';
import 'package:flutter_s3_explorer/features/s3/providers/s3_favorite_objects_provider.dart';
import 'package:flutter_s3_explorer/features/s3/providers/s3_objects_provider.dart';
import 'package:flutter_s3_explorer/ui/components/menu_header_widget.dart';
import 'package:flutter_s3_explorer/ui/side_menu_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class S3FavoriteListWidget extends ConsumerWidget {
  const S3FavoriteListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = ref.watch(s3FavoriteListProvider);

    if (list.isEmpty) return const SizedBox();

    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxHeight: 280,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MenuHeaderWidget(
            icon: Icons.star_rounded,
            iconColor: Colors.orange[600],
            text: 'Favorites',
          ),
          Flexible(
            child: Container(
              decoration: BoxDecoration(
                color: SideMenuWidget.cardColor(context),
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 12),
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: Column(
                  children: [
                    ...list.map((e) => _itemBuilder(e)).toList(),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _itemBuilder(S3FavoriteObject item) {
    String formatKey() {
      if (item.prefix == null) return '/';
      if (item.prefix!.endsWith('/') && item.prefix!.length != 1) {
        return item.prefix!.substring(0, item.prefix!.length - 1);
      }
      return item.prefix!;
    }

    return Consumer(
      builder: (context, ref, child) {
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              ref
                  .read(s3ObjectsHistoryStateNotifier.notifier)
                  .moveByFavorite(item);
            },
            child: Container(
              height: 56,
              width: double.infinity,
              padding: const EdgeInsets.only(left: 20, right: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formatKey(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.bucketName,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
