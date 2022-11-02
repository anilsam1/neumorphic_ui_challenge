import 'package:flutter/material.dart';
import 'package:flutter_demo_structure/values/colors.dart';
import 'package:flutter_demo_structure/values/style.dart';

final ThemeData appTheme = ThemeData(
  primaryColor: AppColor.primaryColor,
  scaffoldBackgroundColor: const Color(0xfff9f9f9),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  appBarTheme: AppBarTheme(
    color: AppColor.primaryColor,
    iconTheme: const IconThemeData(color: AppColor.white, size: 30.0),
    toolbarTextStyle: TextTheme(
      headline6: textBold,
    ).bodyText2,
    titleTextStyle: TextTheme(
      headline6: textBold,
    ).headline6,
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: AppColor.textBackgroundColor,
    disabledColor: AppColor.textBackgroundColor,
  ),
  colorScheme:
      ColorScheme.fromSwatch().copyWith(secondary: AppColor.brownColor),
);
