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
  final double? letterSpacing;

  const CustomText({
    required this.title,
    this.textAlign = TextAlign.left,
    this.overflow = TextOverflow.visible,
    this.softWrap = true,
    this.textType = TextType.body,
    this.fontSize = 16.0,
    this.color = Colors.black,
    this.fontWeight = FontWeight.normal,
    this.letterSpacing,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle style;
    switch (textType) {
      case TextType.titleLarge:
        style = Theme.of(context)
            .textTheme
            .headlineSmall!
            .copyWith(fontWeight: FontWeight.bold, color: color);
        break;
      case TextType.title:
        style = Theme.of(context)
            .textTheme
            .titleLarge!
            .copyWith(fontWeight: FontWeight.bold, color: color);
        break;
      case TextType.subtitle:
        style = Theme.of(context)
            .textTheme
            .bodyLarge!
            .copyWith(color: Colors.grey.shade700);
        break;
      default:
        style = Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: color,
              fontSize: fontSize,
              fontWeight: fontWeight,
              letterSpacing: letterSpacing,
            );
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
