import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Define keys for SharedPreferences
const String activityLabelKey = 'activityLabel';
const String timerDurationKey = 'timerDurationInSeconds';
const String initialActivityLabelValue = 'Work';
const Duration initialTimerDurationValue = Duration(minutes: 15);

// Providers for activity label and timer duration
final activityLabelProvider =
    StateNotifierProvider<ActivityLabelNotifier, String>((ref) {
  return ActivityLabelNotifier();
});

final timerDurationProvider =
    StateNotifierProvider<TimerDurationNotifier, Duration>((ref) {
  return TimerDurationNotifier();
});

final tempDurationProvider = StateProvider<Duration?>((ref) => null);

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
