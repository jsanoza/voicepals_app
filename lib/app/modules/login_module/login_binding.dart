import 'package:get/get.dart';

import '../../../app/data/provider/login_provider.dart';
import '../../../app/modules/login_module/login_controller.dart';

class LoginBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(
      () => LoginController(
        provider: LoginProvider(),
      ),
    );
  }
}
