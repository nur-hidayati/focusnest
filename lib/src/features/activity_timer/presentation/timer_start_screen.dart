import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:focusnest/src/common_widgets/custom_button.dart';
import 'package:focusnest/src/common_widgets/custom_text.dart';
import 'package:focusnest/src/constants/app_color.dart';
import 'package:focusnest/src/constants/spacers.dart';

class TimerStartScreen extends StatefulWidget {
  const TimerStartScreen({super.key});

  @override
  State<TimerStartScreen> createState() => _TimerStartScreenState();
}

class _TimerStartScreenState extends State<TimerStartScreen> {
  bool isPaused = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
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
              const CustomText(
                title: 'Study',
                textType: TextType.titleLarge,
              ),
              Spacers.extraLargeVertical,
              const CustomText(
                title: '15:00:00',
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
                      setState(() => isPaused = false);
                    },
                  ),
                ),
                Spacers.largeHorizontal,
                Expanded(
                  child: CustomButton(
                    title: 'Stop',
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
