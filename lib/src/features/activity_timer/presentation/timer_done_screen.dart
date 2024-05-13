import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:focusnest/src/common_widgets/custom_button.dart';
import 'package:focusnest/src/common_widgets/custom_text.dart';
import 'package:focusnest/src/constants/app_color.dart';
import 'package:focusnest/src/constants/app_padding.dart';
import 'package:focusnest/src/constants/routes_name.dart';
import 'package:focusnest/src/constants/spacers.dart';
import 'package:focusnest/src/utils/date_time_helper.dart';
import 'package:go_router/go_router.dart';

class TimerDoneScreen extends StatefulWidget {
  final Duration duration;

  const TimerDoneScreen({
    required this.duration,
    super.key,
  });

  @override
  State<TimerDoneScreen> createState() => _TimerDoneScreenState();
}

class _TimerDoneScreenState extends State<TimerDoneScreen> {
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
    return Scaffold(
      backgroundColor: AppColor.secondaryColor,
      body: Padding(
        padding: AppPadding.screenPadding,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle_outline,
                size: 60,
                color: AppColor.greenColor,
              ),
              Spacers.mediumVertical,
              const CustomText(
                title: 'Congratulations!',
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
              Spacers.mediumVertical,
              const CustomText(
                title: 'You managed to complete the activity.',
              ),
              Spacers.mediumVertical,
              CustomText(
                title:
                    'Total Time : ${formatSecondsToReadable(widget.duration)}',
                textType: TextType.title,
              ),
              Spacers.largeVertical,
              CustomButton(
                title: 'Done',
                onPressed: () => context.goNamed(RoutesName.activityTimer),
              ),
            ],
          ),
        ),
      ),
    );
  }
}