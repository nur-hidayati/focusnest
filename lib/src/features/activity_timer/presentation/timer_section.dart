import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusnest/src/common_widgets/custom_button.dart';
import 'package:focusnest/src/common_widgets/custom_text.dart';
import 'package:focusnest/src/common_widgets/duration_picker.dart';
import 'package:focusnest/src/constants/app_color.dart';
import 'package:focusnest/src/constants/routes_name.dart';
import 'package:focusnest/src/constants/spacers.dart';
import 'package:focusnest/src/features/activity_timer/data/activity_timer_providers.dart';
import 'package:focusnest/src/features/activity_timer/presentation/activity_label_form.dart';
import 'package:focusnest/src/utils/alert_dialogs.dart';
import 'package:focusnest/src/utils/date_time_helper.dart';
import 'package:go_router/go_router.dart';

class TimerSection extends ConsumerWidget {
  const TimerSection({super.key});

  void _handleOnTimerDurationChanged(WidgetRef ref, Duration picked) {
    ref.read(tempDurationProvider.notifier).state = picked;
  }

  void _handleOnDoneDurationPicker(BuildContext context, WidgetRef ref) {
    final pickedDuration = ref.read(tempDurationProvider);
    if (pickedDuration != null) {
      if (pickedDuration.inMinutes == 0) {
        showOKAlert(
          context: context,
          title: 'Invalid Duration',
          content: 'Duration cannot be zero',
        );
      } else {
        ref
            .read(timerDurationProvider.notifier)
            .updateTimerDuration(pickedDuration);
        context.pop();
      }
    } else {
      context.pop();
    }
  }

  void _showDurationPicker(
      BuildContext context, WidgetRef ref, Duration currentDuration) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      builder: (BuildContext builder) {
        return DurationPicker(
          duration: currentDuration,
          onCancel: () => context.pop(),
          onDone: () => _handleOnDoneDurationPicker(context, ref),
          onTimerDurationChanged: (Duration picked) =>
              _handleOnTimerDurationChanged(ref, picked),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activityLabel = ref.watch(activityLabelProvider);
    final timerDuration = ref.watch(timerDurationProvider);

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: GestureDetector(
                onTap: () => showModalBottomSheet(
                  context: context,
                  useRootNavigator: true,
                  isDismissible: false,
                  builder: (BuildContext context) {
                    return const ActivityLabelForm();
                  },
                ),
                child: CustomText(
                  title: activityLabel,
                  textType: TextType.titleLarge,
                  color: AppColor.primaryColor,
                ),
              ),
            ),
            Spacers.extraSmallHorizontal,
            const Icon(Icons.navigate_next),
          ],
        ),
        Spacers.smallVertical,
        GestureDetector(
          onTap: () => _showDurationPicker(context, ref, timerDuration),
          child: CustomText(
            title: formatDurationToHms(timerDuration),
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
            queryParameters: {
              'duration': timerDuration.inSeconds.toString(),
              'label': activityLabel,
            },
          ),
        ),
      ],
    );
  }
}
