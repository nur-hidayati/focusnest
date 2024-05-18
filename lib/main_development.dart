import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusnest/app.dart';
import 'package:focusnest/firebase_options_dev.dart' as dev;
import 'package:focusnest/src/services/notfication_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  await Firebase.initializeApp(
    options: dev.DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationController.initializeLocalNotifications();
  runApp(
    const ProviderScope(
      child: App(flavor: 'DEVELOPMENT'),
    ),
  );
}
