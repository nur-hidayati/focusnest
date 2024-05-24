import 'package:flutter/material.dart';
import 'package:focusnest/src/common_widgets/header_actions_button.dart';
import 'package:focusnest/src/constants/app_padding.dart';
import 'package:focusnest/src/constants/spacers.dart';
import 'package:go_router/go_router.dart';

// Custom bottom sheet widget with a customizable header and content that handle on-screen keyboard adjustments
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
        // Adds padding at the bottom equal to the keyboard height to avoid overlay.
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            HeaderActionButtons(
              padding: AppPadding.horizontalPadding,
              title: headerTitle ?? '',
              onDone: onDoneActivityLabelUpdate,
              onCancel: () => context.pop(),
            ),
            Spacers.smallVertical,
            Padding(
              padding: AppPadding.noTopPadding,
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
