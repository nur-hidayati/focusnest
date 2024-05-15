import 'package:flutter/material.dart';
import 'package:focusnest/src/constants/routes_name.dart';
import 'package:focusnest/src/utils/alert_dialogs.dart';
import 'package:go_router/go_router.dart';

void navigateToTimerStart({
  required BuildContext context,
  String? userId,
  required Duration timerDuration,
  required String activityLabel,
}) {
  if (userId == null) {
    showOKAlert(
      context: context,
      title: 'Error!',
      content: 'Unable to start timer. User not found',
    );
    return;
  }

  context.pushNamed(
    RoutesName.timerStart,
    queryParameters: {
      'userId': userId,
      'duration': timerDuration.inSeconds.toString(),
      'label': activityLabel,
    },
  );
}
