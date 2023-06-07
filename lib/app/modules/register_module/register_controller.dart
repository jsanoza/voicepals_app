import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';
import '../../../app/data/provider/register_provider.dart';
import '../../themes/theme_service.dart';

class RegisterController extends GetxController {
  final RegisterProvider? provider;
  RegisterController({this.provider});

  final ThemeService _themeService = Get.find();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController userNameController = TextEditingController();

  var asset = "assets/animations/kcSwitch.riv".obs;
  var isSwitchLoaded = false.obs;
  late Artboard riveArtboard;
  late StateMachineController riveController;
  late SMIBool triggerSwitch;
  var isThemeChanged = false.obs;

  var facebookAsset = "assets/socials/facebook_glyph.png".obs;
  var githubAsset = "assets/socials/github_glyph.png".obs;
  var linkedinAsset = "assets/socials/linkedin_glyph.png".obs;
  var appleAsset = "assets/socials/apple_glyph.png".obs;
  var canVibrate = false.obs;

  changeTheme() async {
    if (triggerSwitch.value == true) {
      triggerSwitch.change(false);
      _themeService.toggleTheme();
      if (canVibrate.value) Vibrate.feedback(FeedbackType.success);
    } else {
      triggerSwitch.change(true);
      _themeService.toggleTheme();
      if (canVibrate.value) Vibrate.feedback(FeedbackType.success);
    }
  }

  initializeRive() async {
    canVibrate.value = await Vibrate.canVibrate;
    rootBundle.load(asset.value).then((data) async {
      final file = RiveFile.import(data);
      riveArtboard = file.mainArtboard;
      riveController = StateMachineController.fromArtboard(riveArtboard, 'State Machine 1')!;
      riveArtboard.addController(riveController);
      triggerSwitch = riveController.findSMI('isDark');
      riveController.inputs.forEach((element) {
        log(element.toString());
        log(element.name.toString());
      });

      Get.isDarkMode ? triggerSwitch.change(true) : triggerSwitch.change(false);
      isSwitchLoaded.value = true;
    });
  }

  signUpUsers() async {
    await provider!.signUpUsers(emailController.text, passwordController.text, userNameController.text);
    emailController.text = "";
    passwordController.text = "";
    userNameController.text = "";
    if (canVibrate.value) Vibrate.feedback(FeedbackType.success);
  }

  signInUsersGitHub() async {
    await provider!.signInUsersGitHub();
    if (canVibrate.value) Vibrate.feedback(FeedbackType.success);
  }

  @override
  void onInit() {
    initializeRive();
    super.onInit();
  }
}
