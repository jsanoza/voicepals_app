import 'dart:developer';

import 'package:delayed_widget/delayed_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:voicepals/app/routes/app_pages.dart';
import 'package:voicepals/app/utils/widgets/app_button/app_button.dart';
import '../../../app/modules/landing_module/landing_controller.dart';
import '../../themes/app_text_theme.dart';

class LandingPage extends GetWidget<LandingController> {
  const LandingPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: Get.height,
            width: Get.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                  "https://img.freepik.com/premium-photo/young-woman-using-app-translator-smartphone-speaking-into-mobile-phone-dynamic-holding-cellphone-near-lips-recording-voice-message-blue-background_1258-69772.jpg?w=2000",
                ),
                colorFilter: ColorFilter.mode(
                  Theme.of(context).primaryColorLight.withOpacity(1),
                  BlendMode.modulate,
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: DelayedWidget(
              delayDuration: Duration(milliseconds: 1000),
              animationDuration: Duration(milliseconds: 800),
              animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
              child: Container(
                width: Get.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AppButton(
                      borderRadius: 12,
                      text: "Continue",
                      onPressed: () {
                        Get.offAllNamed(AppRoutes.login);
                      },
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            top: 80,
            child: DelayedWidget(
              delayDuration: Duration(milliseconds: 1000),
              animationDuration: Duration(milliseconds: 800),
              animation: DelayedAnimations.SLIDE_FROM_LEFT,
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0),
                        child: Text(
                          "Speak Freely,",
                          style: AppTextStyles.base.s32.w900,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0),
                        child: Text(
                          "Connect Instantly.",
                          style: AppTextStyles.base.s20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
