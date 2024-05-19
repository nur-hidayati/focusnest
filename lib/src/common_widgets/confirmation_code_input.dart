import 'package:flutter/material.dart';
import 'package:focusnest/src/common_widgets/custom_button.dart';
import 'package:focusnest/src/common_widgets/custom_text.dart';
import 'package:focusnest/src/common_widgets/custom_text_form_field.dart';
import 'package:focusnest/src/constants/app_padding.dart';
import 'package:focusnest/src/constants/spacers.dart';

class ConfirmationCodeInput extends StatelessWidget {
  final TextEditingController codeController;
  final String email;
  final VoidCallback onVerifyAction;

  const ConfirmationCodeInput({
    required this.codeController,
    required this.email,
    required this.onVerifyAction,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const LinearBorder(),
      ),
      body: Padding(
        padding: AppPadding.horizontalPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomText(
              title: 'We sent you a code',
              overflow: TextOverflow.visible,
              textType: TextType.title,
            ),
            Spacers.smallVertical,
            CustomText(
              title: 'Enter the confirmation code that we sent to $email',
              overflow: TextOverflow.visible,
            ),
            Spacers.smallVertical,
            CustomTextFormField(
              controller: codeController,
              hintText: 'Confirmation Code',
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            Spacers.largeVertical,
            CustomButton(
              title: 'Submit',
              onPressed: onVerifyAction,
              isFullWidth: true,
            ),
          ],
        ),
      ),
    );
  }
}
