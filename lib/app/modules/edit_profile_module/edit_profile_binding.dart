import 'package:get/get.dart';

import '../../../app/data/provider/edit_profile_provider.dart';
import '../../../app/modules/edit_profile_module/edit_profile_controller.dart';

class EditProfileBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditProfileController>(
      () => EditProfileController(
        provider: EditProfileProvider(),
      ),
    );
  }
}
