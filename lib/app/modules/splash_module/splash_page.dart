
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:voicepals/app/modules/splash_module/splash_controller.dart';
import 'package:voicepals/app/utils/loading.dart';


class SplashPage extends GetWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(SplashController());

    return Scaffold(
      body: Center(
        child: Loading(loadingType: LoadingType.fadingCircle,)
      ),
    );
  }
}
