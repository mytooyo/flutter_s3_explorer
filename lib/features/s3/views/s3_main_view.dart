import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_s3_explorer/common/extensions/media_query_extension.dart';
import 'package:flutter_s3_explorer/common/providers/error_provider.dart';
import 'package:flutter_s3_explorer/features/s3/providers/s3_objects_provider.dart';
import 'package:flutter_s3_explorer/features/s3/views/components/s3_object_list_widget.dart';
import 'package:flutter_s3_explorer/features/settings/providers/settings_provider.dart';
import 'package:flutter_s3_explorer/ui/error_scope_widget.dart';
import 'package:flutter_s3_explorer/ui/side_menu_widget.dart';

import 'components/s3_downloading_widget.dart';
import 'parts/s3_objects_buttons_widget.dart';
import 'parts/s3_objects_header_widget.dart';

class S3MainView extends ConsumerStatefulWidget {
  const S3MainView({super.key});

  @override
  ConsumerState<S3MainView> createState() => _S3MainViewState();
}

class _S3MainViewState extends ConsumerState<S3MainView> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmall = MediaQuery.of(context).isSmall;

        final child = Stack(
          children: const [
            Positioned.fill(child: S3ObjectsView()),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SizedBox(
                width: double.infinity,
                child: Align(
                  alignment: Alignment.center,
                  child: S3DownloadingWidget(),
                ),
              ),
            ),
          ],
        );

        if (isSmall) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              actions: [
                _header,
                const SizedBox(width: 16),
              ],
            ),
            body: child,
            drawer: const SideMenuWidget(),
          );
        }

        return Scaffold(
          body: Row(
            children: [
              const SideMenuWidget(),
              Expanded(
                child: child,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget get _header {
    return Container(
      height: 52,
      alignment: Alignment.centerRight,
      child: Theme(
        data: Theme.of(context),
        child: Consumer(
          builder: (context, ref, child) {
            final selected = ref.watch(s3BucketObjectSelectedProvider);

            if (selected == null) {
              return const SizedBox();
            }
            return const S3ObjectsButtonsWidget(space: 8);
          },
        ),
      ),
    );
  }
}

class S3ObjectsView extends ConsumerStatefulWidget {
  const S3ObjectsView({super.key});

  @override
  ConsumerState<S3ObjectsView> createState() => _S3ObjectsViewState();
}

class _S3ObjectsViewState extends ConsumerState<S3ObjectsView> {
  @override
  Widget build(BuildContext context) {
    ref.watch(appSettingsProvider);

    return Consumer(
      builder: (context, ref, child) {
        final err = ref.watch(errorStateNotifier);

        if (err?.type == ErrorStateType.display) {
          return ErrorDisplayWidget(err: err!);
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          height: double.infinity,
          width: double.infinity,
          child: SafeArea(
            child: Column(
              children: const [
                S3ObjectsHeaderWidget(),
                SizedBox(height: 16),
                Expanded(
                  child: S3ObjectListWidget(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
