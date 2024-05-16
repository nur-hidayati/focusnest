import 'dart:convert';

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
  final String _userId;

  RecentActivitiesNotifier(this._dao, this._userId) : super([]) {
    _loadRecentActivities();
  }

  Future<void> _loadRecentActivities() async {
    final prefs = await SharedPreferences.getInstance();
    final recentActivitiesJson =
        prefs.getStringList('recentActivities_$_userId') ?? [];
    if (recentActivitiesJson.isNotEmpty) {
      final recentActivities = recentActivitiesJson
          .map((json) => ActivityTimer.fromJson(jsonDecode(json)))
          .toList();
      state = recentActivities;
    } else {
      final recentActivities = await _dao.getRecentActivities(_userId);
      state = recentActivities;
      _saveRecentActivities();
    }
  }

  void addActivity(ActivityTimer activity) {
    state = [activity, ...state];
    _saveRecentActivities();
  }

  void removeActivity(ActivityTimer activity) {
    state = state.where((item) => item.id != activity.id).toList();
    _saveRecentActivities();
  }

  Future<void> _saveRecentActivities() async {
    final prefs = await SharedPreferences.getInstance();
    final recentActivitiesJson =
        state.map((activity) => jsonEncode(activity.toJson())).toList();
    await prefs.setStringList(
        'recentActivities_$_userId', recentActivitiesJson);
  }
}
