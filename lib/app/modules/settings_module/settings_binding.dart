import 'package:get/get.dart';

import '../../../app/data/provider/settings_provider.dart';
import '../../../app/modules/settings_module/settings_controller.dart';

class SettingsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingsController>(
      () => SettingsController(
        provider: SettingsProvider(),
      ),
    );
  }
}
