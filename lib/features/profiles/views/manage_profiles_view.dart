import 'package:flutter/material.dart';
import 'package:flutter_s3_explorer/features/profiles/providers/profile_list_provider.dart';
import 'package:flutter_s3_explorer/features/profiles/views/components/manage_profile_item_widget.dart';
import 'package:flutter_s3_explorer/features/profiles/views/update_profile_view.dart';
import 'package:flutter_s3_explorer/models/local_aws_profile.dart';
import 'package:flutter_s3_explorer/ui/base_dialog_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ManageProfilesView extends BaseDialogView {
  const ManageProfilesView({super.key});

  @override
  BaseDialogViewState<ManageProfilesView> createState() =>
      _ManageProfilesViewState();
}

class _ManageProfilesViewState extends BaseDialogViewState<ManageProfilesView> {
  @override
  double get height => 480;

  @override
  double get width => 560;

  @override
  EdgeInsetsGeometry? get padding => const EdgeInsets.symmetric(vertical: 32);

  @override
  Widget contents(BuildContext context) {
    final profiles = ref.watch(awsProfileListProvider);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        titleWidget('Management Profiles'),
        const SizedBox(height: 24),
        Expanded(
          child: ListView.builder(
            itemCount: profiles.length,
            padding: const EdgeInsets.only(bottom: 40, left: 24, right: 24),
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: index == profiles.length - 1 ? 0 : 16,
                ),
                child: ManageProfileItem(
                  profile: profiles[index],
                  onDelete: (profile) {
                    showDialog(
                      context: context,
                      builder: (_) => DeleteMessageDialog(
                        profile: profiles[index],
                        onDeleted: () {
                          // プロファイルが0件になった場合は画面を非表示
                          if (ref.read(awsProfileListProvider).isEmpty) {
                            Navigator.of(context).pop();
                          }
                        },
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  List<Widget> get actionButtons {
    return [
      IconButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => const UpdateProfileView(),
          );
        },
        icon: const Icon(Icons.add_circle_rounded),
        constraints: const BoxConstraints(
          maxHeight: 24,
          maxWidth: 24,
        ),
        padding: EdgeInsets.zero,
        iconSize: 20,
      ),
    ];
  }
}

class DeleteMessageDialog extends ConsumerWidget {
  const DeleteMessageDialog({
    super.key,
    required this.profile,
    required this.onDeleted,
  });

  final LocalAWSProfile profile;
  final void Function() onDeleted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(16),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          width: 280,
          height: 160,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyMedium,
                  children: [
                    const TextSpan(text: 'Delete '),
                    TextSpan(
                      text: profile.name,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const TextSpan(text: '?'),
                  ],
                ),
              ),
              const Expanded(child: SizedBox()),
              Row(
                children: [
                  const Expanded(child: SizedBox()),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      fixedSize: const Size(96, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: Colors.transparent,
                      foregroundColor:
                          Theme.of(context).textTheme.bodySmall?.color,
                    ),
                    child: const Text('CANCEL'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () async {
                      await ref
                          .read(awsProfileListProvider.notifier)
                          .remove(profile);
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pop();
                      onDeleted();
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      fixedSize: const Size(96, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: Colors.red[700],
                    ),
                    child: const Text('DELETE'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
