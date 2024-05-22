import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusnest/src/services/notification_controller.dart';

import 'app.dart';

// Main entry point for the app that performs common setup tasks.
// This includes initializing Firebase, setting up local notifications, and configuring the system UI.
Future<void> mainCommon(FirebaseOptions firebaseOptions, String flavor) async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // Preserve the splash screen until initialization is complete
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Set the preferred screen orientations to portrait mode
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set the system UI overlay style with a transparent status bar
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  await Firebase.initializeApp(
    options: firebaseOptions,
  );

  // Initialize local notifications
  await NotificationController.initializeLocalNotifications();

  runApp(
    ProviderScope(
      child: App(flavor: flavor),
    ),
  );
}

// Removes the splash screen after the app is fully loaded.
void removeSplashScreen() {
  FlutterNativeSplash.remove();
}
