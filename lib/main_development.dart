import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:focusnest/app.dart';
import 'package:focusnest/firebase_options_dev.dart' as dev;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: dev.DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App(flavor: 'DEVELOPMENT'));
}
