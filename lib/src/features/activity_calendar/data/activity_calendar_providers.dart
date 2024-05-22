import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusnest/src/features/activity_timer/data/activity_timer_providers.dart';

// Provider for `ActivityCalendarDao`.
import 'activity_calendar_dao.dart';

final activityCalendarDaoProvider = Provider<ActivityCalendarDao>((ref) {
  final db = ref.watch(activityTimerDatabaseProvider);
  return ActivityCalendarDao(db);
});
