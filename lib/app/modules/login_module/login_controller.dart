import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';
import '../../../app/data/provider/login_provider.dart';
import '../../themes/theme_service.dart';

class LoginController extends GetxController {
  final LoginProvider? provider;
  LoginController({this.provider});

  final ThemeService _themeService = Get.find();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  var asset = "assets/animations/kcSwitch.riv".obs;
  var isSwitchLoaded = false.obs;
  late Artboard riveArtboard;
  late StateMachineController riveController;
  late SMIBool triggerSwitch;
  var isThemeChanged = false.obs;
  var canVibrate = false.obs;
  var facebookAsset = "assets/socials/facebook_glyph.png".obs;
  var githubAsset = "assets/socials/github_glyph.png".obs;
  var linkedinAsset = "assets/socials/linkedin_glyph.png".obs;
  var appleAsset = "assets/socials/apple_glyph.png".obs;

  changeTheme() async {
    if (triggerSwitch.value == true) {
      triggerSwitch.change(false);
      if (canVibrate.value) Vibrate.feedback(FeedbackType.success);
      _themeService.toggleTheme();
    } else {
      if (canVibrate.value) Vibrate.feedback(FeedbackType.success);
      triggerSwitch.change(true);
      _themeService.toggleTheme();
    }
  }

  signInUsers() async {
    if (canVibrate.value) Vibrate.feedback(FeedbackType.success);
    await provider!.signInUsers(emailController.text, passwordController.text);
  }

  signInUsersGitHub() async {
    if (canVibrate.value) Vibrate.feedback(FeedbackType.success);
    await provider!.signInUsersGitHub();
  }

  initializeRive() async {
    canVibrate.value = await Vibrate.canVibrate;
    rootBundle.load(asset.value).then((data) async {
      final file = RiveFile.import(data);
      riveArtboard = file.mainArtboard;
      riveController = StateMachineController.fromArtboard(riveArtboard, 'State Machine 1')!;
      riveArtboard.addController(riveController);
      triggerSwitch = riveController.findSMI('isDark');
      riveController.inputs.forEach((element) {});

      Get.isDarkMode ? triggerSwitch.change(true) : triggerSwitch.change(false);
      isSwitchLoaded.value = true;
    });
  }

  @override
  void onInit() {
    initializeRive();
    super.onInit();
  }
}
