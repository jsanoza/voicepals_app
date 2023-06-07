import 'package:get/get.dart';

import '../../../app/data/provider/profile_details_provider.dart';
import '../../../app/modules/profile_details_module/profile_details_controller.dart';

class ProfileDetailsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileDetailsController>(
      () => ProfileDetailsController(
        provider: ProfileDetailsProvider(),
      ),
    );
  }
}
