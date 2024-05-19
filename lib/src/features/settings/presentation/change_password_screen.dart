import 'package:flutter/material.dart';
import 'package:focusnest/src/common_widgets/custom_text.dart';
import 'package:focusnest/src/common_widgets/custom_text_form_field.dart';
import 'package:focusnest/src/common_widgets/link_text_button.dart';
import 'package:focusnest/src/constants/app_padding.dart';
import 'package:focusnest/src/constants/spacers.dart';

class ChangePasswordScreen extends StatefulWidget {
  final String userId;
  const ChangePasswordScreen({
    required this.userId,
    super.key,
  });

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: LinkTextButton(
              title: 'Save',
              onPressed: () {},
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: AppPadding.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomText(
                title: 'Your password must at least be 8 characters.'),
            Spacers.smallVertical,
            CustomTextFormField(
              controller: _currentPasswordController,
              hintText: 'Current Password',
              textInputAction: TextInputAction.done,
              obscureText: true,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              prefixIcon: const Icon(Icons.lock),
            ),
            Spacers.smallVertical,
            CustomTextFormField(
              controller: _newPasswordController,
              hintText: 'New Password',
              textInputAction: TextInputAction.done,
              obscureText: true,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              prefixIcon: const Icon(Icons.lock),
            ),
            Spacers.smallVertical,
            CustomTextFormField(
              controller: _confirmNewPasswordController,
              hintText: 'Confirm New Password',
              textInputAction: TextInputAction.done,
              obscureText: true,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              prefixIcon: const Icon(Icons.lock),
            ),
          ],
        ),
      ),
    );
  }
}
