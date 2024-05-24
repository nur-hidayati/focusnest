import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:focusnest/src/constants/app_color.dart';

// This function sets the visual theme for the app
ThemeData appTheme() {
  return ThemeData(
    useMaterial3: true,
    appBarTheme: AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      backgroundColor: Colors.white,
      shape: Border(
        bottom: BorderSide(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      elevation: 0,
      titleTextStyle: const TextStyle(
        fontSize: 20,
        color: Colors.black,
      ),
      iconTheme: const IconThemeData(
        color: AppColor.primaryColor,
      ),
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColor.primaryColor,
      primary: AppColor.primaryColor,
      secondary: AppColor.secondaryColor,
      brightness: Brightness.light,
    ),
    dividerTheme: const DividerThemeData(
      color: AppColor.lightGreyColor,
      thickness: 0.5,
    ),
    iconTheme: const IconThemeData(
      color: AppColor.greyColor,
    ),
    bottomSheetTheme: const BottomSheetThemeData(backgroundColor: Colors.white),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColor.inputColor,
      isDense: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(width: 0, style: BorderStyle.none),
      ),
    ),
    cardTheme: CardTheme(
      surfaceTintColor: Colors.white,
      color: AppColor.inputColor,
      margin: EdgeInsets.zero,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(
          color: AppColor.inputColor,
          width: 1,
        ),
      ),
    ),
  );
}
