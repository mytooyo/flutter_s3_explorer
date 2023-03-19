import 'package:flutter/material.dart';
import 'package:flutter_s3_explorer/features/s3/controllers/s3_objects_controller.dart';
import 'package:flutter_s3_explorer/features/s3/providers/s3_objects_provider.dart';
import 'package:flutter_s3_explorer/models/aws_s3.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class S3DeleteConfirmView extends ConsumerStatefulWidget {
  const S3DeleteConfirmView({super.key});

  @override
  ConsumerState<S3DeleteConfirmView> createState() =>
      _S3DeleteConfirmViewState();
}

class _S3DeleteConfirmViewState extends ConsumerState<S3DeleteConfirmView> {
  final TextEditingController textController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey();

  bool _enabled = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 400,
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
    final selected = ref.read(s3BucketObjectSelectedListProvider);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Delete Objects?',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        RichText(
          maxLines: 4,
          textAlign: TextAlign.center,
          text: TextSpan(
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  height: 1.4,
                ),
            children: [
              const TextSpan(
                text: 'Permanently remove ',
              ),
              for (var i = 0; i < selected.length; i++) ...[
                if (i != 0) const TextSpan(text: ' and '),
                TextSpan(
                  text: selected[i].formatKey,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        height: 1.4,
                      ),
                ),
              ],
              const TextSpan(text: '?'),
            ],
          ),
        ),
        const SizedBox(height: 24),
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
                  fillColor: Theme.of(context)
                      .scaffoldBackgroundColor
                      .withOpacity(0.6),
                  filled: true,
                  isDense: true,
                  hintText: 'delete',
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
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _enabled = textController.text == 'delete';
                  });
                },
              ),
            ),
          ],
        ),
        const Expanded(child: SizedBox()),
        ElevatedButton(
          onPressed: _enabled ? _finish : null,
          style: ElevatedButton.styleFrom(
            elevation: 0,
            fixedSize: const Size(104, 40),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            backgroundColor: Colors.red[700],
          ),
          child: const Text('DELETE'),
        ),
      ],
    );
  }

  void _finish() async {
    if (_formKey.currentState?.validate() ?? false) {
      await ref.read(s3ObjectsController).deleteObjects();
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }
}
