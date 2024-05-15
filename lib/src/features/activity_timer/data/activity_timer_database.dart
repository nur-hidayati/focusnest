// These additional imports are necessary to open the sqlite3 database
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:focusnest/src/features/activity_calendar/data/activity_calendar_dao.dart';
import 'package:focusnest/src/features/activity_timer/data/activity_timers_dao.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';
import 'package:uuid/uuid.dart';

part 'activity_timer_database.g.dart';

// ignore: prefer_const_constructors
final _uuid = Uuid();

class ActivityTimers extends Table {
  TextColumn get id => text().clientDefault(() => _uuid.v4())();
  TextColumn get userId => text()();
  TextColumn get activityLabel => text()();
  IntColumn get actualDurationInSeconds => integer()();
  IntColumn get targetedDurationInSeconds => integer()();
  DateTimeColumn get startDateTime => dateTime()();
  DateTimeColumn get endDateTime => dateTime()();
  DateTimeColumn get createdDate => dateTime()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
        {userId, id}
      ];
}

@DriftDatabase(
    tables: [ActivityTimers], daos: [ActivityTimersDao, ActivityCalendarDao])
class ActivityTimerDatabase extends _$ActivityTimerDatabase {
  ActivityTimerDatabase._internal() : super(_openConnection());

  static final ActivityTimerDatabase _instance =
      ActivityTimerDatabase._internal();

  factory ActivityTimerDatabase() {
    return _instance;
  }

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'activity_timer_v1.sqlite'));

    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }

    final cachebase = (await getTemporaryDirectory()).path;
    sqlite3.tempDirectory = cachebase;

    return NativeDatabase.createInBackground(file);
  });
}
