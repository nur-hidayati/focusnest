import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusnest/src/common_widgets/custom_text.dart';
import 'package:focusnest/src/common_widgets/custom_text_form_field.dart';
import 'package:focusnest/src/common_widgets/link_text_button.dart';
import 'package:focusnest/src/constants/app_padding.dart';
import 'package:focusnest/src/constants/spacers.dart';
import 'package:focusnest/src/features/authentication/data/auth_repository.dart';
import 'package:focusnest/src/features/authentication/presentation/auth_form_type.dart';
import 'package:focusnest/src/features/authentication/presentation/auth_validators.dart';
import 'package:focusnest/src/utils/alert_dialogs.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  final String userId;
  final String userEmail;

  const ChangePasswordScreen({
    required this.userId,
    required this.userEmail,
    super.key,
  });

  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen>
    with AuthValidators {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();

  String? _currentPasswordErrorText;
  String? _newPasswordErrorText;
  String? _confirmNewPasswordErrorText;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }

  Future<void> _isFormValid() async {
    FocusScope.of(context).unfocus();

    final currentPasswordValid =
        await ref.read(authRepositoryProvider).validateCurrentPassword(
              widget.userEmail,
              _currentPasswordController.text,
            );
    if (!currentPasswordValid && mounted) {
      showOKAlert(
          context: context,
          title: 'Error',
          content: 'Invalid Current Password');
    } else {
      final newPassword = _newPasswordController.text;
      final confirmNewPassword = _confirmNewPasswordController.text;

      setState(() {
        _newPasswordErrorText =
            passwordErrorText(newPassword, AuthFormType.register);
        _confirmNewPasswordErrorText =
            newPassword == confirmNewPassword ? null : 'Passwords do not match';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: LinkTextButton(
              title: 'Save',
              onPressed: _isFormValid,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: AppPadding.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomText(
                title: 'Your password must at least be 8 characters.'),
            Spacers.smallVertical,
            CustomTextFormField(
              label: 'Current Password',
              controller: _currentPasswordController,
              hintText: 'Enter your current password',
              textInputAction: TextInputAction.next,
              obscureText: true,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              prefixIcon: const Icon(Icons.lock_outline),
              errorText: _currentPasswordErrorText,
            ),
            Spacers.smallVertical,
            CustomTextFormField(
              label: 'New Password',
              controller: _newPasswordController,
              hintText: 'Enter a new password',
              textInputAction: TextInputAction.next,
              obscureText: true,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              prefixIcon: const Icon(Icons.lock_outline),
              errorText: _newPasswordErrorText,
            ),
            Spacers.smallVertical,
            CustomTextFormField(
              label: 'Confirm New Password',
              controller: _confirmNewPasswordController,
              hintText: 'Confirm your new password',
              textInputAction: TextInputAction.done,
              obscureText: true,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              prefixIcon: const Icon(Icons.lock_outline),
              errorText: _confirmNewPasswordErrorText,
            ),
          ],
        ),
      ),
    );
  }
}
