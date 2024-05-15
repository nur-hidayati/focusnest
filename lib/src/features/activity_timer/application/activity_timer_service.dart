import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusnest/src/features/activity_timer/data/activity_timer_database.dart';
import 'package:focusnest/src/features/activity_timer/data/activity_timers_dao.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String activityLabelKeySuffix = 'activityLabel';
const String timerDurationKeySuffix = 'timerDurationInSeconds';
const String deletedItemIdsSuffix = 'deletedItemIds';
const String initialActivityLabelValue = 'Work';
const Duration initialTimerDurationValue = Duration(minutes: 15);

String getActivityLabelKey(String userId) => '$userId-$activityLabelKeySuffix';
String getTimerDurationKey(String userId) => '$userId-$timerDurationKeySuffix';
String getDeletedItemIdsKey(String userId) => '$userId-$deletedItemIdsSuffix';

class ActivityLabelNotifier extends StateNotifier<String> {
  final String userId;

  ActivityLabelNotifier(this.userId) : super(initialActivityLabelValue) {
    _loadActivityLabel();
  }

  void _loadActivityLabel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String key = getActivityLabelKey(userId);
    state = prefs.getString(key) ?? initialActivityLabelValue;
  }

  void updateActivityLabel(String newLabel) async {
    state = newLabel;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String key = getActivityLabelKey(userId);
    await prefs.setString(key, newLabel);
  }
}

class TimerDurationNotifier extends StateNotifier<Duration> {
  final String userId;

  TimerDurationNotifier(this.userId) : super(initialTimerDurationValue) {
    _loadTimerDuration();
  }

  void _loadTimerDuration() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String key = getTimerDurationKey(userId);
    final durationInSeconds = prefs.getInt(key);
    if (durationInSeconds != null) {
      state = Duration(seconds: durationInSeconds);
    } else {
      state = initialTimerDurationValue;
    }
  }

  void updateTimerDuration(Duration newDuration) async {
    state = newDuration;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String key = getTimerDurationKey(userId);
    await prefs.setInt(key, newDuration.inSeconds);
  }
}

class RecentActivitiesNotifier extends StateNotifier<List<ActivityTimer>> {
  final ActivityTimersDao _dao;
  final String userId;
  List<String> _deletedItemIds = [];

  RecentActivitiesNotifier(this._dao, this.userId) : super([]) {
    _loadRecentActivities();
  }

  Future<void> _loadRecentActivities() async {
    final prefs = await SharedPreferences.getInstance();
    String key = getDeletedItemIdsKey(userId);
    _deletedItemIds = prefs.getStringList(key) ?? [];

    _dao.watchRecentActivities(userId).listen((recentActivities) {
      final filteredActivities = recentActivities
          .where((activity) => !_deletedItemIds.contains(activity.id))
          .toList();
      state = List.from(filteredActivities);
    });
  }

  Future<void> removeActivity(ActivityTimer activity) async {
    _deletedItemIds.add(activity.id);
    final prefs = await SharedPreferences.getInstance();
    String key = getDeletedItemIdsKey(userId);
    await prefs.setStringList(key, _deletedItemIds);

    state = List.from(state..remove(activity));
  }
}
