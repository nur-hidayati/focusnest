import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:focusnest/src/constants/app_color.dart';

ThemeData appTheme() {
  return ThemeData(
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      backgroundColor: Colors.transparent,
    ),
    canvasColor: Colors.white,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColor.primaryColor,
      primary: AppColor.primaryColor,
      secondary: AppColor.secondaryColor,
      brightness: Brightness.light,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColor.inputColor,
      isDense: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(width: 0, style: BorderStyle.none),
      ),
    ),
  );
}