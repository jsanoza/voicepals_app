import 'package:get/get.dart';

import '../../../app/data/provider/profile_provider.dart';
import '../../../app/modules/profile_module/profile_controller.dart';

class ProfileBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(
      () => ProfileController(
        provider: ProfileProvider(),
      ),
    );
  }
}
