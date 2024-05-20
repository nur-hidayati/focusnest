import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusnest/src/common_widgets/custom_button.dart';
import 'package:focusnest/src/common_widgets/custom_text.dart';
import 'package:focusnest/src/common_widgets/custom_text_form_field.dart';
import 'package:focusnest/src/constants/app_padding.dart';
import 'package:focusnest/src/constants/routes_name.dart';
import 'package:focusnest/src/constants/spacers.dart';
import 'package:focusnest/src/features/authentication/presentation/string_validators.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              onPressed: () {
                context.pushNamed(RoutesName.emailSent, pathParameters: {
                  'userEmail': _emailController.text,
                });
              },
              isFullWidth: true,
            )
          ],
        ),
      ),
    );
  }
}
