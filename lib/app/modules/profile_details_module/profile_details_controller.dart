import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:voicepals/app/routes/app_pages.dart';
import 'package:voicepals/app/themes/app_text_theme.dart';
import '../../../app/data/provider/profile_details_provider.dart';
import '../../themes/app_colors.dart';
import '../../utils/common.dart';

class ProfileDetailsController extends GetxController {
  final ProfileDetailsProvider? provider;
  ProfileDetailsController({this.provider});

  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  final box = Get.put(GetStorage());
  var isFromSocials = false.obs;
  var userNameFromMetadata = "".obs;
  RxString imagePath = RxString('');
  var errorString = "".obs;

  pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      imagePath.value = pickedImage.path;
    }
  }

  getUserMetadata() async {
    var userMetadata = await provider!.getUserMetadata();
    log(userMetadata!.userMetadata.toString() + "xss");

    if (userMetadata.userMetadata!['full_name'] != null) {
      isFromSocials.value = true;
      var completeName = userMetadata.userMetadata!['full_name'].toString().split(' ');
      userNameFromMetadata.value = userMetadata.userMetadata!['user_name'].toString();
      firstNameController.text = completeName[0];
      lastNameController.text = completeName[1];
      emailController.text = userMetadata.userMetadata!['email'].toString();
    } else {
      var userData = await provider!.getUserInfo();
      if (userData.firstName.toString() == "null") {
        firstNameController.text = "";
      } else {
        firstNameController.text = userData.lastName.toString();
      }
      if (userData.lastName.toString() == "null") {
        lastNameController.text = "";
      } else {
        lastNameController.text = userData.lastName.toString();
      }
      emailController.text = userData.email.toString();
    }
  }

  uploadInfo() async {
    if (firstNameController.text.isEmpty || mobileController.text.isEmpty || lastNameController.text.isEmpty || imagePath.value.isEmpty) {
      if (Get.isSnackbarOpen) {
        Get.back();
      } else {
        Get.back();
        Common.showError("Please fill all the fields");
      }
    } else {
      Common.showLoading();
      File file = File(imagePath.value);
      var response = await provider!.uploadProfilePicture(imagePath.value, file);

      updateUserInfo(
        response,
      );
      log(response.toString());
    }
  }

  updateUserInfo(
    String profilePath,
  ) async {
    if (isFromSocials.value == true) {
      await provider!.updateUserInfoFromMetaData(userNameFromMetadata.value, emailController.text).then((value) async {
        await provider!.updateUserInfo(firstNameController.text, lastNameController.text, mobileController.text, profilePath);
        showSuccess();
        Future.delayed(Duration(milliseconds: 1000), () {
          Get.offAllNamed(AppRoutes.lookup);
        });
      });
    } else {
      await provider!.updateUserInfo(firstNameController.text, lastNameController.text, mobileController.text, profilePath);
      showSuccess();
      Future.delayed(Duration(milliseconds: 1000), () {
        Get.offAllNamed(AppRoutes.lookup);
      });
    }
  }

  Future<List<int>> readImageFromAsset(String assetPath) async {
    final data = await rootBundle.load(assetPath);
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

  showSuccess() async {
    Get.dialog(
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Material(
                  child: Column(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Colors.green,
                        child: Icon(
                          Icons.check,
                          color: AppColors.white,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: Get.width / 2,
                        child: Center(
                            child: Text(
                          "Successfully created!",
                          style: AppTextStyles.base.w500,
                        )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void onInit() {
    getUserMetadata();
    super.onInit();
  }
}
