import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_s3_explorer/models/local_aws_profile.dart';
import 'package:flutter_s3_explorer/ui/base_dialog_view.dart';

class InputMFACodeView extends BaseDialogView {
  const InputMFACodeView({super.key, required this.profile});

  final LocalAWSProfile profile;

  @override
  BaseDialogViewState<InputMFACodeView> createState() =>
      _InputMFACodeViewState();
}

class _InputMFACodeViewState extends BaseDialogViewState<InputMFACodeView> {
  List<TextEditingController> textControllers = [];
  List<FocusNode> focusNodes = [];

  bool _enabled = false;

  void _finish() {
    String data = '';
    for (final c in textControllers) {
      data += c.text;
    }

    Navigator.of(context).pop(data);
  }

  @override
  void initState() {
    super.initState();

    for (var i = 0; i < 6; i++) {
      textControllers.add(TextEditingController());
      focusNodes.add(FocusNode());
    }
  }

  @override
  double get height => 280;

  @override
  double get width => 360;

  @override
  Widget contents(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        titleWidget('Please Enter MFA Code'),
        const SizedBox(height: 8),
        Text(
          widget.profile.mfaSerial!,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (var i = 0; i < 6; i++) textField(i),
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
          ),
          child: const Text('OK'),
        ),
      ],
    );
  }

  Widget textField(int index) {
    return SizedBox(
      height: 56,
      width: 40,
      child: TextField(
        controller: textControllers[index],
        focusNode: focusNodes[index],
        keyboardType: TextInputType.number,
        textInputAction: index == focusNodes.length - 1
            ? TextInputAction.send
            : TextInputAction.next,
        autofocus: index == 0,
        maxLines: 1,
        minLines: 1,
        decoration: InputDecoration(
          fillColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.6),
          filled: true,
          isDense: true,
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
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
        ],
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headlineSmall,
        onChanged: (val) {
          // 入力状態をチェックしてボタンの活性を変更
          setState(() {
            _enabled = textControllers.every((x) => x.text.isNotEmpty);
          });

          // 変更時、次のインデックスがある場合はフォーカスを当てる
          if (index == 5 || val == '') return;

          focusNodes[index + 1].requestFocus();
        },
        onEditingComplete: () {
          if (focusNodes.last.hasFocus) {
            _finish();
          }
        },
      ),
    );
  }
}
