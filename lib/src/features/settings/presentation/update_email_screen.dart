import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusnest/src/common_widgets/cancel_done_header_button.dart';
import 'package:focusnest/src/common_widgets/custom_text.dart';
import 'package:focusnest/src/common_widgets/custom_text_form_field.dart';
import 'package:focusnest/src/common_widgets/loading_manager.dart';
import 'package:focusnest/src/constants/app_padding.dart';
import 'package:focusnest/src/constants/spacers.dart';
import 'package:focusnest/src/features/authentication/data/auth_repository.dart';
import 'package:focusnest/src/features/authentication/presentation/auth_validators.dart';
import 'package:focusnest/src/features/authentication/presentation/string_validators.dart';
import 'package:go_router/go_router.dart';

class UpdateEmailScreen extends ConsumerStatefulWidget {
  final String userId;
  final String userEmail;

  const UpdateEmailScreen({
    required this.userId,
    required this.userEmail,
    super.key,
  });

  @override
  ConsumerState<UpdateEmailScreen> createState() => _UpdateEmailScreenState();
}

class _UpdateEmailScreenState extends ConsumerState<UpdateEmailScreen>
    with AuthValidators {
  final _formKey = GlobalKey<FormState>();
  final _newEmailController = TextEditingController();
  final _currentPasswordController = TextEditingController();

  String? _emailError;
  String? _passwordError;

  bool _isLoading = false;

  @override
  void dispose() {
    _newEmailController.dispose();
    _currentPasswordController.dispose();
    super.dispose();
  }

  Future<void> updateEmail() async {
    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
      _emailError = null;
      _passwordError = null;
    });

    final String newEmail = _newEmailController.text.trim();
    final String currentPassword = _currentPasswordController.text.trim();

    final bool emailInUse =
        await ref.read(authRepositoryProvider).isEmailAlreadyInUse(newEmail);
    if (emailInUse) {
      setState(() {
        _isLoading = false;
        _emailError = 'This email is already in use';
      });
    }

    final bool passwordValid = await ref
        .read(authRepositoryProvider)
        .validateCurrentPassword(widget.userEmail, currentPassword);

    if (!passwordValid) {
      setState(() {
        _isLoading = false;
        _passwordError = 'Incorrect current password';
      });
    }

    if (_formKey.currentState!.validate()) {
      // if (mounted) {
      //   context.pushNamed(
      //     RoutesName.updateEmailVerify,
      //     pathParameters: {
      //       'userId': widget.userId,
      //     },
      //     queryParameters: {
      //       'userEmail': widget.userEmail,
      //     },
      //   );
      // }
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoadingManager(
      isLoading: _isLoading,
      child: Scaffold(
        body: SingleChildScrollView(
          padding: AppPadding.screenPadding,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CancelDoneHeaderButton(
                  padding: const EdgeInsets.only(top: 10),
                  title: 'Update Email',
                  doneTitle: 'Next',
                  onCancel: () => context.pop(),
                  onDone: () async {
                    await updateEmail();
                  },
                ),
                Spacers.extraSmallVertical,
                CustomText(
                  title:
                      'The email currently associated with this account is ${widget.userEmail}. Please provide a new email address if you wish to update the existing one.',
                  overflow: TextOverflow.visible,
                ),
                Spacers.mediumVertical,
                CustomTextFormField(
                  label: 'New Email Address',
                  controller: _newEmailController,
                  hintText: 'Enter your new email..',
                  validator: (value) => _emailError,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  inputFormatters: [
                    ValidatorInputFormatter(
                      editingValidator: EmailEditingRegexValidator(),
                    ),
                  ],
                  prefixIcon: const Icon(Icons.email),
                ),
                Spacers.mediumVertical,
                CustomTextFormField(
                  label: 'Current Password',
                  controller: _currentPasswordController,
                  hintText: 'Enter your current password..',
                  textInputAction: TextInputAction.done,
                  obscureText: true,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  prefixIcon: const Icon(Icons.lock),
                  validator: (value) => _passwordError,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
