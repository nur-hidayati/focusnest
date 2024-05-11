import 'package:flutter/material.dart';
import 'package:focusnest/src/features/authentication/presentation/auth_screen.dart';
import 'package:focusnest/src/utils/theme.dart';

class App extends StatelessWidget {
  final String flavor;

  const App({
    required this.flavor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FocusNest',
      debugShowCheckedModeBanner: false,
      home: const AuthScreen(),
      theme: appTheme(),
    );
  }
}
