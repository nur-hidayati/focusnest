import 'package:flutter/material.dart';
import 'package:focusnest/src/common_widgets/cancel_done_header_button.dart';
import 'package:focusnest/src/constants/app_padding.dart';
import 'package:go_router/go_router.dart';

class BottomSheetContents extends StatelessWidget {
  final Widget child;
  final String? headerTitle;
  final VoidCallback? onDoneActivityLabelUpdate;

  const BottomSheetContents({
    required this.child,
    this.headerTitle,
    this.onDoneActivityLabelUpdate,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        child: Column(
          children: [
            CancelDoneHeaderButton(
              padding: AppPadding.horizontalPadding,
              title: headerTitle ?? '',
              onDone: onDoneActivityLabelUpdate,
              onCancel: () => context.pop(),
            ),
            Padding(
              padding: AppPadding.horizontalPadding,
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
