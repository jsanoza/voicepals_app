import 'package:get/get.dart';
import 'package:voicepals/app/data/provider/home_provider.dart';
import 'package:voicepals/app/data/provider/settings_provider.dart';
import 'package:voicepals/app/modules/settings_module/settings_controller.dart';

import '../../../app/data/provider/lookup_provider.dart';
import '../../../app/modules/lookup_module/lookup_controller.dart';
import '../home_module/home_controller.dart';

class LookupBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LookupController>(
      () => LookupController(
        provider: LookupProvider(),
      ),
    );
    Get.lazyPut<HomeController>(
      () => HomeController(
        provider: HomeProvider(),
      ),
    );
    Get.lazyPut<SettingsController>(
      () => SettingsController(
        provider: SettingsProvider(),
      ),
    );
  }
}
