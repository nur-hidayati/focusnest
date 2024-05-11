import 'package:flutter/material.dart';
import 'package:focusnest/src/common_widgets/custom_text.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.title,
    this.isFullWidth = true,
    this.onPressed,
  });

  final String title;
  final bool isFullWidth;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        minimumSize: isFullWidth ? const Size.fromHeight(40) : null,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      child: CustomText(
        title: title,
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 18.0,
      ),
    );
  }
}
