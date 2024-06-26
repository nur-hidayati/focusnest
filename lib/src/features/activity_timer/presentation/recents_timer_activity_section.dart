import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:focusnest/src/common_widgets/custom_text.dart';
import 'package:focusnest/src/constants/app_color.dart';
import 'package:focusnest/src/constants/spacers.dart';
import 'package:focusnest/src/features/activity_timer/data/activity_timer_providers.dart';
import 'package:focusnest/src/utils/date_time_helper.dart';
import 'package:focusnest/src/utils/navigation_helper.dart';

// The Activity Timer section that display Recents Timer
class RecentsTimerActivitySection extends ConsumerWidget {
  final String userId;

  const RecentsTimerActivitySection({
    required this.userId,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentActivities = ref.watch(recentActivitiesProvider(userId));
    final recentActivitiesNotifier =
        ref.read(recentActivitiesProvider(userId).notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: CustomText(
            title: 'Recents',
            textType: TextType.title,
          ),
        ),
        Spacers.smallVertical,
        if (recentActivities.isEmpty) ...[
          const Padding(
            padding: EdgeInsets.only(top: 10),
            child: CustomText(title: 'No recent timer.'),
          )
        ] else ...[
          ...recentActivities.map((activityTimer) {
            return Column(
              children: [
                const Divider(height: 1),
                Slidable(
                  key: ValueKey(activityTimer.id),
                  closeOnScroll: true,
                  endActionPane: ActionPane(
                    dismissible: DismissiblePane(onDismissed: () {
                      recentActivitiesNotifier.removeActivity(activityTimer);
                    }),
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) {
                          recentActivitiesNotifier
                              .removeActivity(activityTimer);
                        },
                        icon: Icons.delete,
                        backgroundColor: Colors.red,
                        label: 'Delete',
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    title: CustomText(
                      title: formatDurationToHms(Duration(
                          seconds: activityTimer.targetedDurationInSeconds)),
                      textType: TextType.title,
                    ),
                    subtitle: CustomText(
                      title: activityTimer.activityLabel,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        navigateToTimerStart(
                          context: context,
                          userId: userId,
                          timerDuration: Duration(
                              seconds: activityTimer.targetedDurationInSeconds),
                          activityLabel: activityTimer.activityLabel,
                        );
                      },
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
          }),
          const Divider(height: 1),
        ],
      ],
    );
  }
}
