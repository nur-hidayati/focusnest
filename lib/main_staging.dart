import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:focusnest/app.dart';
import 'package:focusnest/firebase_options_stg.dart' as stg;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: stg.DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App(flavor: 'STAGING'));
}
