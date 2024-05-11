import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String title;
  final TextAlign textAlign;
  final TextOverflow overflow;
  final bool softWrap;
  final TextType textType;
  final double fontSize;
  final Color color;
  final FontWeight fontWeight;

  const CustomText({
    required this.title,
    this.textAlign = TextAlign.left,
    this.overflow = TextOverflow.ellipsis,
    this.softWrap = true,
    this.textType = TextType.body,
    this.fontSize = 16.0,
    this.color = Colors.black,
    this.fontWeight = FontWeight.normal,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle style;
    switch (textType) {
      case TextType.titleLarge:
        style = Theme.of(context).textTheme.displayLarge?.copyWith(
                fontSize: 24.0, fontWeight: FontWeight.bold, color: color) ??
            TextStyle(
                fontSize: 24.0, fontWeight: FontWeight.bold, color: color);
        break;
      case TextType.title:
        style = Theme.of(context).textTheme.displayMedium?.copyWith(
                fontSize: 18.0, fontWeight: FontWeight.bold, color: color) ??
            TextStyle(
                fontSize: 18.0, fontWeight: FontWeight.bold, color: color);
        break;
      case TextType.subtitle:
        style = Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontSize: 16.0, color: color) ??
            TextStyle(fontSize: 16.0, color: color);
        break;
      default:
        style = Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: color, fontSize: fontSize, fontWeight: fontWeight) ??
            TextStyle(color: color, fontSize: fontSize, fontWeight: fontWeight);
    }

    return Text(
      title,
      style: style,
      textAlign: textAlign,
      overflow: overflow,
      softWrap: softWrap,
    );
  }
}

enum TextType {
  titleLarge,
  title,
  subtitle,
  body,
}
