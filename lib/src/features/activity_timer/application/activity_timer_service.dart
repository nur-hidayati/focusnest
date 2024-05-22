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

// Generate unique keys for each user
String getActivityLabelKey(String userId) => '$userId-$activityLabelKeySuffix';
String getTimerDurationKey(String userId) => '$userId-$timerDurationKeySuffix';
String getDeletedItemIdsKey(String userId) => '$userId-$deletedItemIdsSuffix';

/// Notifier to manage the state of the activity label
class ActivityLabelNotifier extends StateNotifier<String> {
  final String userId;

  ActivityLabelNotifier(this.userId) : super(initialActivityLabelValue) {
    _loadActivityLabel();
  }

  // Loads the activity label from SharedPreferences
  void _loadActivityLabel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String key = getActivityLabelKey(userId);
    state = prefs.getString(key) ?? initialActivityLabelValue;
  }

  // Updates the activity label and saves it to SharedPreferences
  void updateActivityLabel(String newLabel) async {
    state = newLabel;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String key = getActivityLabelKey(userId);
    await prefs.setString(key, newLabel);
  }
}

// Notifier to manage the state of the timer duration
class TimerDurationNotifier extends StateNotifier<Duration> {
  final String userId;

  TimerDurationNotifier(this.userId) : super(initialTimerDurationValue) {
    _loadTimerDuration();
  }

  // Loads the timer duration from SharedPreferences
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

  // Updates the timer duration and saves it to SharedPreferences
  void updateTimerDuration(Duration newDuration) async {
    state = newDuration;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String key = getTimerDurationKey(userId);
    await prefs.setInt(key, newDuration.inSeconds);
  }
}

// Notifier to manage the state of recent activities
class RecentActivitiesNotifier extends StateNotifier<List<ActivityTimer>> {
  final ActivityTimersDao dao;
  final String _userId;

  RecentActivitiesNotifier(this.dao, this._userId) : super([]) {
    _loadRecentActivities();
  }

  // Loads the list of recent activities from SharedPreferences
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
      state = [];
    }
  }

  // Add new activity to the list and saves it to SharedPreferences
  void addActivity(ActivityTimer activity) {
    final exists = state.any((existingActivity) =>
        existingActivity.activityLabel == activity.activityLabel &&
        existingActivity.targetedDurationInSeconds ==
            activity.targetedDurationInSeconds);

    if (!exists) {
      state = [activity, ...state];
      _saveRecentActivities();
    }
  }

  // Removes an activity from the list and updates SharedPreferences
  void removeActivity(ActivityTimer activity) {
    state = state.where((item) => item.id != activity.id).toList();
    _saveRecentActivities();
  }

  // Saves the list of recent activities to SharedPreferences
  Future<void> _saveRecentActivities() async {
    final prefs = await SharedPreferences.getInstance();
    final recentActivitiesJson =
        state.map((activity) => jsonEncode(activity.toJson())).toList();
    await prefs.setStringList(
        'recentActivities_$_userId', recentActivitiesJson);
  }
}
