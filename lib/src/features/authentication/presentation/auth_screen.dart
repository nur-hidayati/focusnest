import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusnest/src/common_widgets/custom_button.dart';
import 'package:focusnest/src/common_widgets/custom_text.dart';
import 'package:focusnest/src/common_widgets/custom_text_form_field.dart';
import 'package:focusnest/src/common_widgets/link_text_button.dart';
import 'package:focusnest/src/constants/app_color.dart';
import 'package:focusnest/src/constants/app_padding.dart';
import 'package:focusnest/src/constants/routes_name.dart';
import 'package:focusnest/src/constants/spacers.dart';
import 'package:focusnest/src/features/activity_timer/application/activity_timer_service.dart';
import 'package:focusnest/src/features/activity_timer/data/activity_timer_providers.dart';
import 'package:focusnest/src/features/authentication/data/auth_repository.dart';
import 'package:focusnest/src/features/authentication/presentation/auth_form_type.dart';
import 'package:focusnest/src/features/authentication/presentation/auth_screen_controller.dart';
import 'package:focusnest/src/features/authentication/presentation/auth_validators.dart';
import 'package:focusnest/src/features/authentication/presentation/string_validators.dart';
import 'package:focusnest/src/utils/async_value_ui.dart';
import 'package:focusnest/src/utils/modal_helper.dart';
import 'package:focusnest/src/utils/navigation_helper.dart';
import 'package:focusnest/src/utils/shared_prefs_helper.dart';
import 'package:go_router/go_router.dart';

class AuthScreen extends StatelessWidget {
  final AuthFormType formType;

  const AuthScreen({
    required this.formType,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AuthFormContents(
      formType: formType,
    );
  }
}

class AuthFormContents extends ConsumerStatefulWidget {
  final AuthFormType formType;

  const AuthFormContents({
    required this.formType,
    super.key,
  });

  @override
  ConsumerState<AuthFormContents> createState() => _AuthFormContentsState();
}

class _AuthFormContentsState extends ConsumerState<AuthFormContents>
    with AuthValidators {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _submitted = false;
  late AuthFormType _formType = widget.formType;

  String get email => _emailController.text.trim();
  String get password => _passwordController.text.trim();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitAuth() async {
    setState(() => _submitted = true);
    FocusManager.instance.primaryFocus?.unfocus();

    if (_formKey.currentState!.validate()) {
      final authController = ref.read(authScreenControllerProvider.notifier);

      final success = await authController.submitAuth(
        email: email,
        password: password,
        formType: _formType,
      );
      if (success) {
        final authRepository = ref.watch(authRepositoryProvider);
        final userId = authRepository.currentUser?.uid;
        if (userId != null) {
          final dao = ref.read(activityTimersDaoProvider);
          await dao.updateGuestUserIdToNewUserId(userId);
          await migrateSharedPrefsToCurrentUser(userId);

          reloadAllNotifiers(ref, userId);
        }
        if (mounted) {
          context.pop();
          showCustomSnackBar(
            context,
            _formType == AuthFormType.signIn
                ? 'Sign-in successful!'
                : 'Account successfully created!',
          );
        }
      }
    }
  }

  void _updateFormType() {
    _formKey.currentState?.reset();
    setState(() {
      _formType = _formType.headerActionFormType;
      _submitted = false;
    });
    _emailController.clear();
    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(
      authScreenControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );
    final state = ref.watch(authScreenControllerProvider);

    return Scaffold(
      appBar: AppBar(
        shape: const LinearBorder(),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: AppPadding.noTopPadding,
        child: SafeArea(
          child: Column(
            children: [
              CustomText(
                title: _formType.headerText,
                textType: TextType.title,
              ),
              Spacers.mediumVertical,
              _formSection(state.isLoading),
              Spacers.mediumVertical,
              _bottomSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _formSection(bool isLoading) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextFormField(
            controller: _emailController,
            hintText: 'Email Address',
            isEnabled: !isLoading,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            inputFormatters: [
              ValidatorInputFormatter(
                editingValidator: EmailEditingRegexValidator(),
              ),
            ],
            validator: (email) =>
                !_submitted ? null : emailErrorText(email ?? ''),
            prefixIcon: const Icon(Icons.email),
          ),
          Spacers.mediumVertical,
          CustomTextFormField(
            controller: _passwordController,
            hintText: 'Password',
            isEnabled: !isLoading,
            textInputAction: TextInputAction.done,
            obscureText: true,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (password) => !_submitted
                ? null
                : passwordErrorText(password ?? '', AuthFormType.register),
            prefixIcon: const Icon(Icons.lock),
          ),
          if (_formType == AuthFormType.signIn) ...[
            Align(
              alignment: Alignment.centerRight,
              child: LinkTextButton(
                title: 'Forgot Password?',
                fontSize: 16,
                onPressed: () => context.pushNamed(RoutesName.resetPassword),
              ),
            ),
          ] else ...[
            Spacers.mediumVertical,
          ],
          CustomButton(
            title: _formType.title,
            isFullWidth: true,
            onPressed: isLoading ? null : () => _submitAuth(),
          ),
          if (_formType == AuthFormType.register) ...[
            Spacers.smallVertical,
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: 'By signing up, you agree to our ',
                style: const TextStyle(
                  color: AppColor.greyColor,
                  height: 1.5,
                  fontSize: 12,
                ),
                children: [
                  _linkTextSpan('Privacy Policy ',
                      'https://focusnest-app.github.io/focusnest/'),
                  const TextSpan(text: ' and '),
                  _linkTextSpan('Terms of Service.',
                      'https://focusnest-app.github.io/focusnest/terms_of_use'),
                ],
              ),
            ),
          ],
          Spacers.smallVertical,
        ],
      ),
    );
  }

  Widget _bottomSection() {
    return Column(
      children: [
        CustomText(
          title: _formType.bottomText,
          textType: TextType.subtitle,
        ),
        LinkTextButton(
          title: _formType.bottomTextLink,
          onPressed: _updateFormType,
        ),
      ],
    );
  }

  TextSpan _linkTextSpan(
    String title,
    String url,
  ) {
    return TextSpan(
      text: title,
      style: const TextStyle(
        color: AppColor.primaryColor,
        fontWeight: FontWeight.bold,
      ),
      recognizer: TapGestureRecognizer()..onTap = () => launchURL(url),
    );
  }
}
