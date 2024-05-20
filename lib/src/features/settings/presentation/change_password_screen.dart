import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusnest/src/common_widgets/custom_text.dart';
import 'package:focusnest/src/common_widgets/custom_text_form_field.dart';
import 'package:focusnest/src/common_widgets/link_text_button.dart';
import 'package:focusnest/src/common_widgets/loading_manager.dart';
import 'package:focusnest/src/constants/app_padding.dart';
import 'package:focusnest/src/constants/spacers.dart';
import 'package:focusnest/src/features/authentication/data/auth_repository.dart';
import 'package:focusnest/src/features/authentication/presentation/auth_form_type.dart';
import 'package:focusnest/src/features/authentication/presentation/auth_validators.dart';
import 'package:focusnest/src/features/settings/presentation/change_password_screen_controller.dart';
import 'package:focusnest/src/utils/alert_dialogs.dart';
import 'package:focusnest/src/utils/async_value_ui.dart';
import 'package:focusnest/src/utils/modal_helper.dart';
import 'package:go_router/go_router.dart';

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

  String get currentPassword => _currentPasswordController.text.trim();
  String get newPassword => _newPasswordController.text.trim();
  String get confirmNewPassword => _confirmNewPasswordController.text.trim();

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

  Future<bool> _isFormValid() async {
    FocusScope.of(context).unfocus();
    bool isFormValid = true;
    final currentPasswordValid =
        await ref.read(authRepositoryProvider).validateCurrentPassword(
              widget.userEmail,
              currentPassword,
            );
    if (!currentPasswordValid && mounted) {
      showOKAlert(
        context: context,
        title: 'Error',
        content: 'Invalid Current Password',
      );
      return false;
    }

    setState(() {
      _newPasswordErrorText =
          passwordErrorText(newPassword, AuthFormType.register);
      _confirmNewPasswordErrorText =
          newPassword == confirmNewPassword ? null : 'Passwords do not match';
    });

    if (_newPasswordErrorText != null || _confirmNewPasswordErrorText != null) {
      return false;
    }
    return isFormValid;
  }

  void _handleSubmit() async {
    final success = await ref
        .read(changePasswordScreenControllerProvider.notifier)
        .submitNewPassword(newPassword);

    if (success && mounted) {
      showCustomSnackBar(context, 'Password successfully updated!');
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(
      changePasswordScreenControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );
    final state = ref.watch(changePasswordScreenControllerProvider);

    return LoadingManager(
      isLoading: state.isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Change Password'),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: LinkTextButton(
                title: 'Save',
                onPressed: () async {
                  if (await _isFormValid()) {
                    _handleSubmit();
                  }
                },
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
              _passwordTextFormField(
                label: 'Current Password',
                controller: _currentPasswordController,
                hintText: 'Enter your current password',
                errorText: _currentPasswordErrorText,
              ),
              Spacers.smallVertical,
              _passwordTextFormField(
                label: 'New Password',
                controller: _newPasswordController,
                hintText: 'Enter a new password',
                errorText: _newPasswordErrorText,
              ),
              Spacers.smallVertical,
              _passwordTextFormField(
                label: 'Confirm New Password',
                controller: _confirmNewPasswordController,
                hintText: 'Confirm your new password',
                errorText: _confirmNewPasswordErrorText,
                textInputAction: TextInputAction.done,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _passwordTextFormField({
    required String label,
    required String hintText,
    required TextEditingController controller,
    TextInputAction textInputAction = TextInputAction.next,
    String? errorText,
  }) {
    return CustomTextFormField(
      label: label,
      controller: controller,
      hintText: hintText,
      textInputAction: textInputAction,
      obscureText: true,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      prefixIcon: const Icon(Icons.lock_outline),
      errorText: errorText,
    );
  }
}
