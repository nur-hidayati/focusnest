import 'package:flutter/cupertino.dart';
import 'package:focusnest/src/common_widgets/custom_text.dart';
import 'package:focusnest/src/common_widgets/link_text_button.dart';

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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  LinkTextButton(
                    title: 'Cancel',
                    onPressed: onCancel,
                  ),
                  const CustomText(
                    title: 'Select Duration',
                    fontWeight: FontWeight.bold,
                  ),
                  LinkTextButton(
                    title: 'Done',
                    onPressed: onDone,
                  ),
                ],
              ),
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
