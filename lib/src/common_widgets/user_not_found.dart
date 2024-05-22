import 'package:flutter/material.dart';
import 'package:focusnest/src/common_widgets/custom_text.dart';
import 'package:focusnest/src/constants/app_padding.dart';

class UserNotFound extends StatelessWidget {
  const UserNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: AppPadding.screenPadding,
      child: Center(
        child: CustomText(
          title: 'You are not logged in. Please login to view this',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
