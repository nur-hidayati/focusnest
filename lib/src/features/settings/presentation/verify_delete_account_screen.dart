import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusnest/src/common_widgets/custom_button.dart';
import 'package:focusnest/src/common_widgets/custom_text.dart';
import 'package:focusnest/src/common_widgets/custom_text_form_field.dart';
import 'package:focusnest/src/common_widgets/header_actions_button.dart';
import 'package:focusnest/src/common_widgets/loading_manager.dart';
import 'package:focusnest/src/constants/app_color.dart';
import 'package:focusnest/src/constants/app_padding.dart';
import 'package:focusnest/src/constants/spacers.dart';
import 'package:focusnest/src/features/authentication/data/auth_repository.dart';
import 'package:focusnest/src/features/settings/presentation/verify_delete_account_screen_controller.dart';
import 'package:focusnest/src/utils/alert_dialogs.dart';
import 'package:focusnest/src/utils/async_value_ui.dart';
import 'package:go_router/go_router.dart';

class VerifyDeleteAccount extends ConsumerStatefulWidget {
  final String userId;
  final String userEmail;

  const VerifyDeleteAccount({
    required this.userId,
    required this.userEmail,
    super.key,
  });

  @override
  ConsumerState<VerifyDeleteAccount> createState() =>
      _VerifyDeleteAccountState();
}

class _VerifyDeleteAccountState extends ConsumerState<VerifyDeleteAccount> {
  final _currentPasswordController = TextEditingController();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    super.dispose();
  }

  void _handleVerifyDeleteAccount() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final currentPasswordValid =
        await ref.read(authRepositoryProvider).validateCurrentPassword(
              widget.userEmail,
              _currentPasswordController.text,
            );

    if (!currentPasswordValid && mounted) {
      showOKAlert(
        context: context,
        title: 'Error',
        content: 'Invalid Current Password',
      );
    } else {
      ref
          .read(verifyDeleteAccountScreenControllerProvider.notifier)
          .submitDeleteUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(
      verifyDeleteAccountScreenControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );
    final state = ref.watch(verifyDeleteAccountScreenControllerProvider);

    return LoadingManager(
      isLoading: state.isLoading,
      child: Scaffold(
        body: Padding(
          padding: AppPadding.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderActionButtons(
                padding: const EdgeInsets.only(top: 10),
                title: 'Delete Account',
                hideDoneButton: true,
                onCancel: () => context.pop(),
              ),
              const CustomText(
                title:
                    'To ensure your account security, please enter your current password to proceed with account deletion.',
              ),
              Spacers.smallVertical,
              CustomTextFormField(
                hintText: 'Enter your current password',
                controller: _currentPasswordController,
                textInputAction: TextInputAction.done,
                obscureText: true,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                prefixIcon: const Icon(Icons.lock_outline),
              ),
              Spacers.mediumVertical,
              Center(
                child: CustomButton(
                  title: 'Delete Account',
                  isFullWidth: true,
                  buttonColor: AppColor.warningColor,
                  onPressed: _handleVerifyDeleteAccount,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
