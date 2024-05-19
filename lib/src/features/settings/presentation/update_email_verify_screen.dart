import 'package:flutter/material.dart';
import 'package:focusnest/src/common_widgets/confirmation_code_input.dart';

class UpdateEmailVerifyScreen extends StatefulWidget {
  final String userId;
  final String userEmail;

  const UpdateEmailVerifyScreen({
    required this.userId,
    required this.userEmail,
    super.key,
  });

  @override
  State<UpdateEmailVerifyScreen> createState() =>
      _UpdateEmailVerifyScreenState();
}

class _UpdateEmailVerifyScreenState extends State<UpdateEmailVerifyScreen> {
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConfirmationCodeInput(
      codeController: _codeController,
      email: widget.userEmail,
      onVerifyAction: () {},
    );
  }
}
