import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';
import '../../../app/data/provider/settings_provider.dart';
import '../../data/model/profile_information.dart';
import '../../themes/theme_service.dart';

class SettingsController extends GetxController {
  final SettingsProvider? provider;
  SettingsController({this.provider});

  final ThemeService _themeService = Get.find();

  var profileInfo = Rx<ProfileInformation>(ProfileInformation());

  var asset = "assets/animations/kcSwitch.riv".obs;
  var isSwitchLoaded = false.obs;
  late Artboard riveArtboard;
  late StateMachineController riveController;
  late SMIBool triggerSwitch;
  var isThemeChanged = false.obs;
  var canVibrate = false.obs;

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

  changeTheme() async {
    if (triggerSwitch.value == true) {
      triggerSwitch.change(false);
      _themeService.toggleTheme();
      if (canVibrate.value) Vibrate.feedback(FeedbackType.success);
    } else {
      triggerSwitch.change(true);
      if (canVibrate.value) Vibrate.feedback(FeedbackType.success);
      _themeService.toggleTheme();
    }
  }

  signOutUsers() async {
    await provider!.signOutUsers();
  }

  getUserInfo() async {
    log("Called");
    profileInfo.value = await provider!.getUserInfo();
    log(profileInfo.value.profilePicture.toString());
    log(profileInfo.value.firstName.toString());
  }

  @override
  void onInit() {
    getUserInfo();
    initializeRive();
    super.onInit();
  }
}
