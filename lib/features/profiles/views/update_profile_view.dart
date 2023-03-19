import 'package:flutter/material.dart';
import 'package:flutter_s3_explorer/features/profiles/providers/profile_list_provider.dart';
import 'package:flutter_s3_explorer/features/profiles/providers/profile_select_provider.dart';
import 'package:flutter_s3_explorer/models/local_aws_profile.dart';
import 'package:flutter_s3_explorer/ui/base_dialog_view.dart';
import 'package:flutter_s3_explorer/utils/aws_const.dart';

class UpdateProfileView extends BaseDialogView {
  const UpdateProfileView({
    super.key,
    this.initAdd = false,
  });

  /// 初回追加用
  final bool initAdd;

  @override
  BaseDialogViewState<UpdateProfileView> createState() =>
      _UpdateProfileViewState();
}

class _UpdateProfileViewState extends BaseDialogViewState<UpdateProfileView> {
  bool get initAdd => widget.initAdd;

  Map<_AddProfileTextKind, TextEditingController> textControllers = {};
  Map<_AddProfileTextKind, FocusNode> focusNodes = {};

  final GlobalKey<FormState> _formKey = GlobalKey();

  final ScrollController scrollController = ScrollController();

  late AWSRegion selectedRegion;

  /// プロファイルを更新 or 追加
  void _updateProfile() async {
    String? mfa = textControllers[_AddProfileTextKind.mfa]!.text;
    if (mfa == '') mfa = null;

    final p = LocalAWSProfile(
      name: textControllers[_AddProfileTextKind.name]!.text,
      region: selectedRegion.code,
      accessKeyId: textControllers[_AddProfileTextKind.accessKeyId]!.text,
      secretAccessKey:
          textControllers[_AddProfileTextKind.secretAccessKey]!.text,
      mfaSerial: mfa,
    );

    await ref.read(awsProfileListProvider.notifier).update(p);

    if (!mounted) return;

    // 初期追加の場合は選択状態にする
    if (initAdd) {
      ref.read(awsProfileSelectedProvider.notifier).select(p);
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  double get height => initAdd ? 560 : 640;

  @override
  double get width => 440;

  @override
  void initState() {
    super.initState();

    for (final kind in _AddProfileTextKind.values) {
      textControllers[kind] = TextEditingController();
      focusNodes[kind] = FocusNode();
    }

    // 選択済みリージョンはリストの一番上
    selectedRegion = AWSConst.regions.first;
  }

  @override
  Widget contents(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!initAdd) titleWidget('ADD NEW AWS PROFILE'),
        Expanded(
          child: SingleChildScrollView(
            controller: scrollController,
            padding: EdgeInsets.symmetric(horizontal: initAdd ? 16 : 32),
            child: Column(
              children: [
                if (!initAdd) const SizedBox(height: 24),
                _region(),
                Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 24,
                    horizontal: 16,
                  ),
                  height: 1,
                  width: double.infinity,
                  color: Theme.of(context).dividerColor.withOpacity(0.1),
                ),
                Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      textField(_AddProfileTextKind.name),
                      textField(_AddProfileTextKind.accessKeyId),
                      textField(_AddProfileTextKind.secretAccessKey),
                      textField(_AddProfileTextKind.mfa),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // バリデーションでエラーがない場合は登録
                    if (_formKey.currentState?.validate() ?? false) {
                      _updateProfile();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    fixedSize: const Size(120, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(initAdd ? 'START!' : 'UPDATE'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget textField(_AddProfileTextKind kind) {
    return SizedBox(
      height: 88,
      child: TextFormField(
        controller: textControllers[kind],
        focusNode: focusNodes[kind],
        keyboardType: TextInputType.text,
        maxLines: 1,
        minLines: 1,
        decoration: InputDecoration(
          fillColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.6),
          filled: true,
          isDense: true,
          hintText: kind.hintText,
          labelText: kind.labelText,
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
        validator: kind.validator,
      ),
    );
  }

  Widget _region() {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.6),
      clipBehavior: Clip.antiAlias,
      child: PopupMenuButton<AWSRegion>(
        itemBuilder: (context) {
          return AWSConst.regions
              .map(
                (x) => PopupMenuItem<AWSRegion>(
                  height: 40,
                  value: x,
                  textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                  child: Text(x.toString()),
                ),
              )
              .toList();
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        tooltip: 'Select Region',
        splashRadius: 8,
        child: Material(
          color: Colors.transparent,
          child: Container(
            height: 44,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedRegion.toString(),
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
          setState(() {
            selectedRegion = value;
          });
        },
      ),
    );
  }
}

typedef FormFieldValidator = String? Function(String? value);

enum _AddProfileTextKind { name, accessKeyId, secretAccessKey, mfa }

extension _AddProfileTextKindExtension on _AddProfileTextKind {
  String get hintText {
    switch (this) {
      case _AddProfileTextKind.name:
        return 'Enter Profile Name';
      case _AddProfileTextKind.accessKeyId:
        return 'Enter Access Key';
      case _AddProfileTextKind.secretAccessKey:
        return 'Enter Secret Access Key';
      case _AddProfileTextKind.mfa:
        return 'Enter MFA Serial (Optional)';
    }
  }

  String get labelText {
    switch (this) {
      case _AddProfileTextKind.name:
        return 'Profile Name';
      case _AddProfileTextKind.accessKeyId:
        return 'Access Key';
      case _AddProfileTextKind.secretAccessKey:
        return 'Secret Access Key';
      case _AddProfileTextKind.mfa:
        return 'MFA Serial (Optional)';
    }
  }

  FormFieldValidator? get validator {
    switch (this) {
      case _AddProfileTextKind.name:
      case _AddProfileTextKind.accessKeyId:
      case _AddProfileTextKind.secretAccessKey:
        return (value) {
          if (value == null || value == '') {
            return '😓 Required fields';
          }
          return null;
        };

      case _AddProfileTextKind.mfa:
        return null;
    }
  }
}
