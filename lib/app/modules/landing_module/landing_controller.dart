import 'dart:developer';

import 'package:get/get.dart';
import '../../../app/data/provider/landing_provider.dart';

class LandingController extends GetxController {
  final LandingProvider? provider;
  LandingController({this.provider});

  @override
  void onInit() {
    log("Im in landing");
    super.onInit();
  }
}
