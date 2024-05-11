import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusnest/src/exceptions/app_exception.dart';
import 'package:focusnest/src/utils/alert_dialogs.dart';
import 'package:focusnest/src/utils/app_logger.dart';

extension AsyncValueUI on AsyncValue {
  void showAlertDialogOnError(BuildContext context) {
    if (!isLoading && hasError) {
      final message = _errorMessage(error);
      showExceptionAlertDialog(
        context: context,
        title: 'Error',
        exception: message,
      );
    }
  }

  String _errorMessage(Object? error) {
    if (error is FirebaseAuthException) {
      String errorMessage;
      switch (error.code) {
        case 'invalid-credential':
          errorMessage = 'Invalid Username or Password';
          break;
        default:
          errorMessage = error.message ?? 'An unknown error occurred';
      }
      return errorMessage;
    } else if (error is AppException) {
      return error.message;
    } else {
      AppLogger.logError('$error');
      return 'Oops! Something went wrong. Please try again.';
    }
  }
}
