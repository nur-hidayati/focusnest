import 'package:drift/drift.dart' as drift;
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusnest/src/features/activity_calendar/data/activity_calendar_providers.dart';
import 'package:focusnest/src/features/activity_calendar/presentation/activity_timer_form.dart';
import 'package:focusnest/src/features/activity_timer/data/activity_timer_database.dart';
import 'package:focusnest/src/utils/activity_timer_form_mixin.dart';
import 'package:go_router/go_router.dart';

class AddActivityTimer extends ConsumerStatefulWidget {
  final String userId;
  final DateTime startDateTime;
  final Duration duration;

  const AddActivityTimer({
    required this.userId,
    required this.startDateTime,
    required this.duration,
    super.key,
  });

  @override
  ConsumerState<AddActivityTimer> createState() => _UpdateActivityTimerState();
}

class _UpdateActivityTimerState extends ConsumerState<AddActivityTimer>
    with ActivityTimerFormMixin {
  @override
  void initState() {
    super.initState();
    initActivityTimerForm('', widget.startDateTime, widget.duration);
  }

  Future<void> _addActivityTimer() async {
    final dao = ref.read(activityCalendarDaoProvider);

    final entry = ActivityTimersCompanion(
      userId: drift.Value(widget.userId),
      activityLabel: drift.Value(activityLabelController.text),
      startDateTime: drift.Value(selectedStartDateTime),
      endDateTime: drift.Value(endDateTime),
      actualDurationInSeconds: drift.Value(totalDurationInSeconds),
      targetedDurationInSeconds: drift.Value(totalDurationInSeconds),
      createdDate: drift.Value(DateTime.now()),
    );

    await dao.insertActivityTimer(entry);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return ActivityTimerForm(
      headerTitle: 'Add New Record',
      activityLabelController: activityLabelController,
      selectedStartDateTime: selectedStartDateTime,
      selectedDuration: selectedDuration,
      onStartDateTimeChanged: handleOnStartDateTimeChanged,
      onStartDateTimeConfirmed: handleOnStartDateTimeConfirmed,
      onDurationChanged: handleOnDurationChanged,
      onDurationConfirmed: handleOnDurationConfirmed,
      onUpdateActivityTimer: _addActivityTimer,
    );
  }
}
