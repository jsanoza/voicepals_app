import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../themes/app_colors.dart';
import '../../themes/app_text_theme.dart';
import '../../utils/common.dart';
import '../api/supabase_auth.dart';

class RegisterProvider {
  RegisterProvider();

  final AuthService _service = AuthService();

  Future<void> signUpUsers(email, password, username) async {
    Common.dismissKeyboard();
    // Common.showLoading();
    try {
      await _service.signUpUsers(email, password, username);
      Get.back();
      showSuccess();
    } on AuthException catch (error) {
      Common.showError(error.message.toString());
      Get.back();
    } catch (e) {
      Common.showError(e.toString());
      Get.back();
    }
  }

  Future<void> signInUsersGitHub() async {
    Common.dismissKeyboard();
    Common.showLoading();
    try {
      await _service.signInUsersGitHub();
    } on AuthException catch (error) {
      Get.back();
      Common.showError(error.message.toString());
    } catch (e) {
      Get.back();
      Common.showError(e.toString());
    }
  }

  showSuccess() async {
    Get.dialog(
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Material(
                  child: Column(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Colors.green,
                        child: Icon(
                          Icons.check,
                          color: AppColors.white,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: Get.width / 2,
                        child: Center(
                            child: Text(
                          "Successfully created!",
                          style: AppTextStyles.base.w500,
                        )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
