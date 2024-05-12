import 'package:flutter/material.dart';
import 'package:focusnest/src/constants/app_padding.dart';

class ActivityTimerScreen extends StatelessWidget {
  const ActivityTimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppPadding.screenPadding,
          child: Column(
            children: [Text('Timer')],
          ),
        ),
      ),
    );
  }
}
