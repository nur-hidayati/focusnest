import 'package:drift/drift.dart';

import 'activity_timer_database.dart';

part 'activity_timers_dao.g.dart';

@DriftAccessor(tables: [ActivityTimers])
class ActivityTimersDao extends DatabaseAccessor<ActivityTimerDatabase>
    with _$ActivityTimersDaoMixin {
  // ignore: use_super_parameters
  ActivityTimersDao(ActivityTimerDatabase db) : super(db);

  // Stream to watch all activity timers
  Stream<List<ActivityTimer>> watchAllActivityTimers() {
    return select(activityTimers).watch();
  }

  // Stream to watch a specific activity timer by ID
  Stream<ActivityTimer?> watchActivityTimerById(String id) {
    return (select(activityTimers)..where((t) => t.id.equals(id)))
        .watchSingleOrNull();
  }

  Stream<List<ActivityTimer>> watchLast10ActivityTimers() {
    return (select(activityTimers)
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.createdDate, mode: OrderingMode.desc)
          ])
          ..limit(10))
        .watch();
  }

  // Insert a new activity timer
  Future<int> insertActivityTimer(ActivityTimersCompanion entry) {
    return into(activityTimers).insert(entry);
  }

  // Update an existing activity timer
  Future<bool> updateActivityTimer(ActivityTimersCompanion entry) {
    return update(activityTimers).replace(entry);
  }

  // Delete an activity timer by ID
  Future<int> deleteActivityTimerById(String id) {
    return (delete(activityTimers)..where((t) => t.id.equals(id))).go();
  }

  // Fetch all activity timers
  Future<List<ActivityTimer>> getAllActivityTimers() {
    return select(activityTimers).get();
  }
}
