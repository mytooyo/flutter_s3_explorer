import 'package:flutter/material.dart';
import 'package:flutter_s3_explorer/bridge/bridge_definitions.dart';
import 'package:flutter_s3_explorer/features/profiles/providers/profile_select_provider.dart';
import 'package:flutter_s3_explorer/features/s3/providers/s3_buckets_provider.dart';
import 'package:flutter_s3_explorer/ui/components/menu_header_widget.dart';
import 'package:flutter_s3_explorer/ui/side_menu_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class S3BucketListWidget extends ConsumerStatefulWidget {
  const S3BucketListWidget({super.key});

  @override
  ConsumerState<S3BucketListWidget> createState() => _S3BucketListWidgetState();
}

class _S3BucketListWidgetState extends ConsumerState<S3BucketListWidget> {
  @override
  Widget build(BuildContext context) {
    final asyncValue = ref.watch(s3BucketListProvider);

    return asyncValue.when(
      data: (list) {
        if (list.isEmpty) return const SizedBox();

        return Consumer(
          builder: (context, ref, child) {
            final selected = ref.watch(s3BucketSelectStateNotifier);

            return Column(
              children: [
                const MenuHeaderWidget(
                  icon: Icons.folder_delete_rounded,
                  text: 'S3 Buckets',
                ),
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      color: SideMenuWidget.cardColor(context),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        return _listItem(list[index], selected);
                      },
                    ),
                  ),
                ),
              ],
            );
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

  Widget _listItem(S3Bucket bucket, S3SelectedBucket? selected) {
    final isSelect = bucket.name == selected?.bucket?.name;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          final profile = ref.read(awsProfileSelectedProvider);
          ref
              .read(s3BucketSelectStateNotifier.notifier)
              .setBucket(profile!, bucket);
        },
        child: Container(
          height: 48,
          width: double.infinity,
          padding: const EdgeInsets.only(left: 20, right: 8),
          child: Row(
            children: [
              Expanded(
                child: Opacity(
                  opacity: isSelect ? 1.0 : 0.8,
                  child: Text(
                    bucket.name,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight:
                              isSelect ? FontWeight.bold : FontWeight.w400,
                          color: isSelect ? const Color(0xff112445) : null,
                        ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
