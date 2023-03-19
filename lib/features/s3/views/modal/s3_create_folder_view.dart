import 'package:flutter/material.dart';
import 'package:flutter_s3_explorer/features/s3/controllers/s3_objects_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class S3CreateFolderView extends ConsumerStatefulWidget {
  const S3CreateFolderView({super.key});

  @override
  ConsumerState<S3CreateFolderView> createState() => _S3CreateFolderViewState();
}

class _S3CreateFolderViewState extends ConsumerState<S3CreateFolderView> {
  final TextEditingController textController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey();

  bool _enabled = false;

  String? errMsg;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 360,
          maxHeight: 280,
        ),
        child: Card(
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Form(
                    key: _formKey,
                    child: _contents(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _contents() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Please Enter New Folder',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 32),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: textController,
                focusNode: focusNode,
                autofocus: true,
                keyboardType: TextInputType.text,
                maxLines: 1,
                minLines: 1,
                decoration: InputDecoration(
                  fillColor: Theme.of(context)
                      .scaffoldBackgroundColor
                      .withOpacity(0.6),
                  filled: true,
                  isDense: true,
                  hintText: 'Enter folder name',
                  labelText: 'Folder Name',
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
                validator: (value) {
                  if (value == null || value == '') {
                    return '😓 Required fields';
                  }
                  if (value.contains('/')) {
                    return '😩 [/] cannot be used in folder name..';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _enabled = textController.text.isNotEmpty;
                  });
                },
              ),
            ),
          ],
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              errMsg ?? '',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.red[800],
                  ),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: _enabled ? _finish : null,
          style: ElevatedButton.styleFrom(
            elevation: 0,
            fixedSize: const Size(104, 40),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('OK'),
        ),
      ],
    );
  }

  void _finish() async {
    if (_formKey.currentState?.validate() ?? false) {
      final result = await ref.read(s3ObjectsController).createFolder(
            textController.text,
          );
      // 更新に失敗した場合はメッセージを表示
      if (!result) {
        errMsg = '😩 Failed to create folder..';
        return;
      }

      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }
}
