import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:focusnest/src/common_widgets/custom_text.dart';
import 'package:focusnest/src/constants/app_color.dart';
import 'package:go_router/go_router.dart';

class NotificationController {
  static ReceivedAction? initialAction;

  static Future<void> initializeLocalNotifications() async {
    await AwesomeNotifications().initialize(
      // null,
      'resource://drawable/res_app_icon',
      [
        NotificationChannel(
          channelGroupKey: 'timer_channel_group',
          channelKey: 'timer_channel',
          channelName: 'Timer Notifications',
          channelDescription: 'Notifications for timer activity',
          defaultColor: AppColor.primaryColor,
          importance: NotificationImportance.High,
          ledColor: Colors.white,
        )
      ],
      channelGroups: [
        NotificationChannelGroup(
          channelGroupKey: 'timer_channel_group',
          channelGroupName: 'Timer Group',
        )
      ],
      debug: true,
    );

    initialAction = await AwesomeNotifications()
        .getInitialNotificationAction(removeFromActionEvents: false);
  }

  // NOTIFICATION EVENTS LISTENER

  static Future<void> startListeningNotificationEvents() async {
    AwesomeNotifications()
        .setListeners(onActionReceivedMethod: onActionReceivedMethod);
  }

  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {}

  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {}

  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {}

  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {}

  // Create Timer Notification
  static Future<void> createTimerDoneNotification(BuildContext context) async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();

    if (!isAllowed) {
      return;
    }
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
      id: DateTime.now().millisecondsSinceEpoch.remainder(1000),
      title: 'FocusNest',
      body:
          'You\'ve successfully completed the task. Great job! ${Emojis.hand_clapping_hands}',
      channelKey: 'timer_channel',
    ));
  }
}

//  REQUESTING NOTIFICATION PERMISSIONS
void displayRequestPermission(BuildContext context) async {
  AwesomeNotifications().isNotificationAllowed().then(
    (isAllowed) {
      if (!isAllowed) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Allow Notifications'),
            content: const Text('Our app would like to send you notifications'),
            actions: [
              TextButton(
                onPressed: () {
                  context.pop();
                },
                child: const CustomText(
                  title: 'Deny',
                  color: AppColor.greyColor,
                ),
              ),
              TextButton(
                onPressed: () => AwesomeNotifications()
                    .requestPermissionToSendNotifications()
                    .then((_) => context.pop()),
                child: const CustomText(
                  title: 'Allow',
                  color: AppColor.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      }
    },
  );
}
