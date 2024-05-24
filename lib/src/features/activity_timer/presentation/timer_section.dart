import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusnest/src/common_widgets/custom_button.dart';
import 'package:focusnest/src/common_widgets/custom_text.dart';
import 'package:focusnest/src/constants/app_color.dart';
import 'package:focusnest/src/constants/spacers.dart';
import 'package:focusnest/src/features/activity_timer/data/activity_timer_providers.dart';
import 'package:focusnest/src/features/activity_timer/presentation/activity_label_form.dart';
import 'package:focusnest/src/features/authentication/data/auth_repository.dart';
import 'package:focusnest/src/utils/alert_dialogs.dart';
import 'package:focusnest/src/utils/date_time_helper.dart';
import 'package:focusnest/src/utils/modal_helper.dart';
import 'package:focusnest/src/utils/navigation_helper.dart';
import 'package:go_router/go_router.dart';

// The Activity Timer section that display Activity label and Duration
class TimerSection extends ConsumerWidget {
  const TimerSection({super.key});

  void _handleOnTimerDurationChanged(WidgetRef ref, Duration picked) {
    ref.read(tempDurationProvider.notifier).state = picked;
  }

  void _handleOnDoneDurationPicker(
      BuildContext context, WidgetRef ref, String userId) {
    final pickedDuration = ref.read(tempDurationProvider);
    if (pickedDuration != null) {
      if (pickedDuration.inMinutes == 0) {
        showInvalidDurationAlert(context);
      } else {
        ref
            .read(timerDurationProvider(userId).notifier)
            .updateTimerDuration(pickedDuration);
        context.pop();
      }
    } else {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authRepository = ref.watch(authRepositoryProvider);
    final userId = authRepository.currentUser?.uid;

    if (userId == null) {
      return Container();
    }

    final activityLabel = ref.watch(activityLabelProvider(userId));
    final timerDuration = ref.watch(timerDurationProvider(userId));

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: GestureDetector(
                onTap: () => showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  useRootNavigator: true,
                  builder: (BuildContext context) {
                    return const ActivityLabelForm();
                  },
                ),
                child: CustomText(
                  title: activityLabel,
                  textType: TextType.titleLarge,
                  color: AppColor.primaryColor,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Spacers.extraSmallHorizontal,
            const Icon(Icons.navigate_next),
          ],
        ),
        Spacers.smallVertical,
        GestureDetector(
          onTap: () => durationPickerModal(
            context: context,
            currentDuration: timerDuration,
            onTimerDurationChanged: (Duration picked) =>
                _handleOnTimerDurationChanged(ref, picked),
            onCancel: () => context.pop(),
            onDone: () => _handleOnDoneDurationPicker(context, ref, userId),
          ),
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
          onPressed: () => navigateToTimerStart(
            context: context,
            userId: userId,
            activityLabel: activityLabel,
            timerDuration: timerDuration,
          ),
        ),
      ],
    );
  }
}
