import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusnest/src/services/notification_controller.dart';

import 'app.dart';

Future<void> mainCommon(FirebaseOptions firebaseOptions, String flavor) async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  await Firebase.initializeApp(
    options: firebaseOptions,
  );
  await NotificationController.initializeLocalNotifications();
  runApp(
    ProviderScope(
      child: App(flavor: flavor),
    ),
  );
}

void removeSplashScreen() {
  FlutterNativeSplash.remove();
}
