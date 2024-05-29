import 'package:focusnest/src/constants/strings.dart';

enum AuthFormType { signIn, register }

// Extension on [AuthFormType] to provide additional functionality and properties
extension AuthFormTypeX on AuthFormType {
  String get headerText {
    if (this == AuthFormType.register) {
      return 'Create Account';
    } else {
      return 'Sign In';
    }
  }

  String get bottomText {
    if (this == AuthFormType.register) {
      return 'Have an account? ';
    } else {
      return 'New to ${Strings.appName}? ';
    }
  }

  String get bottomTextLink {
    if (this == AuthFormType.register) {
      return 'Login';
    } else {
      return 'Sign Up Now';
    }
  }

  String get title {
    if (this == AuthFormType.register) {
      return 'Sign Up';
    } else {
      return 'Log In';
    }
  }

  AuthFormType get headerActionFormType {
    if (this == AuthFormType.register) {
      return AuthFormType.signIn;
    } else {
      return AuthFormType.register;
    }
  }
}
