import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:focusnest/src/common_widgets/custom_button.dart';
import 'package:focusnest/src/common_widgets/custom_text.dart';
import 'package:focusnest/src/constants/app_color.dart';
import 'package:focusnest/src/constants/routes_name.dart';
import 'package:focusnest/src/constants/spacers.dart';
import 'package:focusnest/src/utils/alert_dialogs.dart';
import 'package:focusnest/src/utils/date_time_helper.dart';
import 'package:go_router/go_router.dart';

class TimerStartScreen extends StatefulWidget {
  final Duration duration;
  final String label;

  const TimerStartScreen({
    required this.duration,
    required this.label,
    super.key,
  });

  @override
  State<TimerStartScreen> createState() => _TimerStartScreenState();
}

class _TimerStartScreenState extends State<TimerStartScreen> {
  bool isPaused = false;
  Timer? _timer;
  late Duration _remainingDuration;

  @override
  void initState() {
    super.initState();
    _remainingDuration = widget.duration;
    _startTimer();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    _timer?.cancel();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void _startTimer() {
    if (_timer != null) return;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingDuration.inSeconds > 0) {
        setState(() {
          _remainingDuration = _remainingDuration - const Duration(seconds: 1);
        });
      } else {
        _timer?.cancel();
        context.pushNamed(
          RoutesName.timerDone,
          queryParameters: {
            'duration': widget.duration.inSeconds.toString(),
          },
        );
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
    bool? confirmAddActivity = await showAlertDialog(
      context: context,
      title: 'Activity Incomplete',
      content:
          'Would you like to add this incomplete activity to your calendar?',
      isNoAsCancel: true,
    );

    if (confirmAddActivity == true) {
      // TODO: Remove this later
      if (mounted) {
        context.pushNamed(
          RoutesName.timerDone,
          queryParameters: {
            'duration': widget.duration.inSeconds.toString(),
          },
        );
      }
    } else {
      if (mounted) context.pop();
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
