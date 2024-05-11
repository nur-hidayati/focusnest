import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusnest/src/common_widgets/custom_button.dart';
import 'package:focusnest/src/common_widgets/custom_text.dart';
import 'package:focusnest/src/common_widgets/custom_text_form_field.dart';
import 'package:focusnest/src/common_widgets/link_text_button.dart';
import 'package:focusnest/src/constants/app_padding.dart';
import 'package:focusnest/src/constants/spacers.dart';
import 'package:focusnest/src/features/authentication/presentation/auth_controller.dart';
import 'package:focusnest/src/features/authentication/presentation/auth_form_type.dart';
import 'package:focusnest/src/features/authentication/presentation/auth_validators.dart';
import 'package:focusnest/src/features/authentication/presentation/string_validators.dart';
import 'package:focusnest/src/utils/async_value_ui.dart';

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
    FocusScope.of(context).unfocus();

    if (_formKey.currentState!.validate()) {
      final controller = ref.read(authControllerProvider.notifier);
      await controller.submitAuth(
        email: email,
        password: password,
        formType: _formType,
      );
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
      authControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );
    final state = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: AppPadding.screenPadding,
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  _headerSection(),
                  Spacers.largeVertical,
                  _formSection(state.isLoading),
                  Spacers.mediumVertical,
                  _bottomSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerSection() {
    Size screenSize = MediaQuery.of(context).size;
    double imageSize = screenSize.width * 0.3;
    return Column(
      children: [
        Image.asset(
          'assets/icons/focusnest-icon.png',
          width: imageSize,
          height: imageSize,
        ),
        Spacers.mediumVertical,
        CustomText(
          title: _formType.headerText,
          textType: TextType.titleLarge,
        ),
      ],
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
          Spacers.largeVertical,
          CustomButton(
            title: _formType.title,
            onPressed: isLoading ? null : () => _submitAuth(),
          ),
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
}
