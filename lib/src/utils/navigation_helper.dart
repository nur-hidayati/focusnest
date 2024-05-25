import 'package:flutter/material.dart';
import 'package:focusnest/src/constants/routes_name.dart';
import 'package:focusnest/src/utils/alert_dialogs.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

// Utility functions for navigation & URL launching
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

  // ignore: prefer_const_constructors
  String timerSessionId = Uuid().v4();

  context.pushNamed(
    RoutesName.timerStart,
    queryParameters: {
      'userId': userId,
      'duration': timerDuration.inSeconds.toString(),
      'label': activityLabel,
      'timerSessionId': timerSessionId,
    },
  );
}

Future<void> launchURL(String url) async {
  final Uri uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    throw 'Could not launch $url';
  }
}
