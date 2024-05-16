import 'package:drift/drift.dart' as drift;
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusnest/src/common_widgets/bottom_sheet_contents.dart';
import 'package:focusnest/src/common_widgets/custom_text_form_field.dart';
import 'package:focusnest/src/common_widgets/link_text_button.dart';
import 'package:focusnest/src/common_widgets/selection_input_card.dart';
import 'package:focusnest/src/constants/app_color.dart';
import 'package:focusnest/src/constants/spacers.dart';
import 'package:focusnest/src/features/activity_calendar/data/activity_calendar_providers.dart';
import 'package:focusnest/src/features/activity_timer/data/activity_timer_database.dart';
import 'package:focusnest/src/utils/date_time_helper.dart';
import 'package:focusnest/src/utils/modal_helper.dart';
import 'package:go_router/go_router.dart';

class UpdateActivityTimer extends ConsumerStatefulWidget {
  final String timerId;
  final String label;
  final DateTime startDateTime;
  final Duration duration;

  const UpdateActivityTimer({
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

class _UpdateActivityTimerState extends ConsumerState<UpdateActivityTimer> {
  late TextEditingController activityLabelController;
  DateTime _selectedStartDateTime = DateTime.now();
  DateTime? _tempSelectedStartDateTime;
  Duration _selectedDuration = const Duration(seconds: 60);
  Duration? _tempSelectedDuration;

  @override
  void initState() {
    super.initState();
    activityLabelController = TextEditingController(text: widget.label);
    _selectedStartDateTime = widget.startDateTime;
    _selectedDuration = widget.duration;
  }

  void _handleStartDateTimeOnChanged(DateTime newDate) {
    _tempSelectedStartDateTime = newDate;
  }

  void _handleStartDateTimeOnConfirmed() {
    if (_tempSelectedStartDateTime != null) {
      setState(() {
        _selectedStartDateTime = _tempSelectedStartDateTime!;
      });
      context.pop();
    }
  }

  void _handleDurationOnChanged(Duration newDuration) {
    _tempSelectedDuration = newDuration;
  }

  void _handleDurationOnConfirmed() {
    if (_tempSelectedDuration != null) {
      setState(() {
        _selectedDuration = _tempSelectedDuration!;
      });
      context.pop();
    }
  }

  Future<void> _updateActivityTimer() async {
    final totalDuration = _selectedDuration.inSeconds;

    final dao = ref.read(activityCalendarDaoProvider);

    final entry = ActivityTimersCompanion(
      activityLabel: drift.Value(activityLabelController.text.trim()),
      startDateTime: drift.Value(_selectedStartDateTime),
      endDateTime: drift.Value(_selectedStartDateTime.add(_selectedDuration)),
      actualDurationInSeconds: drift.Value(totalDuration),
      targetedDurationInSeconds: drift.Value(totalDuration),
    );

    await dao.updateActivityTimer(widget.timerId, entry);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetContents(
      headerTitle: 'Edit Record',
      onDoneActivityLabelUpdate: _updateActivityTimer,
      child: Column(
        children: [
          CustomTextFormField(
            controller: activityLabelController,
            hintText: 'Activity Label',
          ),
          Spacers.smallVertical,
          SelectionInputCard(
            label: 'Start from',
            value: formatDateTime(_selectedStartDateTime),
            hintText: 'Please select',
            onPressed: () {
              datePickerModal(
                context: context,
                onDateTimeChanged: _handleStartDateTimeOnChanged,
                mode: CupertinoDatePickerMode.dateAndTime,
                dateSelectionMode: DateSelectionMode.past,
                onCancel: () => context.pop(),
                initialDateTime: _selectedStartDateTime,
                onDone: _handleStartDateTimeOnConfirmed,
              );
            },
          ),
          Spacers.smallVertical,
          SelectionInputCard(
            label: 'Duration',
            hintText: 'Please select',
            value: formatDurationsToReadable(_selectedDuration),
            onPressed: () {
              durationPickerModal(
                context: context,
                currentDuration: _selectedDuration,
                onTimerDurationChanged: _handleDurationOnChanged,
                onCancel: () => context.pop(),
                onDone: _handleDurationOnConfirmed,
              );
            },
          ),
          Spacers.smallVertical,
          LinkTextButton(
            title: 'Delete',
            color: AppColor.warningColor,
            onPressed: () {},
          ),
          Spacers.largeVertical,
        ],
      ),
    );
  }
}
