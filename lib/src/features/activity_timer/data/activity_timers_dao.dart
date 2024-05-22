import 'package:drift/drift.dart';

import 'activity_timer_database.dart';

part 'activity_timers_dao.g.dart';

// Methods to watch activity timers, get recent activities, insert new timers,
// and filter duplicates based on duration and activity label
@DriftAccessor(tables: [ActivityTimers])
class ActivityTimersDao extends DatabaseAccessor<ActivityTimerDatabase>
    with _$ActivityTimersDaoMixin {
  ActivityTimersDao(super.db);

  Stream<List<ActivityTimer>> watchAllActivityTimers(String userId) {
    return (select(activityTimers)..where((tbl) => tbl.userId.equals(userId)))
        .watch();
  }

  Stream<ActivityTimer?> watchActivityTimerById(String id, String userId) {
    return (select(activityTimers)
          ..where((t) => t.id.equals(id) & t.userId.equals(userId)))
        .watchSingleOrNull();
  }

  Future<List<ActivityTimer>> getRecentActivities(String userId) async {
    final query = select(activityTimers)
      ..where((tbl) => tbl.userId.equals(userId))
      ..orderBy([
        (t) => OrderingTerm(expression: t.createdDate, mode: OrderingMode.desc)
      ])
      ..limit(10);

    final result = await query.get();
    return filterDuplicates(result);
  }

  Future<int> insertActivityTimer(ActivityTimersCompanion entry) {
    return into(activityTimers).insert(entry);
  }

  List<ActivityTimer> filterDuplicates(List<ActivityTimer> timers) {
    final uniqueTimers = <String, ActivityTimer>{};
    for (var timer in timers) {
      final key = '${timer.targetedDurationInSeconds}-${timer.activityLabel}';
      if (!uniqueTimers.containsKey(key)) {
        uniqueTimers[key] = timer;
      }
    }
    return uniqueTimers.values.toList();
  }
}
