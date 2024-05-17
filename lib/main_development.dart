import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusnest/app.dart';
import 'package:focusnest/firebase_options_dev.dart' as dev;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  await Firebase.initializeApp(
    options: dev.DefaultFirebaseOptions.currentPlatform,
  );

  AwesomeNotifications().initialize(
      null,
      // 'resource://drawable/res_app_icon',
      [
        NotificationChannel(
          channelGroupKey: 'basic_channel_group',
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Basic Notifications channel',
          defaultColor: Colors.green,
          importance: NotificationImportance.High,
          ledColor: Colors.white,
        )
      ], channelGroups: [
    NotificationChannelGroup(
        channelGroupKey: 'basic_channel_group', channelGroupName: 'Basic group')
  ]);

  bool isAllowedSendNotification =
      await AwesomeNotifications().isNotificationAllowed();

  if (!isAllowedSendNotification) {
    AwesomeNotifications().requestPermissionToSendNotifications();
  }

  runApp(
    const ProviderScope(
      child: App(flavor: 'DEVELOPMENT'),
    ),
  );
}
