import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:focusnest/app.dart';
import 'package:focusnest/firebase_options_prod.dart' as prod;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: prod.DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App(flavor: 'PRODUCTION'));
}
