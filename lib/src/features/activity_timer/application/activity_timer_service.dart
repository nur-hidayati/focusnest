import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusnest/src/features/activity_timer/data/activity_timer_database.dart';
import 'package:focusnest/src/features/activity_timer/data/activity_timers_dao.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Define keys for SharedPreferences
const String activityLabelKey = 'activityLabel';
const String timerDurationKey = 'timerDurationInSeconds';
const String initialActivityLabelValue = 'Work';
const Duration initialTimerDurationValue = Duration(minutes: 15);

class ActivityLabelNotifier extends StateNotifier<String> {
  ActivityLabelNotifier() : super(initialActivityLabelValue) {
    _loadActivityLabel();
  }

  void _loadActivityLabel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    state = prefs.getString(activityLabelKey) ?? initialActivityLabelValue;
  }

  void updateActivityLabel(String newLabel) async {
    state = newLabel;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(activityLabelKey, newLabel);
  }
}

class TimerDurationNotifier extends StateNotifier<Duration> {
  TimerDurationNotifier() : super(initialTimerDurationValue) {
    _loadTimerDuration();
  }

  void _loadTimerDuration() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final durationInSeconds = prefs.getInt(timerDurationKey);
    if (durationInSeconds != null) {
      state = Duration(seconds: durationInSeconds);
    } else {
      state = initialTimerDurationValue;
    }
  }

  void updateTimerDuration(Duration newDuration) async {
    state = newDuration;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(timerDurationKey, newDuration.inSeconds);
  }
}

class RecentActivitiesNotifier extends StateNotifier<List<ActivityTimer>> {
  RecentActivitiesNotifier(this._dao) : super([]) {
    _loadRecentActivities();
  }

  final ActivityTimersDao _dao;
  List<String> _deletedItemIds = [];

  Future<void> _loadRecentActivities() async {
    final prefs = await SharedPreferences.getInstance();
    _deletedItemIds = prefs.getStringList('deletedItemIds') ?? [];

    _dao.watchRecentActivities().listen((recentActivities) {
      final filteredActivities = recentActivities
          .where((activity) => !_deletedItemIds.contains(activity.id))
          .toList();
      state = List.from(filteredActivities);
    });
  }

  Future<void> removeActivity(ActivityTimer activity) async {
    _deletedItemIds.add(activity.id);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('deletedItemIds', _deletedItemIds);

    state = List.from(state..remove(activity));
  }
}
