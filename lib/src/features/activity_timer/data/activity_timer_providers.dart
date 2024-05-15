import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusnest/src/features/activity_timer/application/activity_timer_service.dart';
import 'package:focusnest/src/features/activity_timer/data/activity_timers_dao.dart';

import 'activity_timer_database.dart';

final activityTimerDatabaseProvider = Provider<ActivityTimerDatabase>((ref) {
  return ActivityTimerDatabase();
});

final activityTimersDaoProvider = Provider<ActivityTimersDao>((ref) {
  final db = ref.watch(activityTimerDatabaseProvider);
  return ActivityTimersDao(db);
});

final activityLabelProvider =
    StateNotifierProvider<ActivityLabelNotifier, String>((ref) {
  return ActivityLabelNotifier();
});

final timerDurationProvider =
    StateNotifierProvider<TimerDurationNotifier, Duration>((ref) {
  return TimerDurationNotifier();
});

final recentActivitiesProvider =
    StateNotifierProvider<RecentActivitiesNotifier, List<ActivityTimer>>((ref) {
  final dao = ref.watch(activityTimersDaoProvider);
  return RecentActivitiesNotifier(dao);
});

final tempDurationProvider = StateProvider<Duration?>((ref) => null);
