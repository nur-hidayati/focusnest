import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusnest/src/constants/app_padding.dart';
import 'package:focusnest/src/constants/spacers.dart';
import 'package:focusnest/src/constants/strings.dart';
import 'package:focusnest/src/features/activity_timer/presentation/recents_timer_activity_section.dart';
import 'package:focusnest/src/features/activity_timer/presentation/timer_section.dart';
import 'package:focusnest/src/features/authentication/data/auth_repository.dart';
import 'package:focusnest/src/services/notification_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Main Activity Timer Screen
class ActivityTimerScreen extends ConsumerStatefulWidget {
  const ActivityTimerScreen({super.key});

  @override
  ConsumerState<ActivityTimerScreen> createState() =>
      _ActivityTimerScreenState();
}

class _ActivityTimerScreenState extends ConsumerState<ActivityTimerScreen> {
  @override
  void initState() {
    super.initState();
    _displayReqPermissionFirstTimeRunApp();
  }

  // Checks if app is being run for the first time and, if so, requests notification permissions
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
    final authState = ref.watch(authStateChangesProvider);
    final userId = authState.asData?.value?.uid ?? Strings.guest;
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: AppPadding.noBottomPadding,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Spacers.largeVertical,
                TimerSection(userId: userId),
                Spacers.largeVertical,
                RecentsTimerActivitySection(userId: userId),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
