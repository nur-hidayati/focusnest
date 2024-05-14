import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusnest/src/common_widgets/custom_text.dart';
import 'package:focusnest/src/constants/app_color.dart';
import 'package:focusnest/src/constants/spacers.dart';
import 'package:focusnest/src/features/activity_timer/data/activity_timer_providers.dart';
import 'package:focusnest/src/utils/date_time_helper.dart';

class RecentsTimerActivitySection extends ConsumerWidget {
  const RecentsTimerActivitySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activityTimersAsyncValue = ref.watch(last10ActivityTimersProvider);
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
        activityTimersAsyncValue.when(
          data: (activityTimers) {
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (context, index) => const Divider(),
              itemCount: activityTimers.length,
              itemBuilder: (context, index) {
                final activityTimer = activityTimers[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  title: CustomText(
                    title: formatDurationToHms(Duration(
                        seconds: activityTimer.targetedDurationInSeconds)),
                    textType: TextType.title,
                  ),
                  subtitle: CustomText(
                    title: activityTimer.activityLabel,
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      // Handle button press
                    },
                    icon: const Icon(
                      Icons.play_circle_outline,
                      size: 40,
                      color: AppColor.primaryColor,
                    ),
                  ),
                );
              },
            );
          },
          loading: () => const CircularProgressIndicator(),
          error: (error, stackTrace) => Text('Error: $error'),
        ),
      ],
    );
  }
}
