import 'package:flutter/material.dart';
import 'package:focusnest/src/common_widgets/custom_text.dart';
import 'package:focusnest/src/constants/app_color.dart';
import 'package:focusnest/src/constants/app_padding.dart';
import 'package:focusnest/src/constants/spacers.dart';

class EmailSentScreen extends StatelessWidget {
  final String userEmail;

  const EmailSentScreen({
    required this.userEmail,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final iconSize = screenWidth * 0.3;

    return Scaffold(
      appBar: AppBar(
        shape: const LinearBorder(),
        title: const Text('Check Your Inbox'),
      ),
      body: Padding(
        padding: AppPadding.noTopPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacers.extraSmallVertical,
            Icon(
              Icons.mark_email_read_outlined,
              size: iconSize,
              color: AppColor.primaryColor,
            ),
            Spacers.smallVertical,
            CustomText(
              title: 'A link to reset your password was sent to $userEmail',
              overflow: TextOverflow.visible,
              textAlign: TextAlign.center,
            ),
            Spacers.mediumVertical,
          ],
        ),
      ),
    );
  }
}
