import 'package:drift/drift.dart' as drift;
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusnest/src/features/activity_calendar/data/activity_calendar_providers.dart';
import 'package:focusnest/src/features/activity_calendar/presentation/activity_timer_form.dart';
import 'package:focusnest/src/features/activity_timer/data/activity_timer_database.dart';
import 'package:focusnest/src/utils/activity_timer_form_mixin.dart';
import 'package:focusnest/src/utils/alert_dialogs.dart';
import 'package:go_router/go_router.dart';

// Update Activity Timer - for user to edit the existing record
class UpdateActivityTimer extends ConsumerStatefulWidget {
  final String userId;
  final String timerId;
  final String label;
  final DateTime startDateTime;
  final Duration duration;

  const UpdateActivityTimer({
    required this.userId,
    required this.timerId,
    required this.label,
    required this.startDateTime,
    required this.duration,
    super.key,
  });

  @override
  ConsumerState<UpdateActivityTimer> createState() =>
      _UpdateActivityTimerState();
}

class _UpdateActivityTimerState extends ConsumerState<UpdateActivityTimer>
    with ActivityTimerFormMixin {
  @override
  void initState() {
    super.initState();
    initActivityTimerForm(widget.label, widget.startDateTime, widget.duration);
  }

  void _handleOnDeleteRecord() async {
    final dao = ActivityTimerDatabase().activityCalendarDao;
    bool? isDeleteConfirm = await showDeleteRecordAlert(context);
    if (isDeleteConfirm == true) {
      await dao.deleteActivityTimerById(widget.timerId, widget.userId);
      if (mounted) context.pop();
    }
  }

  Future<void> _updateActivityTimer() async {
    if (activityLabelController.text.isNotEmpty) {
      final dao = ref.read(activityCalendarDaoProvider);
      final entry = ActivityTimersCompanion(
        activityLabel: drift.Value(activityLabelController.text.trim()),
        startDateTime: drift.Value(selectedStartDateTime),
        endDateTime: drift.Value(endDateTime),
        actualDurationInSeconds: drift.Value(totalDurationInSeconds),
        targetedDurationInSeconds: drift.Value(totalDurationInSeconds),
      );

      await dao.updateActivityTimer(widget.timerId, entry);
      if (mounted) context.pop();
    } else {
      showInvalidLabelAlert(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ActivityTimerForm(
      headerTitle: 'Edit Record',
      activityLabelController: activityLabelController,
      selectedStartDateTime: selectedStartDateTime,
      selectedDuration: selectedDuration,
      onStartDateTimeChanged: handleOnStartDateTimeChanged,
      onStartDateTimeConfirmed: handleOnStartDateTimeConfirmed,
      onDurationChanged: handleOnDurationChanged,
      onDurationConfirmed: handleOnDurationConfirmed,
      onUpdateActivityTimer: _updateActivityTimer,
      onDeleteAction: _handleOnDeleteRecord,
    );
  }
}
