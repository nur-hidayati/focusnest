import 'package:flutter/material.dart';

// Customizable text button that acts like a hyperlink style
class LinkTextButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String title;
  final bool shrinkWrapTapTargetSize;
  final Color? color;
  final double fontSize;

  const LinkTextButton({
    required this.title,
    this.onPressed,
    this.shrinkWrapTapTargetSize = false,
    this.color,
    this.fontSize = 18.0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize:
            !shrinkWrapTapTargetSize ? null : MaterialTapTargetSize.shrinkWrap,
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: fontSize,
          color: color,
        ),
      ),
    );
  }
}
