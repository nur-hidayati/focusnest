import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusnest/src/features/activity_timer/data/activity_timers_dao.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'activity_timer_database.dart';

final activityTimerDatabaseProvider = Provider<ActivityTimerDatabase>((ref) {
  return ActivityTimerDatabase();
});

final activityTimersDaoProvider = Provider<ActivityTimersDao>((ref) {
  final db = ref.watch(activityTimerDatabaseProvider);
  return ActivityTimersDao(db);
});

final last10ActivityTimersProvider =
    StreamProvider.autoDispose<List<ActivityTimer>>((ref) {
  final dao = ref.watch(activityTimersDaoProvider);
  return dao.watchLast10ActivityTimers();
});
