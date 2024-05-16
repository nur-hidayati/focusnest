import 'package:flutter/cupertino.dart';
import 'package:focusnest/src/common_widgets/custom_text.dart';
import 'package:focusnest/src/common_widgets/link_text_button.dart';
import 'package:focusnest/src/constants/app_padding.dart';

class BottomSheetHeader extends StatelessWidget {
  final String title;
  final VoidCallback onCancel;
  final VoidCallback? onDone;

  const BottomSheetHeader({
    required this.title,
    this.onDone,
    required this.onCancel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPadding.horizontalPadding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          LinkTextButton(
            title: 'Cancel',
            onPressed: onCancel,
          ),
          CustomText(
            title: title,
            fontWeight: FontWeight.bold,
          ),
          LinkTextButton(
            title: 'Done',
            onPressed: onDone,
          ),
        ],
      ),
    );
  }
}
