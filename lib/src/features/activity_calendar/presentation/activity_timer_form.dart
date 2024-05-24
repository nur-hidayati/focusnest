import 'package:flutter/cupertino.dart';
import 'package:focusnest/src/common_widgets/bottom_sheet_contents.dart';
import 'package:focusnest/src/common_widgets/custom_text_form_field.dart';
import 'package:focusnest/src/common_widgets/link_text_button.dart';
import 'package:focusnest/src/common_widgets/selection_input_card.dart';
import 'package:focusnest/src/constants/app_color.dart';
import 'package:focusnest/src/constants/spacers.dart';
import 'package:focusnest/src/utils/date_time_helper.dart';
import 'package:focusnest/src/utils/modal_helper.dart';
import 'package:go_router/go_router.dart';

// Bottom sheet that displayed Activity Timer form ( activity label, start date/time and duration)
// Used when user want to edit or add new record in the Calendar screen
class ActivityTimerForm extends StatelessWidget {
  final String headerTitle;
  final TextEditingController activityLabelController;
  final DateTime selectedStartDateTime;
  final Duration selectedDuration;
  final VoidCallback? onDeleteAction;
  final Function(DateTime) onStartDateTimeChanged;
  final VoidCallback onStartDateTimeConfirmed;
  final Function(Duration) onDurationChanged;
  final VoidCallback onDurationConfirmed;
  final VoidCallback onUpdateActivityTimer;

  const ActivityTimerForm({
    required this.headerTitle,
    required this.activityLabelController,
    required this.selectedStartDateTime,
    required this.selectedDuration,
    this.onDeleteAction,
    required this.onStartDateTimeChanged,
    required this.onStartDateTimeConfirmed,
    required this.onDurationChanged,
    required this.onDurationConfirmed,
    required this.onUpdateActivityTimer,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BottomSheetContents(
      headerTitle: headerTitle,
      onDoneActivityLabelUpdate: onUpdateActivityTimer,
      child: Column(
        children: [
          CustomTextFormField(
            controller: activityLabelController,
            hintText: 'Activity Label',
            isActivityLabel: true,
            textCapitalization: TextCapitalization.sentences,
          ),
          Spacers.smallVertical,
          SelectionInputCard(
            label: 'Start',
            value: formatDateTime(selectedStartDateTime),
            hintText: 'Please select',
            onPressed: () {
              datePickerModal(
                context: context,
                onDateTimeChanged: onStartDateTimeChanged,
                mode: CupertinoDatePickerMode.dateAndTime,
                dateSelectionMode: DateSelectionMode.past,
                onCancel: () => context.pop(),
                initialDateTime: selectedStartDateTime,
                onDone: onStartDateTimeConfirmed,
              );
            },
          ),
          Spacers.smallVertical,
          SelectionInputCard(
            label: 'Duration',
            hintText: 'Please select',
            value: formatDurationsToReadable(selectedDuration),
            onPressed: () {
              durationPickerModal(
                context: context,
                currentDuration: selectedDuration,
                onTimerDurationChanged: onDurationChanged,
                onCancel: () => context.pop(),
                onDone: onDurationConfirmed,
              );
            },
          ),
          if (onDeleteAction != null) ...[
            Spacers.mediumVertical,
            LinkTextButton(
              title: 'Delete',
              color: AppColor.warningColor,
              onPressed: onDeleteAction,
            ),
          ],
          Spacers.largeVertical,
        ],
      ),
    );
  }
}
