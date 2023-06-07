import 'package:get/get.dart';

import '../../../app/data/provider/splash_provider.dart';
import '../../../app/modules/splash_module/splash_controller.dart';

class SplashBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(
      () => SplashController(
        provider: SplashProvider(),
      ),
    );
  }
}
