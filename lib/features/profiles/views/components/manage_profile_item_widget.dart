import 'package:flutter/material.dart';
import 'package:flutter_s3_explorer/features/profiles/providers/profile_select_provider.dart';
import 'package:flutter_s3_explorer/models/local_aws_profile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ManageProfileItem extends ConsumerStatefulWidget {
  const ManageProfileItem({
    super.key,
    required this.profile,
    required this.onDelete,
  });

  final LocalAWSProfile profile;
  final void Function(LocalAWSProfile) onDelete;

  @override
  ConsumerState<ManageProfileItem> createState() => _ManageProfileItemState();
}

class _ManageProfileItemState extends ConsumerState<ManageProfileItem> {
  LocalAWSProfile get profile => widget.profile;

  @override
  Widget build(BuildContext context) {
    final selected = ref.read(awsProfileSelectedProvider);
    final isSelected = selected?.name == profile.name;

    return Card(
      elevation: 0,
      color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Opacity(
                    opacity: isSelected ? 1.0 : 0.6,
                    child: Icon(
                      isSelected
                          ? Icons.check_circle_rounded
                          : Icons.face_rounded,
                      size: 18,
                      color: isSelected ? Colors.blue[700] : null,
                    ),
                  ),
                ),
                Expanded(
                  child: SelectableText(
                    profile.name,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          height: 1.05,
                        ),
                  ),
                ),
                Opacity(
                  opacity: 0.6,
                  child: IconButton(
                    onPressed: () => widget.onDelete(profile),
                    iconSize: 18,
                    constraints: const BoxConstraints(
                      maxWidth: 24,
                      maxHeight: 24,
                    ),
                    padding: EdgeInsets.zero,
                    icon: const Icon(
                      Icons.delete_rounded,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _rowItem('REGION', profile.region),
            _rowItem('ACCESS KEY', profile.accessKeyId),
            _rowItem('SECRET ACCESS KEY', profile.maskedSecretAccessKey),
            _rowItem('MFA SERIAL', profile.mfaSerial ?? '-')
          ],
        ),
      ),
    );
  }

  Widget _rowItem(String title, String data) {
    return SizedBox(
      height: 28,
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          SelectableText(
            data,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
          )
        ],
      ),
    );
  }
}
