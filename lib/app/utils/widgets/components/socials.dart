import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../../themes/app_text_theme.dart';
import '../../common.dart';
import '../app_divider/app_divider.dart';

class Socials extends StatelessWidget {
  const Socials({
    super.key,
    required this.controller,
    this.fromWhere,
  });

  final controller;
  final fromWhere;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 8),
                child: AppDivider(
                  color: Colors.grey,
                  height: 30,
                ),
              ),
            ),
            Text(
              "OR",
              style: AppTextStyles.base,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 20),
                child: AppDivider(
                  color: Colors.grey,
                  height: 30,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Common.dismissKeyboard();
                controller.signInUsersGitHub();
              },
              child: Container(
                height: 50,
                width: 50,
                child: Get.isDarkMode ? Image.asset("assets/socials/github.png") : Image.asset("assets/socials/github_glyph.png"),
              ),
            ),
            GestureDetector(
              onTap: () {
                Common.dismissKeyboard();
                Common.showError("Coming soon.");
              },
              child: Container(
                height: 50,
                width: 50,
                child: Get.isDarkMode ? Image.asset("assets/socials/facebook.png") : Image.asset("assets/socials/facebook_glyph.png"),
              ),
            ),
            GestureDetector(
              onTap: () {
                Common.dismissKeyboard();
                Common.showError("Coming soon.");
              },
              child: Container(
                height: 50,
                width: 50,
                child: Get.isDarkMode ? Image.asset("assets/socials/linkedin.png") : Image.asset("assets/socials/linkedin_glyph.png"),
              ),
            ),
            GestureDetector(
              onTap: () {
                Common.dismissKeyboard();
                Common.showError("Coming soon.");
              },
              child: Container(
                height: 50,
                width: 50,
                child: Get.isDarkMode ? Image.asset("assets/socials/apple.png") : Image.asset("assets/socials/apple_glyph.png"),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              fromWhere == "login" ? "Don't have an account yet?" : "Already have an account?",
              style: AppTextStyles.base.s14,
            ),
            SizedBox(
              width: 8,
            ),
            InkWell(
              onTap: () {
                fromWhere == "login" ? Get.toNamed(AppRoutes.register) : Get.back();
              },
              child: Text(
                fromWhere == "login" ? "Sign Up" : "Sign In",
                style: AppTextStyles.base.s14.w900.underline,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
