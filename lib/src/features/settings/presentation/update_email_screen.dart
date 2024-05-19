import 'package:flutter/material.dart';
import 'package:focusnest/src/common_widgets/cancel_done_header_button.dart';
import 'package:focusnest/src/common_widgets/custom_text.dart';
import 'package:focusnest/src/common_widgets/custom_text_form_field.dart';
import 'package:focusnest/src/constants/app_padding.dart';
import 'package:focusnest/src/constants/spacers.dart';
import 'package:go_router/go_router.dart';

class UpdateEmailScreen extends StatefulWidget {
  final String userId;
  final String userEmail;

  const UpdateEmailScreen({
    required this.userId,
    required this.userEmail,
    super.key,
  });

  @override
  State<UpdateEmailScreen> createState() => _UpdateEmailScreenState();
}

class _UpdateEmailScreenState extends State<UpdateEmailScreen> {
  final _newEmailController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: AppPadding.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CancelDoneHeaderButton(
              padding: const EdgeInsets.only(top: 10),
              title: 'Update Email',
              doneTitle: 'Next',
              onCancel: () => context.pop(),
              onDone: () {},
            ),
            Spacers.extraSmallVertical,
            CustomText(
              title:
                  'The email currently associated with this account is ${widget.userEmail}. Please provide a new email address if you wish to update the existing one.',
              overflow: TextOverflow.visible,
              textType: TextType.subtitle,
            ),
            Spacers.mediumVertical,
            CustomTextFormField(
              label: 'New Email Address',
              controller: _newEmailController,
              hintText: 'Enter your new email..',
            ),
            Spacers.mediumVertical,
            CustomTextFormField(
              label: 'Current Password',
              controller: _currentPasswordController,
              hintText: 'Enter your current password..',
            ),
          ],
        ),
      ),
    );
  }
}
