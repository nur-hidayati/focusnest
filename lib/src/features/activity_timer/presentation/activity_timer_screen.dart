import 'package:flutter/material.dart';
import 'package:focusnest/src/constants/app_padding.dart';
import 'package:focusnest/src/constants/spacers.dart';
import 'package:focusnest/src/features/activity_timer/presentation/recents_timer_activity_section.dart';
import 'package:focusnest/src/features/activity_timer/presentation/timer_section.dart';
import 'package:focusnest/src/services/notfication_controller.dart';

class ActivityTimerScreen extends StatefulWidget {
  const ActivityTimerScreen({super.key});

  @override
  State<ActivityTimerScreen> createState() => _ActivityTimerScreenState();
}

class _ActivityTimerScreenState extends State<ActivityTimerScreen> {
  @override
  void initState() {
    super.initState();
    displayRequestPermission(context);
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
