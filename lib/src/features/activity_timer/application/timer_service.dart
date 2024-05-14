import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Define keys for SharedPreferences
const String activityLabelKey = 'activityLabel';
const String timerDurationKey = 'timerDuration';
const String initialActivityLabelValue = 'Work';
const String initialTimerDurationValue = '15:00';

// Providers for activity label and timer duration
final activityLabelProvider =
    StateNotifierProvider<ActivityLabelNotifier, String>((ref) {
  return ActivityLabelNotifier();
});

final timerDurationProvider =
    StateNotifierProvider<TimerDurationNotifier, String>((ref) {
  return TimerDurationNotifier();
});

// StateNotifier for activity label
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

// StateNotifier for timer duration
class TimerDurationNotifier extends StateNotifier<String> {
  TimerDurationNotifier() : super(initialTimerDurationValue) {
    _loadTimerDuration();
  }

  void _loadTimerDuration() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    state = prefs.getString(timerDurationKey) ?? initialTimerDurationValue;
  }

  void updateTimerDuration(String newDuration) async {
    state = newDuration;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(timerDurationKey, newDuration);
  }
}
