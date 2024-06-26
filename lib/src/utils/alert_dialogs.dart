import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// This file contains various functions to display alert dialogs
const kDialogDefaultKey = Key('dialog-default-key');

Future<bool?> showAlertDialog({
  required BuildContext context,
  required String title,
  String? content,
  String defaultActionText = 'Yes',
  bool isNoAsCancel = false,
  bool isCancelAction = true,
}) async {
  String cancelActionText = !isNoAsCancel ? 'Cancel' : 'No';
  return showDialog(
    context: context,
    barrierDismissible: isCancelAction,
    builder: (context) => AlertDialog.adaptive(
      title: Text(title),
      content: content != null ? Text(content) : null,
      actions: kIsWeb || !Platform.isIOS
          ? <Widget>[
              if (isCancelAction)
                TextButton(
                  child: Text(cancelActionText),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
              TextButton(
                key: kDialogDefaultKey,
                child: Text(defaultActionText),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ]
          : <Widget>[
              if (isCancelAction)
                CupertinoDialogAction(
                  child: Text(cancelActionText),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
              CupertinoDialogAction(
                key: kDialogDefaultKey,
                child: Text(defaultActionText),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
    ),
  );
}

Future<void> showExceptionAlertDialog({
  required BuildContext context,
  required String title,
  required dynamic exception,
}) =>
    showAlertDialog(
      context: context,
      title: title,
      content: exception.toString(),
      defaultActionText: 'OK',
    );

Future<void> showNotImplementedAlertDialog({required BuildContext context}) =>
    showAlertDialog(
      context: context,
      title: 'Not implemented',
    );

Future<void> showOKAlert({
  required BuildContext context,
  required String title,
  required String content,
}) {
  return showAlertDialog(
    context: context,
    title: title,
    content: content,
    isCancelAction: false,
    defaultActionText: 'OK',
  );
}

Future<void> showInvalidDurationAlert(BuildContext ctx) {
  return showOKAlert(
    context: ctx,
    title: 'Invalid Duration',
    content: 'Duration cannot be zero',
  );
}

Future<void> showInvalidLabelAlert(BuildContext ctx) {
  return showOKAlert(
    context: ctx,
    title: 'Invalid Activity Label',
    content: 'Activity Label cannot be empty',
  );
}

Future<bool?> showDeleteRecordAlert(BuildContext ctx) {
  return showAlertDialog(
      context: ctx,
      title: 'Delete Record',
      content:
          'Are you sure want to delete this record permanently? You cannot undo this action.');
}
