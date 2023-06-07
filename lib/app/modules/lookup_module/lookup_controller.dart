import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:voicepals/app/modules/home_module/home_page.dart';
import 'package:voicepals/app/routes/app_pages.dart';
import '../../../app/data/provider/lookup_provider.dart';
import 'package:just_audio/just_audio.dart';
import 'package:record/record.dart';

class LookupController extends GetxController with GetSingleTickerProviderStateMixin {
  final LookupProvider? provider;
  LookupController({this.provider});

  PageController pageViewController = PageController();
  var selectedIndex = 0.obs;

  var canVibrate = false.obs;

  final iconList = <IconData>[
    LucideIcons.home,
    LucideIcons.settings,
  ];

  setUp() async {
    canVibrate.value = await Vibrate.canVibrate;
  }

  @override
  void onInit() {
    // TODO: implement onInit
    setUp();
    super.onInit();
  }
}
