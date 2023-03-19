import 'package:flutter/material.dart';
import 'package:flutter_s3_explorer/features/profiles/providers/profile_list_provider.dart';
import 'package:flutter_s3_explorer/features/profiles/providers/profile_select_provider.dart';
import 'package:flutter_s3_explorer/features/profiles/views/update_profile_view.dart';
import 'package:flutter_s3_explorer/models/local_aws_profile.dart';
import 'package:flutter_s3_explorer/ui/side_menu_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileSelectWidget extends ConsumerWidget {
  const ProfileSelectWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(awsProfileSelectedProvider);
    final list = ref.watch(awsProfileListProvider);
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: SideMenuWidget.cardColor(context),
      clipBehavior: Clip.antiAlias,
      child: PopupMenuButton<LocalAWSProfile>(
        itemBuilder: (context) => itemBuilder(context, ref, list),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        tooltip: 'Select AWS profile',
        splashRadius: 12,
        child: Material(
          color: Colors.transparent,
          child: Container(
            height: 40,
            width: double.infinity,
            padding: const EdgeInsets.only(left: 20, right: 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selected?.name ?? 'No selected',
                  ),
                ),
                const Icon(
                  Icons.arrow_drop_down_rounded,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
        onSelected: (value) {
          if (value.name == 'for_dummy') {
            showDialog(
              context: context,
              builder: (_) => const UpdateProfileView(),
            );
            return;
          }

          ref.read(awsProfileSelectedProvider.notifier).select(value);
        },
      ),
    );
  }

  List<PopupMenuEntry<LocalAWSProfile>> itemBuilder(
    BuildContext context,
    WidgetRef ref,
    List<LocalAWSProfile> list,
  ) {
    const double height = 40;
    final textStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          height: 1.05,
          color: Theme.of(context).textTheme.bodyMedium?.color,
        );

    final items = list
        .map(
          (x) => PopupMenuItem<LocalAWSProfile>(
            value: x,
            height: height,
            textStyle: textStyle,
            child: Text(x.name),
          ),
        )
        .toList();

    if (items.isNotEmpty) {
      items.add(
        const PopupMenuItem<LocalAWSProfile>(
          enabled: false,
          height: 8,
          value: null,
          child: Divider(height: 2),
        ),
      );
    }

    items.add(
      PopupMenuItem<LocalAWSProfile>(
        height: height,
        value: LocalAWSProfile(
          name: 'for_dummy',
          region: '',
          accessKeyId: '',
          secretAccessKey: '',
        ),
        child: Row(
          children: [
            const Icon(
              Icons.add_circle_rounded,
              size: 16,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                'Add New Profile',
                style: textStyle,
              ),
            ),
          ],
        ),
      ),
    );

    return items;
  }
}
