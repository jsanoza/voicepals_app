import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:voicepals/app/modules/home_module/home_controller.dart';
import 'package:voicepals/app/modules/home_module/home_page.dart';
import 'package:voicepals/app/modules/settings_module/settings_page.dart';
import '../../../app/modules/lookup_module/lookup_controller.dart';

class LookupPage extends GetWidget<LookupController> {
  const LookupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: IndexedStack(
          index: controller.selectedIndex.value,
          children: [
            HomePage(),
            SettingsPage(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: controller.selectedIndex.value,
          items: [
            BottomNavigationBarItem(
              icon: Icon(LucideIcons.home),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(LucideIcons.settings),
              label: "",
            ),
          ],
          onTap: (index) {
            if (controller.canVibrate.value) Vibrate.feedback(FeedbackType.success);
            controller.selectedIndex.value = index;
            log(index.toString());
          },
        ),
      ),
    );
  }
}

Widget _buildPage(int index) {
  switch (index) {
    case 0:
      return HomePage();
    case 1:
      return SettingsPage();
    default:
      return HomePage();
  }
}
