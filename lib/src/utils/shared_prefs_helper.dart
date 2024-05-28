import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusnest/src/features/activity_timer/data/activity_timer_providers.dart';

Future<void> reloadAllNotifiers(WidgetRef ref, String userId) async {
  final activityLabelNotifier =
      ref.read(activityLabelProvider(userId).notifier);
  final timerDurationNotifier =
      ref.read(timerDurationProvider(userId).notifier);
  final recentActivitiesNotifier =
      ref.read(recentActivitiesProvider(userId).notifier);

  await activityLabelNotifier.reload();
  await timerDurationNotifier.reload();
  await recentActivitiesNotifier.reload();
}
