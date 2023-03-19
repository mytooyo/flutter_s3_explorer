import 'package:flutter/material.dart';
import 'package:flutter_s3_explorer/features/profiles/views/components/profile_select_widget.dart';
import 'package:flutter_s3_explorer/features/profiles/views/manage_profiles_view.dart';
import 'package:flutter_s3_explorer/features/s3/providers/s3_favorite_objects_provider.dart';
import 'package:flutter_s3_explorer/features/s3/views/components/s3_bucket_list_widget.dart';
import 'package:flutter_s3_explorer/features/s3/views/components/s3_favorite_list_widget.dart';
import 'package:flutter_s3_explorer/features/settings/views/settings_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'components/copyright_widget.dart';

class SideMenuWidget extends ConsumerWidget {
  const SideMenuWidget({super.key});

  static Color cardColor(BuildContext context) {
    return Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(s3FavoriteListProvider);
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: SafeArea(
        child: Container(
          width: 320,
          height: double.infinity,
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    const Expanded(child: ProfileSelectWidget()),
                    const SizedBox(width: 8),
                    _iconButton(
                      context,
                      Icons.settings_rounded,
                      tooltip: 'Setting Profiles',
                      callback: () {
                        showDialog(
                          context: context,
                          builder: (_) => const ManageProfilesView(),
                        );
                      },
                      backgroundColor: SideMenuWidget.cardColor(context),
                    ),
                  ],
                ),
              ),
              const S3FavoriteListWidget(),
              const Expanded(
                child: S3BucketListWidget(),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Divider(
                  height: 1,
                ),
              ),
              ...[
                _settings(context),
                const SizedBox(height: 16),
                const CopyrightWidget(),
                const SizedBox(height: 16),
              ],
            ],
          ),
        ),
      ),
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
      borderRadius: BorderRadius.circular(12),
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
                size: 18,
                color: disabled ? null : iconColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _settings(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (_) => const SettingsView(),
          );
        },
        child: Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const Icon(
                Icons.tune_rounded,
                size: 16,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  'Settings',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        height: 1.05,
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
