import 'package:flutter/material.dart';

class LinkTextButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String title;

  const LinkTextButton({
    required this.title,
    this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16.0),
      ),
    );
  }
}
