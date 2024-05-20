import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusnest/src/common_widgets/custom_button.dart';
import 'package:focusnest/src/common_widgets/custom_text.dart';
import 'package:focusnest/src/common_widgets/custom_text_form_field.dart';
import 'package:focusnest/src/common_widgets/loading_manager.dart';
import 'package:focusnest/src/constants/app_padding.dart';
import 'package:focusnest/src/constants/routes_name.dart';
import 'package:focusnest/src/constants/spacers.dart';
import 'package:focusnest/src/features/authentication/presentation/reset_password_screen_controller.dart';
import 'package:focusnest/src/features/authentication/presentation/string_validators.dart';
import 'package:focusnest/src/utils/alert_dialogs.dart';
import 'package:focusnest/src/utils/async_value_ui.dart';
import 'package:go_router/go_router.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleSubmitReset() async {
    FocusScope.of(context).unfocus();
    if (_emailController.text.isNotEmpty) {
      final success = await ref
          .read(resetPasswordScreenControllerProvider.notifier)
          .tryResetPassword(_emailController.text);

      if (success && mounted) {
        context.pushNamed(RoutesName.emailSent, pathParameters: {
          'userEmail': _emailController.text,
        });
      }
    } else {
      showOKAlert(
        context: context,
        title: 'Invalid Email',
        content: 'Email cannot be empty',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(
      resetPasswordScreenControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );
    final state = ref.watch(resetPasswordScreenControllerProvider);
    return LoadingManager(
      isLoading: state.isLoading,
      child: Scaffold(
        appBar: AppBar(
          shape: const LinearBorder(),
          title: const Text('Forgot Your Password?'),
        ),
        body: Padding(
          padding: AppPadding.noTopPadding,
          child: Column(
            children: [
              Spacers.extraSmallVertical,
              const CustomText(
                title:
                    'Enter the email address associated with your account and we will send you a link to reset your password.',
                overflow: TextOverflow.visible,
              ),
              Spacers.mediumVertical,
              CustomTextFormField(
                controller: _emailController,
                hintText: 'Email Address',
                prefixIcon: const Icon(Icons.email),
                keyboardType: TextInputType.emailAddress,
                inputFormatters: [
                  ValidatorInputFormatter(
                    editingValidator: EmailEditingRegexValidator(),
                  ),
                ],
              ),
              Spacers.mediumVertical,
              CustomButton(
                title: 'Reset Password',
                onPressed: _handleSubmitReset,
                isFullWidth: true,
              )
            ],
          ),
        ),
      ),
    );
  }
}
