import 'package:flutter/material.dart';
import 'package:focusnest/src/constants/app_padding.dart';
import 'package:focusnest/src/constants/spacers.dart';
import 'package:focusnest/src/features/activity_timer/presentation/recents_timer_activity_section.dart';
import 'package:focusnest/src/features/activity_timer/presentation/timer_section.dart';
import 'package:focusnest/src/services/notfication_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ActivityTimerScreen extends StatefulWidget {
  const ActivityTimerScreen({super.key});

  @override
  State<ActivityTimerScreen> createState() => _ActivityTimerScreenState();
}

class _ActivityTimerScreenState extends State<ActivityTimerScreen> {
  @override
  void initState() {
    super.initState();
    _displayReqPermissionFirstTimeRunApp();
  }

  Future<void> _displayReqPermissionFirstTimeRunApp() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstTime = prefs.getBool('isFirstTime') ?? true;

    if (isFirstTime) {
      if (mounted) {
        displayRequestPermission(context);
      }
      await prefs.setBool('isFirstTime', false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: Padding(
          padding: AppPadding.noBottomPadding,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Spacers.largeVertical,
                TimerSection(),
                Spacers.largeVertical,
                RecentsTimerActivitySection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
