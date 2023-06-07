import 'dart:developer';
import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:voicepals/app/data/provider/chat_provider.dart';
import 'package:voicepals/app/modules/chat_module/chat_controller.dart';
import 'package:voicepals/app/modules/settings_module/settings_controller.dart';
import '../../../app/data/provider/profile_provider.dart';
import '../../data/model/profile_information.dart';
import '../../routes/app_pages.dart';
import '../../utils/common.dart';
import '../../utils/constants.dart';
import '../home_module/home_controller.dart';

class ProfileController extends GetxController {
  ProfileController({this.provider});
  final ProfileProvider? provider;
  final myUserId = supabase.auth.currentUser!.id.toString();
  var profileInfo = Rx<ProfileInformation>(ProfileInformation());

  RxString imagePath = RxString('');

  pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      imagePath.value = pickedImage.path;
    }
  }

  addRoom(String userID) async {
    if (userID != myUserId) {
      log(userID.toString());
      var roomId = await provider!.createRoom(userID);
      Get.back();
      Get.put(ChatController(provider: ChatProvider()));
      Get.find<ChatController>().profileInfo.value = ProfileInformation();
      Get.find<ChatController>().roomId.value = roomId;
      Get.find<ChatController>().profileInfo.value = profileInfo.value;
      Get.toNamed(AppRoutes.chat);
      Get.find<ChatController>().subscribeToRoomsStream(roomId);

      Get.find<HomeController>().visibleRoom(roomId: roomId);

      Get.find<HomeController>().reload();
    } else {
      Common.showError("This is how your profile looks like to others.");
    }
  }

  uploadInfo() async {
    Common.showLoading();
    var isUpdate = false.obs;
    if (profileInfo.value.profileCover != null) isUpdate.value = true;
    if (profileInfo.value.profileCover == null) isUpdate.value = false;
    File file = File(imagePath.value);
    var response = await provider!.uploadProfileCover(imagePath.value, file, isUpdate.value);
    await provider!.updateUserCover(response);

    profileInfo.value.profileCover = response;
    imagePath.value = "";
    Get.find<SettingsController>().getUserInfo();
    Get.back();

    Common.showError("Updated!");
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
