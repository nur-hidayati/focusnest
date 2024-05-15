import 'package:drift/drift.dart';
import 'package:focusnest/src/features/activity_timer/data/activity_timer_database.dart';

part 'activity_calendar_dao.g.dart';

@DriftAccessor(tables: [ActivityTimers])
class ActivityCalendarDao extends DatabaseAccessor<ActivityTimerDatabase>
    with _$ActivityCalendarDaoMixin {
  ActivityCalendarDao(super.db);

  Stream<List<ActivityTimer>> watchActivitiesForDate(
      String userId, DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);
    return (select(activityTimers)
          ..where((tbl) => tbl.userId.equals(userId))
          ..where(
              (tbl) => tbl.startDateTime.isBetweenValues(startOfDay, endOfDay)))
        .watch();
  }
}
