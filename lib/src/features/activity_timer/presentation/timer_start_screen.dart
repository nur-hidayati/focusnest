import 'dart:async';

import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusnest/src/common_widgets/custom_button.dart';
import 'package:focusnest/src/common_widgets/custom_text.dart';
import 'package:focusnest/src/common_widgets/loading_indicator.dart';
import 'package:focusnest/src/constants/app_color.dart';
import 'package:focusnest/src/constants/routes_name.dart';
import 'package:focusnest/src/constants/shared_prefs_keys.dart';
import 'package:focusnest/src/constants/spacers.dart';
import 'package:focusnest/src/features/activity_timer/data/activity_timer_database.dart';
import 'package:focusnest/src/features/activity_timer/data/activity_timer_providers.dart';
import 'package:focusnest/src/services/notification_controller.dart';
import 'package:focusnest/src/utils/alert_dialogs.dart';
import 'package:focusnest/src/utils/app_logger.dart';
import 'package:focusnest/src/utils/date_time_helper.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

// Full Screen that is displayed when user start the timer
class TimerStartScreen extends ConsumerStatefulWidget {
  final String userId;
  final Duration duration;
  final String label;
  final String timerSessionId;

  const TimerStartScreen({
    required this.userId,
    required this.duration,
    required this.label,
    required this.timerSessionId,
    super.key,
  });

  @override
  ConsumerState<TimerStartScreen> createState() => _TimerStartScreenState();
}

class _TimerStartScreenState extends ConsumerState<TimerStartScreen>
    with WidgetsBindingObserver {
  bool isPaused = false;
  Timer? _timer;
  Duration _remainingDuration = Duration.zero;
  bool _isInitialized = false;

  SharedPreferences? _prefs;

  // ignore: prefer_const_constructors
  final _uuid = Uuid();
  late DateTime _startDateTime;

  @override
  void initState() {
    super.initState();
    _initializeSession().then((_) => _initializeTimer());

    // Set screen to full screen
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    WidgetsBinding.instance.addObserver(this);
  }

  Future<void> _initializeSession() async {
    _prefs = await SharedPreferences.getInstance();
    if (_prefs != null) {
      String lastTimerId = _prefs?.getString(SharedPrefsKeys.lastTimerId) ?? '';
      await _prefs!
          .setString(SharedPrefsKeys.lastTimerId, widget.timerSessionId);
      if (widget.timerSessionId != lastTimerId) {
        _clearTimerPreferences();
      }
    }
  }

  Future<void> _initializeTimer() async {
    _remainingDuration = widget.duration;
    _startTimer();
    _startDateTime = DateTime.now();
    _loadTimerState();
    setState(() {
      _isInitialized = true;
    });
  }

  @override
  void dispose() {
    // Cancel the periodic timer if it is running
    _timer?.cancel();
    // Restore the system UI to normal mode (exit full-screen mode)
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    WidgetsBinding.instance.removeObserver(this);
    // Clear saved timer state if the timer is null or not active
    if (_timer == null || !_timer!.isActive) {
      _clearTimerPreferences();
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Called when the app is paused (e.g., user switches to another app).
    if (state == AppLifecycleState.paused) {
      _prefs!.setBool(SharedPrefsKeys.isForeground, false);
      if (_remainingDuration.inSeconds > 0) {
        _saveTimerState();
        // Only scheduled notifications if timer is not paused
        if (!isPaused) {
          NotificationController.createTimerDoneNotification(
            context,
            DateTime.now().add(_remainingDuration),
          );
        }
      }
      // Called when the app is resumed from a paused state.
    } else if (state == AppLifecycleState.resumed) {
      _prefs!.setBool(SharedPrefsKeys.isForeground, true);
      _loadTimerState();
      NotificationController.cancelScheduledNotification();
      // Called when the app is about to be terminated (e.g., the user kills the app).
    } else if (state == AppLifecycleState.detached) {
      NotificationController.cancelScheduledNotification();
      _clearTimerPreferences();
    }
  }

  // Saves the current state of the timer (remaining duration and timestamp)
  void _saveTimerState() async {
    if (_prefs != null && _remainingDuration.inSeconds > 0) {
      // Save the remaining duration (in seconds)
      await _prefs!
          .setInt(SharedPrefsKeys.timerSeconds, _remainingDuration.inSeconds);
      // Save the current timestamp
      await _prefs!.setInt(
          SharedPrefsKeys.savedTime, DateTime.now().millisecondsSinceEpoch);
    }
  }

  // This method restores the timer state when the app is resumed or reinitialized.
  // Example Scenario:
  // 1. Timer is set for 10 minutes (600 seconds).
  // 2. Timer is paused with 5 minutes (300 seconds) remaining.
  // 3. Timer was paused at 2024-05-24 10:00:00 (savedMillis = 1716852000000).
  // 4. App is resumed 2 minutes later at 2024-05-24 10:02:00.
  //
  // Steps in the method:
  // 1. Retrieve saved timer data from SharedPreferences:
  //    - savedSeconds = 300 (5 minutes remaining)
  //    - savedMillis = 1716852000000 (timestamp when paused)
  // 2. If the timer was paused (isPaused is true):
  //    - Set _remainingDuration to savedSeconds (300 seconds i.e. 5 minutes)
  // 3. If the timer was running (isPaused is false):
  //    - Calculate elapsed time:
  //      - Current time: 2024-05-24 10:02:00
  //      - Elapsed time: 2 minutes (120 seconds)
  //    - Update remaining duration:
  //      - newSeconds = savedSeconds - elapsed.inSeconds
  //      - newSeconds = 300 - 120 = 180 seconds (3 minutes remaining)
  //    - Update _remainingDuration with the new remaining time (3 minutes).
  //    - If the new remaining time is zero or less, trigger _timerDone().
  void _loadTimerState() {
    int? savedSeconds = _prefs?.getInt(SharedPrefsKeys.timerSeconds);
    int? savedMillis = _prefs?.getInt(SharedPrefsKeys.savedTime);

    if (savedSeconds != null && savedMillis != null) {
      DateTime savedTime = DateTime.fromMillisecondsSinceEpoch(savedMillis);

      if (!isPaused) {
        Duration elapsed = DateTime.now().difference(savedTime);
        int newSeconds = savedSeconds - elapsed.inSeconds;
        _remainingDuration = Duration(seconds: newSeconds > 0 ? newSeconds : 0);
        if (newSeconds <= 0) {
          _timerDone();
        }
      } else {
        _remainingDuration = Duration(seconds: savedSeconds);
      }
    }
  }

  void _startTimer() {
    // Check if the timer is already running
    // To prevents starting multiple timers
    if (_timer != null) return;
    // Initialize a periodic timer that ticks every second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // Check if there is remaining time left
      if (_remainingDuration.inSeconds > 0) {
        setState(() {
          _remainingDuration = _remainingDuration - const Duration(seconds: 1);
        });
      } else {
        // If no time is left, handle the timer completion
        _timerDone();
      }
    });
  }

  void _timerDone() {
    _timer?.cancel();
    _clearTimerPreferences();
    context.pushNamed(
      RoutesName.timerDone,
      queryParameters: {
        'duration': widget.duration.inSeconds.toString(),
        'playSound':
            (_prefs?.getBool(SharedPrefsKeys.isForeground) ?? true).toString(),
      },
    );
    _addActivityToDatabase(DateTime.now());
  }

  // Pauses the running timer by canceling it and setting the timer reference to null.
  void _pauseTimer() {
    // Cancel the periodic timer if it is running
    _timer?.cancel();
    // Set the timer reference to null
    _timer = null;
  }

  // Resumes the timer if it is not currently running by starting a new timer.
  void _resumeTimer() {
    if (_timer == null) {
      _startTimer();
    }
  }

  // Stops the timer and optionally saves the activity if it ran for at least 60 seconds
  void _stopTimer() async {
    NotificationController.cancelScheduledNotification();
    final endDateTime = DateTime.now();

    // Calculate the duration the timer has run in seconds
    final durationInSeconds =
        widget.duration.inSeconds - _remainingDuration.inSeconds;

    // Check if the timer has run for at least 60 seconds
    if (durationInSeconds >= 60) {
      bool? confirmAddActivity = await showAlertDialog(
        context: context,
        title: 'Incomplete Activity',
        content:
            'It looks like you did not finish the activity. Would you like to add it to your calendar anyway?',
        isNoAsCancel: true,
      );
      if (confirmAddActivity == true) {
        await _addActivityToDatabase(endDateTime);
      }
    }

    // Clear the saved timer state from SharedPreferences
    _clearTimerPreferences();
    if (mounted) context.pop();
  }

  Future<void> _addActivityToDatabase(DateTime endDateTime) async {
    try {
      // The initial timer duration that user set
      final targetedDurationInSeconds = widget.duration.inSeconds;
      // Calculate the actual duration in seconds
      final durationInSeconds =
          targetedDurationInSeconds - _remainingDuration.inSeconds;
      final dao = ActivityTimerDatabase().activityTimersDao;

      final newActivity = ActivityTimersCompanion(
        id: drift.Value(_uuid.v4()),
        userId: drift.Value(widget.userId),
        activityLabel: drift.Value(widget.label),
        actualDurationInSeconds: drift.Value(durationInSeconds),
        targetedDurationInSeconds: drift.Value(targetedDurationInSeconds),
        startDateTime: drift.Value(_startDateTime),
        endDateTime: drift.Value(endDateTime),
        createdDate: drift.Value(DateTime.now()),
      );

      // Insert the new activity into the database
      await dao.insertActivityTimer(newActivity);

      // Create a recent activity object to update the notifier
      final recentActivity = ActivityTimer(
        id: _uuid.v4(),
        userId: widget.userId,
        activityLabel: widget.label,
        actualDurationInSeconds: durationInSeconds,
        targetedDurationInSeconds: targetedDurationInSeconds,
        startDateTime: _startDateTime,
        endDateTime: endDateTime,
        createdDate: DateTime.now(),
      );

      // Update the recent activities notifier with the new activity
      final recentActivitiesNotifier =
          ref.read(recentActivitiesProvider(widget.userId).notifier);
      recentActivitiesNotifier.addActivity(recentActivity);
    } catch (error) {
      AppLogger.logError(error.toString());
      if (mounted) {
        showOKAlert(
          context: context,
          title: 'Error!',
          content: 'Unable to add activity!',
        );
      }
    }
  }

  // Clears the saved timer state from SharedPreferences.
  Future<void> _clearTimerPreferences() async {
    if (_prefs != null) {
      await _prefs!.remove(SharedPrefsKeys.timerSeconds);
      await _prefs!.remove(SharedPrefsKeys.savedTime);
      await _prefs!.remove(SharedPrefsKeys.isForeground);
    }
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).size.height * 0.2;

    return Scaffold(
      backgroundColor: AppColor.secondaryColor,
      body: _isInitialized
          ? SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, topPadding, 20, 0),
                child: Column(
                  children: [
                    CustomText(
                      title: widget.label,
                      textType: TextType.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    Spacers.extraLargeVertical,
                    CustomText(
                      title: formatDurationToHms(_remainingDuration),
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                    ),
                    Spacers.extraLargeVertical,
                    _timerButtonSection(),
                  ],
                ),
              ),
            )
          : const LoadingIndicator(),
    );
  }

  Widget _timerButtonSection() {
    return Column(
      children: [
        if (!isPaused)
          Center(
            child: CustomButton(
              title: 'Pause',
              onPressed: () {
                setState(() {
                  isPaused = true;
                  _pauseTimer();
                });
              },
            ),
          ),
        if (isPaused)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: CustomButton(
                    title: 'Resume',
                    onPressed: () {
                      setState(() {
                        isPaused = false;
                        _resumeTimer();
                      });
                    },
                  ),
                ),
                Spacers.largeHorizontal,
                Expanded(
                  child: CustomButton(
                    title: 'Stop',
                    onPressed: _stopTimer,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
