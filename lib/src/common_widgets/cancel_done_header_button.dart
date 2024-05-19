import 'package:flutter/material.dart';
import 'package:focusnest/src/common_widgets/custom_text.dart';
import 'package:focusnest/src/common_widgets/link_text_button.dart';

class CancelDoneHeaderButton extends StatelessWidget {
  final String title;
  final VoidCallback onCancel;
  final VoidCallback? onDone;
  final EdgeInsetsGeometry? padding;
  final String? doneTitle;

  const CancelDoneHeaderButton({
    required this.title,
    required this.onCancel,
    this.onDone,
    this.padding,
    this.doneTitle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          LinkTextButton(
            title: 'Cancel',
            onPressed: onCancel,
          ),
          Expanded(
            child: Center(
              child: CustomText(
                title: title,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          LinkTextButton(
            title: doneTitle != null ? 'Done' : '',
            onPressed: onDone,
          ),
        ],
      ),
    );
  }
}
