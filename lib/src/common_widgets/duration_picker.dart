import 'package:flutter/cupertino.dart';
import 'package:focusnest/src/common_widgets/bottom_sheet_header.dart';
import 'package:focusnest/src/constants/app_padding.dart';

class DurationPicker extends StatelessWidget {
  final Duration duration;
  final VoidCallback onCancel;
  final VoidCallback onDone;
  final Function(Duration) onTimerDurationChanged;

  const DurationPicker({
    required this.duration,
    required this.onCancel,
    required this.onDone,
    required this.onTimerDurationChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: SafeArea(
        child: Column(
          children: [
            BottomSheetHeader(
              title: 'Select Duration',
              onDone: onDone,
              onCancel: onCancel,
              headerPadding: AppPadding.horizontalPadding,
            ),
            Expanded(
              child: CupertinoTimerPicker(
                mode: CupertinoTimerPickerMode.hm,
                initialTimerDuration: duration,
                onTimerDurationChanged: onTimerDurationChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
