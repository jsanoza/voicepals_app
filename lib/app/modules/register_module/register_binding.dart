import 'package:get/get.dart';

import '../../../app/data/provider/register_provider.dart';
import '../../../app/modules/register_module/register_controller.dart';

class RegisterBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterController>(
      () => RegisterController(
        provider: RegisterProvider(),
      ),
    );
  }
}
