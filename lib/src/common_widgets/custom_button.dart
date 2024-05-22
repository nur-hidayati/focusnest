import 'package:flutter/material.dart';
import 'package:focusnest/src/common_widgets/custom_text.dart';

// Customizable button with an option for full-width display.
class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.title,
    this.isFullWidth = false,
    this.onPressed,
    this.buttonColor,
  });

  final String title;
  final bool isFullWidth;
  final VoidCallback? onPressed;
  final Color? buttonColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        minimumSize: isFullWidth ? const Size.fromHeight(40) : null,
        backgroundColor: buttonColor ?? Theme.of(context).colorScheme.primary,
      ),
      child: CustomText(
        title: title,
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 16.0,
      ),
    );
  }
}
