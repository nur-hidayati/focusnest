import 'package:flutter/material.dart';
import 'package:focusnest/src/common_widgets/custom_text.dart';
import 'package:focusnest/src/constants/app_color.dart';
import 'package:focusnest/src/constants/app_padding.dart';
import 'package:focusnest/src/constants/spacers.dart';
import 'package:focusnest/src/features/activity_timer/presentation/timer_section.dart';

class ActivityTimerScreen extends StatefulWidget {
  const ActivityTimerScreen({super.key});

  @override
  State<ActivityTimerScreen> createState() => _ActivityTimerScreenState();
}

class _ActivityTimerScreenState extends State<ActivityTimerScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: AppPadding.noBottomPadding,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Spacers.largeVertical,
                const TimerSection(),
                Spacers.largeVertical,
                _recentsSection(),
              ],
            ),
          ),
        ),
      ),
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
