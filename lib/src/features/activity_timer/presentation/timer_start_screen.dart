import 'dart:async';

import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusnest/src/common_widgets/custom_button.dart';
import 'package:focusnest/src/common_widgets/custom_text.dart';
import 'package:focusnest/src/constants/app_color.dart';
import 'package:focusnest/src/constants/routes_name.dart';
import 'package:focusnest/src/constants/spacers.dart';
import 'package:focusnest/src/features/activity_timer/data/activity_timer_database.dart';
import 'package:focusnest/src/features/activity_timer/data/activity_timer_providers.dart';
import 'package:focusnest/src/services/notification_controller.dart';
import 'package:focusnest/src/utils/alert_dialogs.dart';
import 'package:focusnest/src/utils/app_logger.dart';
import 'package:focusnest/src/utils/date_time_helper.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

class TimerStartScreen extends ConsumerStatefulWidget {
  final String userId;
  final Duration duration;
  final String label;

  const TimerStartScreen({
    required this.userId,
    required this.duration,
    required this.label,
    super.key,
  });

  @override
  ConsumerState<TimerStartScreen> createState() => _TimerStartScreenState();
}

class _TimerStartScreenState extends ConsumerState<TimerStartScreen>
    with WidgetsBindingObserver {
  AppLifecycleState? _lastLifecycleState;
  bool isPaused = false;
  Timer? _timer;
  late Duration _remainingDuration;
  late DateTime _startDateTime;
  // ignore: prefer_const_constructors
  final _uuid = Uuid();

  @override
  void initState() {
    super.initState();
    _remainingDuration = widget.duration;
    _startDateTime = DateTime.now();
    _startTimer();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _timer?.cancel();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _lastLifecycleState = state;
  }

  void _startTimer() {
    if (_timer != null) return;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingDuration.inSeconds > 0) {
        setState(() {
          _remainingDuration = _remainingDuration - const Duration(seconds: 1);
        });
      } else {
        // Timer done
        _timer?.cancel();
        context.pushNamed(
          RoutesName.timerDone,
          queryParameters: {
            'duration': widget.duration.inSeconds.toString(),
          },
        );
        _addActivityToDatabase();
        if (_lastLifecycleState == AppLifecycleState.paused ||
            _lastLifecycleState == AppLifecycleState.detached) {
          NotificationController.createTimerDoneNotification(context);
        }
      }
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void _resumeTimer() {
    if (_timer == null) {
      _startTimer();
    }
  }

  void _stopTimer() async {
    final durationInSeconds =
        widget.duration.inSeconds - _remainingDuration.inSeconds;
    if (durationInSeconds >= 60) {
      bool? confirmAddActivity = await showAlertDialog(
        context: context,
        title: 'Activity Incomplete',
        content:
            'Would you like to add this incomplete activity to your calendar?',
        isNoAsCancel: true,
      );
      if (confirmAddActivity == true) {
        await _addActivityToDatabase();
      }
    }
    if (mounted) context.pop();
  }

  Future<void> _addActivityToDatabase() async {
    try {
      final endDateTime = DateTime.now();
      final targetedDurationInSeconds = widget.duration.inSeconds;
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

      await dao.insertActivityTimer(newActivity);

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

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).size.height * 0.2;

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.secondaryColor,
        body: Padding(
          padding: EdgeInsets.fromLTRB(20, topPadding, 20, 0),
          child: Column(
            children: [
              CustomText(
                title: widget.label,
                textType: TextType.titleLarge,
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
      ),
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
