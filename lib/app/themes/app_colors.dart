import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppColors {
  AppColors._();

  static Color kPrimaryColor = Theme.of(Get.context!).primaryColor;
  static Color kButtonThemeColor = Theme.of(Get.context!).buttonTheme.colorScheme!.primaryContainer;

  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color transparent = Color(0x00000000);
  static const Color green = Color(0xFF43A838);
  static const Color red = Color(0xFFFF3B3B);
  static const Color gray = Color(0xFFAAAAAA);
  static const Color lightGray = Color(0xFF909296);
  static const Color colorDivider = Color(0xFFEBEBEB);

  static const Color neutral6 = Color(0xFFF1F2F9);
  static const Color neutral3 = Color(0xFFADAFC5);
}
