import 'package:focusnest/src/features/authentication/presentation/auth_form_type.dart';
import 'package:focusnest/src/features/authentication/presentation/string_validators.dart';

// Mixin providing validation logic for authentication forms
mixin AuthValidators {
  final StringValidator emailSubmitValidator = EmailSubmitRegexValidator();
  final StringValidator passwordRegisterSubmitValidator =
      MinLengthStringValidator(6);
  final StringValidator passwordSignInSubmitValidator =
      NonEmptyStringValidator();

  // Validates the email input
  bool canSubmitEmail(String email) {
    return emailSubmitValidator.isValid(email);
  }

  // Validates the password input based on the form type
  bool canSubmitPassword(String password, AuthFormType formType) {
    if (formType == AuthFormType.register) {
      return passwordRegisterSubmitValidator.isValid(password);
    }
    return passwordSignInSubmitValidator.isValid(password);
  }

  // Provides error text for invalid email input
  String? emailErrorText(String email) {
    final bool showErrorText = !canSubmitEmail(email);
    final String errorText =
        email.isEmpty ? 'Email can\'t be empty' : 'Invalid email';
    return showErrorText ? errorText : null;
  }

  // Provides error text for invalid password input based on the form type
  String? passwordErrorText(String password, AuthFormType formType) {
    final bool showErrorText = !canSubmitPassword(password, formType);
    final String errorText = password.isEmpty
        ? 'Password can\'t be empty'
        : 'Password need to be at least 6 characters';
    return showErrorText ? errorText : null;
  }
}
