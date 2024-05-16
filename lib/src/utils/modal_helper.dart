import 'package:flutter/cupertino.dart';
import 'package:focusnest/src/common_widgets/bottom_sheet_header.dart';

Future<void> datePickerModal({
  required BuildContext context,
  required void Function(DateTime) onDateTimeChanged,
  DateTime? initialDateTime,
  DateTime? minimumDate,
  DateTime? maximumDate,
  CupertinoDatePickerMode mode = CupertinoDatePickerMode.date,
  DateSelectionMode dateSelectionMode = DateSelectionMode.both,
  required VoidCallback onDone,
  required VoidCallback onCancel,
}) {
  final DateTime now = DateTime.now();
  final DateTime todayMidnight = DateTime(now.year, now.month, now.day);
  final DateTime endOfToday = DateTime(now.year, now.month, now.day, 23, 59);
  final DateTime effectiveInitialDateTime = initialDateTime ?? now;

  if (dateSelectionMode == DateSelectionMode.past) {
    maximumDate = endOfToday;
  } else if (dateSelectionMode == DateSelectionMode.future) {
    minimumDate ??= todayMidnight;
  }

  return cupertinoPickerModal(
    context: context,
    onDone: onDone,
    onCancel: onCancel,
    child: CupertinoDatePicker(
      dateOrder: DatePickerDateOrder.dmy,
      mode: mode,
      onDateTimeChanged: onDateTimeChanged,
      initialDateTime: effectiveInitialDateTime,
      minimumDate: minimumDate,
      maximumDate: maximumDate,
    ),
  );
}

Future<void> durationPickerModal({
  required BuildContext context,
  required Duration currentDuration,
  required Function(Duration) onTimerDurationChanged,
  required VoidCallback onCancel,
  required VoidCallback onDone,
}) {
  return cupertinoPickerModal(
    context: context,
    child: CupertinoTimerPicker(
      mode: CupertinoTimerPickerMode.hm,
      initialTimerDuration: currentDuration,
      onTimerDurationChanged: onTimerDurationChanged,
    ),
    onDone: onDone,
    onCancel: onCancel,
  );
}

Future<void> cupertinoPickerModal({
  required BuildContext context,
  required Widget child,
  required VoidCallback onDone,
  required VoidCallback onCancel,
  bool isDismissed = true,
  bool isTime = false,
}) {
  return showCupertinoModalPopup<void>(
    barrierDismissible: isDismissed,
    context: context,
    builder: (BuildContext context) => Container(
      height: 216,
      padding: const EdgeInsets.only(top: 6.0),
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      color: CupertinoColors.systemBackground.resolveFrom(context),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            BottomSheetHeader(
              title: 'Select Duration',
              onDone: onDone,
              onCancel: onCancel,
            ),
            Expanded(child: child),
          ],
        ),
      ),
    ),
  );
}

enum DateSelectionMode {
  past,
  future,
  both,
}
