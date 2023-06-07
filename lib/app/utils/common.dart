import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:voicepals/app/themes/app_colors.dart';
import 'package:voicepals/app/themes/app_text_theme.dart';

import '../themes/app_theme.dart';

class Common {
  Common._();

  static void showError(String error) {
    Get.showSnackbar(
      GetSnackBar(
        messageText: Text(
          error,
          style: AppTextStyles.base,
        ),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        backgroundColor: Get.isDarkMode ? AppThemes.themeDataDark.primaryColor : Colors.white,
        duration: const Duration(milliseconds: 2000),
      ),
    );
  }

  static void showLoading() {
    Get.dialog(
      Center(
        child: Container(
          height: 100,
          width: 100,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: AppColors.transparent,
          ),
          child: SpinKitFadingCircle(
            size: 50,
            color: AppColors.kPrimaryColor,
          ),
        ),
      ),
      barrierColor: AppColors.white.withOpacity(0.8),
      barrierDismissible: true,
      transitionCurve: Curves.easeInOutBack,
    );
  }

  static Future showSuccess({String? title}) async {
    Timer? _timer;
    return await Get.dialog(
      
      Builder(
        builder: (BuildContext builderContext) {
          _timer = Timer(const Duration(seconds: 2), () {
            Get.back();
          });

          return Scaffold(
            body: Center(
              child: Container(
                width: Get.width,
                height: 200,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: AppColors.white,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 16),
                    const CircleAvatar(
                      backgroundColor: Colors.green,
                      child: Icon(
                        Icons.check,
                        color: AppColors.white,
                      ),
                    ),
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: Get.width * 2 / 3,
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        title ?? 'Successful',
                        style: AppTextStyles.base.w400.s16.blackColor,
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),

      transitionCurve: Curves.easeInOutBack,
    ).then((val) {
      if (_timer!.isActive) {
        _timer!.cancel();
      }
    });
  }

  static void dismissKeyboard() => Get.focusScope!.unfocus();
}
