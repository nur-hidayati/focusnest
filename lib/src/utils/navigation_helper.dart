import 'package:flutter/material.dart';
import 'package:focusnest/src/constants/routes_name.dart';
import 'package:focusnest/src/utils/alert_dialogs.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

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

Future<void> launchURL(String url) async {
  final Uri uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    throw 'Could not launch $url';
  }
}
