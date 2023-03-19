import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_s3_explorer/features/settings/providers/settings_provider.dart';
import 'package:flutter_s3_explorer/ui/base_dialog_view.dart';
import 'package:universal_io/io.dart';

class SettingsView extends BaseDialogView {
  const SettingsView({super.key});

  @override
  BaseDialogViewState<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends BaseDialogViewState<SettingsView> {
  late TextEditingController textController;
  final FocusNode focusNode = FocusNode();

  late bool zipCompression;

  @override
  double get height => Platform.isIOS ? 320 : 408;

  @override
  double get width => 600;

  @override
  void initState() {
    super.initState();

    final data = ref.read(appSettingsProvider);
    textController = TextEditingController(text: data.downloadDir);
    zipCompression = data.zipCompression;
  }

  @override
  Widget contents(BuildContext context) {
    return Column(
      children: [
        titleWidget('Settings'),
        const SizedBox(height: 48),
        if (!Platform.isIOS) ...[
          _downloadDir(),
          const SizedBox(height: 40),
        ],
        _zip(),
        const Expanded(child: SizedBox()),
        ElevatedButton(
          onPressed: () async {
            await ref.read(appSettingsProvider.notifier).update(
                  textController.text.isEmpty ? null : textController.text,
                  zipCompression,
                );

            if (mounted) {
              Navigator.of(context).pop();
            }
          },
          style: ElevatedButton.styleFrom(
            elevation: 0,
            fixedSize: const Size(104, 40),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('UPDATE'),
        ),
      ],
    );
  }

  Color get bgColor =>
      Theme.of(context).scaffoldBackgroundColor.withOpacity(0.6);

  Widget _downloadDir() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _contentHeader('Download Directory', Icons.folder_rounded),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: textController,
                focusNode: focusNode,
                keyboardType: TextInputType.text,
                maxLines: 1,
                minLines: 1,
                decoration: InputDecoration(
                  fillColor: bgColor,
                  filled: true,
                  isDense: true,
                  hintText: 'Enter Download Folder',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      width: 2,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      width: 2,
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  errorMaxLines: 1,
                ),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(width: 12),
            Material(
              color: bgColor,
              borderRadius: BorderRadius.circular(8),
              clipBehavior: Clip.antiAlias,
              child: Tooltip(
                message: 'Open Folder',
                child: InkWell(
                  onTap: () async {
                    final result = await FilePicker.platform
                        .getDirectoryPath(dialogTitle: 'Select Folder');
                    if (result != null) {
                      textController.text = result;
                    }
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    child: const Opacity(
                      opacity: 0.8,
                      child: Icon(
                        Icons.folder_open_rounded,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget _zip() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _contentHeader('Zip Compression', Icons.folder_zip_rounded),
        const SizedBox(height: 8),
        Container(
          height: 48,
          padding: const EdgeInsets.only(left: 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Zip the contents of a folder when downloading',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              Transform.scale(
                scale: 0.9,
                child: CupertinoSwitch(
                  activeColor: Theme.of(context).primaryColor,
                  value: zipCompression,
                  onChanged: (val) {
                    setState(() {
                      zipCompression = !zipCompression;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _contentHeader(String title, IconData icon) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: Icon(
            icon,
            size: 16,
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
        ),
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  height: 1.1,
                ),
          ),
        ),
      ],
    );
  }
}
