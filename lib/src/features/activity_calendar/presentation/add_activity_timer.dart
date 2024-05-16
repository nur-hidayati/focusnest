import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusnest/src/features/activity_calendar/presentation/activity_timer_form.dart';
import 'package:focusnest/src/utils/activity_timer_form_mixin.dart';

class AddActivityTimer extends ConsumerStatefulWidget {
  final DateTime startDateTime;
  final Duration duration;

  const AddActivityTimer({
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

  Future<void> _updateActivityTimer() async {}

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
      onUpdateActivityTimer: _updateActivityTimer,
    );
  }
}
