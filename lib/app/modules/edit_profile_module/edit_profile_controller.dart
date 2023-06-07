import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../app/data/provider/edit_profile_provider.dart';
import '../../data/model/profile_information.dart';
import '../../utils/common.dart';
import '../settings_module/settings_controller.dart';

class EditProfileController extends GetxController {
  final EditProfileProvider? provider;
  EditProfileController({this.provider});

  var profileInfo = Rx<ProfileInformation>(ProfileInformation());
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  RxString imagePath = RxString('');
  var isImageChanged = false.obs;

  pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      isImageChanged.value = true;
      imagePath.value = pickedImage.path;
      log(imagePath.value.toString());
    }
  }

  triggerInfo() async {
    emailController.text = profileInfo.value.email.toString();
    mobileController.text = profileInfo.value.mobile.toString();
    firstNameController.text = profileInfo.value.firstName.toString();
    lastNameController.text = profileInfo.value.lastName.toString();
  }

  uploadInfo() async {
    if (firstNameController.text.isEmpty || mobileController.text.isEmpty || lastNameController.text.isEmpty) {
      if (Get.isSnackbarOpen) {
        Get.back();
      } else {
        Get.back();
        Common.showError("Please fill all the fields");
      }
    } else {
      if (isImageChanged.value == true) {
        Common.showLoading();
        File file = File(imagePath.value);
        final data = await readImageFromAsset('assets/kcProfileBg.png');
        var response = await provider!.uploadProfilePicture(imagePath.value, file);

        saveUpdates(response);
        log(response.toString());
      } else {
        saveUpdates(
          profileInfo.value.profilePicture.toString(),
        );
      }
    }
  }

  Future<List<int>> readImageFromAsset(String assetPath) async {
    final data = await rootBundle.load(assetPath);
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

  saveUpdates(
    String profilePath,
  ) async {
    await provider!.updateUserInfo(firstNameController.text, lastNameController.text, mobileController.text, profilePath);
    Get.find<SettingsController>().getUserInfo();
    Get.back();
    Common.showError("Updated!");
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }
}
