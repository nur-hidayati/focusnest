import 'package:flutter/material.dart';
import 'package:focusnest/src/common_widgets/custom_button.dart';
import 'package:focusnest/src/common_widgets/custom_text.dart';
import 'package:focusnest/src/common_widgets/duration_picker.dart';
import 'package:focusnest/src/constants/app_color.dart';
import 'package:focusnest/src/constants/routes_name.dart';
import 'package:focusnest/src/constants/spacers.dart';
import 'package:focusnest/src/utils/alert_dialogs.dart';
import 'package:focusnest/src/utils/date_time_helper.dart';
import 'package:go_router/go_router.dart';

class ActivityTimerScreen extends StatefulWidget {
  const ActivityTimerScreen({super.key});

  @override
  State<ActivityTimerScreen> createState() => _ActivityTimerScreenState();
}

class _ActivityTimerScreenState extends State<ActivityTimerScreen> {
  Duration _duration = const Duration(minutes: 15);
  Duration? _tempDuration;

  void _handleOnDoneDurationPicker() {
    if (_tempDuration != null) {
      if (_tempDuration!.inMinutes == 0) {
        showOKAlert(
          context: context,
          title: 'Invalid Duration',
          content: 'Duration cannot be zero',
        );
      } else {
        setState(() {
          _duration = _tempDuration!;
          _tempDuration = null;
          context.pop();
        });
      }
    } else {
      context.pop();
    }
  }

  void _handleOnTimerDurationChanged(Duration picked) {
    _tempDuration = picked;
  }

  void _showDurationPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isDismissible: false,
      builder: (BuildContext builder) {
        return DurationPicker(
          duration: _duration,
          onCancel: () => context.pop(),
          onDone: _handleOnDoneDurationPicker,
          onTimerDurationChanged: _handleOnTimerDurationChanged,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Spacers.largeVertical,
                _timerSection(context),
                Spacers.largeVertical,
                _recentsSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _timerSection(BuildContext context) {
    return Column(
      children: [
        const Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: CustomText(
                title: 'Study',
                textType: TextType.titleLarge,
                color: AppColor.primaryColor,
              ),
            ),
            Spacers.extraSmallHorizontal,
            Icon(Icons.navigate_next)
          ],
        ),
        Spacers.smallVertical,
        GestureDetector(
          onTap: () => _showDurationPicker(context),
          child: CustomText(
            title: formatDuration(_duration),
            fontSize: 60,
            fontWeight: FontWeight.bold,
            color: AppColor.greyColor,
          ),
        ),
        Spacers.smallVertical,
        CustomButton(
          title: 'Start Focus',
          onPressed: () => context.pushNamed(
            RoutesName.timerStart,
          ),
        ),
      ],
    );
  }

  Widget _recentsSection() {
    return Column(
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: CustomText(
            title: 'Recents',
            textType: TextType.title,
          ),
        ),
        Spacers.extraSmallVertical,
        const Divider(),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (context, index) => const Divider(),
          itemCount: 10,
          itemBuilder: (context, index) => ListTile(
            contentPadding: EdgeInsets.zero,
            dense: true,
            title: const CustomText(
              title: '1:00:00',
              textType: TextType.title,
            ),
            subtitle: const CustomText(
              title: 'Working on a work',
            ),
            trailing: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.play_circle_outline,
                size: 40,
                color: AppColor.primaryColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
