import 'package:flutter/material.dart';
import 'package:focusnest/src/common_widgets/custom_text.dart';
import 'package:focusnest/src/common_widgets/link_text_button.dart';
import 'package:focusnest/src/constants/app_color.dart';

// Card that displays a label and a selectable input with a hint or value in it.
class SelectionInputCard extends StatelessWidget {
  final String label;
  final String? value;
  final String hintText;
  final VoidCallback onPressed;

  const SelectionInputCard({
    required this.label,
    required this.hintText,
    required this.onPressed,
    this.value,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColor.inputColor,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            Expanded(
              child: CustomText(title: label),
            ),
            const Spacer(),
            LinkTextButton(
              title: value ?? hintText,
              shrinkWrapTapTargetSize: true,
              onPressed: onPressed,
            ),
          ],
        ),
      ),
    );
  }
}
