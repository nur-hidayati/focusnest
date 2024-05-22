import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:focusnest/src/common_widgets/cancel_done_header_button.dart';
import 'package:focusnest/src/constants/app_padding.dart';

Future<void> datePickerModal({
  required BuildContext context,
  required void Function(DateTime) onDateTimeChanged,
  required VoidCallback onDone,
  required VoidCallback onCancel,
  DateTime? initialDateTime,
  DateTime? minimumDate,
  DateTime? maximumDate,
  CupertinoDatePickerMode mode = CupertinoDatePickerMode.date,
  DateSelectionMode dateSelectionMode = DateSelectionMode.both,
}) {
  final DateTime now = DateTime.now();
  final DateTime todayMidnight = DateTime(now.year, now.month, now.day);
  final DateTime endOfToday = DateTime(now.year, now.month, now.day, 23, 59);
  final DateTime effectiveInitialDateTime = initialDateTime ?? now;
  DateTime? tempDateTime;

  if (dateSelectionMode == DateSelectionMode.past) {
    maximumDate = endOfToday;
  } else if (dateSelectionMode == DateSelectionMode.future) {
    minimumDate ??= todayMidnight;
  }

  return cupertinoPickerModal(
    context: context,
    onDone: () {
      if (tempDateTime != null) {
        onDateTimeChanged(tempDateTime!);
      }
      onDone();
    },
    onCancel: onCancel,
    child: CupertinoDatePicker(
      dateOrder: DatePickerDateOrder.dmy,
      mode: mode,
      onDateTimeChanged: (DateTime date) {
        tempDateTime = date;
      },
      initialDateTime: effectiveInitialDateTime,
      minimumDate: minimumDate,
      maximumDate: maximumDate,
    ),
    title: 'Select Start Time',
  );
}

Future<void> durationPickerModal({
  required BuildContext context,
  required Duration currentDuration,
  required Function(Duration) onTimerDurationChanged,
  required VoidCallback onCancel,
  required VoidCallback onDone,
}) {
  Duration? tempDuration;
  return cupertinoPickerModal(
    context: context,
    child: CupertinoTimerPicker(
      mode: CupertinoTimerPickerMode.hm,
      initialTimerDuration: currentDuration,
      onTimerDurationChanged: (Duration duration) {
        tempDuration = duration;
      },
    ),
    onDone: () {
      if (tempDuration != null) {
        onTimerDurationChanged(tempDuration!);
      }
      onDone();
    },
    onCancel: onCancel,
    title: 'Select Duration,',
  );
}

Future<void> cupertinoPickerModal({
  required BuildContext context,
  required Widget child,
  required VoidCallback onDone,
  required VoidCallback onCancel,
  bool isDismissed = true,
  bool isTime = false,
  required String title,
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
            CancelDoneHeaderButton(
              padding: AppPadding.horizontalPadding,
              title: title,
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

void showCustomSnackBar(BuildContext context, String message,
    {int durationInSeconds = 2}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: Duration(seconds: durationInSeconds),
    ),
  );
}

enum DateSelectionMode {
  past,
  future,
  both,
}
