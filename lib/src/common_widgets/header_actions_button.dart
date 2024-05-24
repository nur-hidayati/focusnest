import 'package:flutter/material.dart';
import 'package:focusnest/src/common_widgets/custom_text.dart';
import 'package:focusnest/src/common_widgets/link_text_button.dart';

// Customizable header with 'Cancel' and 'Done' action buttons and a central title.
// Commonly used in bottom sheets that need header with navigation buttons.
class HeaderActionButtons extends StatelessWidget {
  final String title;
  final VoidCallback onCancel;
  final VoidCallback? onDone;
  final EdgeInsetsGeometry? padding;
  final bool hideDoneButton;
  final double horizontalPadding;

  const HeaderActionButtons({
    required this.title,
    required this.onCancel,
    this.onDone,
    this.padding,
    this.hideDoneButton = false,
    this.horizontalPadding = 20,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
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
            title: !hideDoneButton ? 'Done' : '',
            onPressed: onDone,
          ),
        ],
      ),
    );
  }
}
