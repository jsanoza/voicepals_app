import 'package:delayed_widget/delayed_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';
import '../../../app/modules/register_module/register_controller.dart';
import '../../themes/app_text_theme.dart';
import '../../utils/widgets/app_button/app_button.dart';
import '../../utils/widgets/app_text_field/app_text_field.dart';
import '../../utils/widgets/components/clippers.dart';
import '../../utils/widgets/components/socials.dart';

class RegisterPage extends GetWidget<RegisterController> {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          Obx(
            () => controller.isSwitchLoaded != false
                ? DelayedWidget(
                    delayDuration: Duration(milliseconds: 1000),
                    animationDuration: Duration(milliseconds: 800),
                    animation: DelayedAnimations.SLIDE_FROM_RIGHT,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Container(
                        width: 70,
                        child: GestureDetector(
                          onTap: () {
                            controller.changeTheme();
                          },
                          child: Rive(
                            fit: BoxFit.contain,
                            artboard: controller.riveArtboard,
                          ),
                        ),
                      ),
                    ),
                  )
                : SizedBox.shrink(),
          ),
        ],
      ),
      body: Container(
        width: Get.width,
        height: Get.height,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: DelayedWidget(
                delayDuration: Duration(milliseconds: 1000),
                animationDuration: Duration(milliseconds: 800),
                animation: DelayedAnimations.SLIDE_FROM_RIGHT,
                child: ClipPath(
                  clipper: WaveShape(),
                  child: Container(
                    width: Get.width,
                    height: 160,
                    color: Theme.of(context).buttonTheme.colorScheme!.primaryContainer,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: DelayedWidget(
                delayDuration: Duration(milliseconds: 1000),
                animationDuration: Duration(milliseconds: 800),
                animation: DelayedAnimations.SLIDE_FROM_LEFT,
                child: ClipPath(
                  clipper: BottomWaveShape(),
                  child: Container(
                    width: Get.width,
                    height: 160,
                    color: Theme.of(context).buttonTheme.colorScheme!.primaryContainer,
                  ),
                ),
              ),
            ),
            DelayedWidget(
              delayDuration: Duration(milliseconds: 200),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  SafeArea(
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 18.0),
                          child: Text(
                            "Join the club.",
                            style: AppTextStyles.base.s32.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0),
                        child: Text(
                          "Register Now!",
                          style: AppTextStyles.base.s20,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  AppTextField(
                    hintText: "Username",
                    controller: controller.userNameController,
                    obscureText: false,
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    hintText: "Email",
                    controller: controller.emailController,
                    obscureText: false,
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    hintText: "Password",
                    controller: controller.passwordController,
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),
                  AppButton(
                    borderRadius: 12,
                    text: "Sign up",
                    onPressed: () {
                      controller.signUpUsers();
                    },
                  ),
                  Socials(controller: controller),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
