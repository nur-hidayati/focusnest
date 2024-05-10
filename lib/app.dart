import 'package:flutter/material.dart';

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
      home: Scaffold(
        appBar: AppBar(
          title: Text(flavor),
        ),
      ),
    );
  }
}
