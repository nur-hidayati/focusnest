import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusnest/src/features/activity_timer/application/activity_timer_service.dart';
import 'package:focusnest/src/features/activity_timer/data/activity_timers_dao.dart';

import 'activity_timer_database.dart';

// Providers for accessing and managing activity timers and related state.
// Includes database and DAO providers, as well as state notifiers for
// activity labels, timer durations, and recent activities
final activityTimerDatabaseProvider = Provider<ActivityTimerDatabase>((ref) {
  return ActivityTimerDatabase();
});

final activityTimersDaoProvider = Provider<ActivityTimersDao>((ref) {
  final db = ref.watch(activityTimerDatabaseProvider);
  return ActivityTimersDao(db);
});

final activityLabelProvider =
    StateNotifierProvider.family<ActivityLabelNotifier, String, String>(
        (ref, userId) {
  return ActivityLabelNotifier(userId);
});

final timerDurationProvider =
    StateNotifierProvider.family<TimerDurationNotifier, Duration, String>(
        (ref, userId) {
  return TimerDurationNotifier(userId);
});

final recentActivitiesProvider = StateNotifierProvider.family<
    RecentActivitiesNotifier, List<ActivityTimer>, String>((ref, userId) {
  final dao = ref.watch(activityTimersDaoProvider);
  return RecentActivitiesNotifier(dao, userId);
});

final tempDurationProvider = StateProvider<Duration?>((ref) => null);
