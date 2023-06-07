import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:delayed_widget/delayed_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../app/modules/edit_profile_module/edit_profile_controller.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_text_theme.dart';
import '../../utils/widgets/app_button/app_button.dart';
import '../../utils/widgets/app_text_field/app_text_field.dart';

class EditProfilePage extends GetWidget<EditProfileController> {
  const EditProfilePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).buttonTheme.colorScheme!.primaryContainer,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            LucideIcons.chevronLeft,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          "Edit Profile",
          style: AppTextStyles.base,
        ),
      ),
      body: Container(
        height: Get.height,
        width: Get.width,
        child: Column(
          children: [
            Expanded(
              child: DelayedWidget(
                delayDuration: Duration(milliseconds: 400),
                animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                child: Container(
                  height: Get.height,
                  width: Get.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(50.0),
                      topLeft: Radius.circular(50.0),
                    ),
                    color: Theme.of(context).cardColor,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 40,
                        ),
                        Column(
                          children: [
                            Obx(
                              () => controller.imagePath.value == ""
                                  ? Container(
                                      width: 200.0,
                                      height: 200.0,
                                      decoration: BoxDecoration(shape: BoxShape.circle),
                                      child: CachedNetworkImage(
                                        fit: BoxFit.fill,
                                        imageUrl: controller.profileInfo.value.profilePicture.toString(),
                                        imageBuilder: (context, imageProvider) => CircleAvatar(
                                          radius: 90,
                                          backgroundImage: imageProvider,
                                        ),
                                        errorWidget: (context, url, error) => const CircleAvatar(
                                          radius: 90,
                                          backgroundImage: NetworkImage("https://cdn-icons-png.flaticon.com/512/6915/6915987.png"),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      width: 200,
                                      height: 200,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: FileImage(
                                            File(
                                              controller.imagePath.value,
                                            ),
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            CircleAvatar(
                              backgroundColor: Theme.of(context).buttonTheme.colorScheme!.primaryContainer,
                              radius: 30,
                              child: IconButton(
                                iconSize: 25,
                                onPressed: () {
                                  controller.pickImage(ImageSource.gallery);
                                },
                                icon: Icon(
                                  LucideIcons.focus,
                                  color: Get.isDarkMode ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            AppTextField(
                              hintText: "First Name",
                              controller: controller.firstNameController,
                              obscureText: false,
                              maxLength: 25,
                            ),
                            const SizedBox(height: 16),
                            AppTextField(
                              hintText: "Last Name",
                              controller: controller.lastNameController,
                              obscureText: false,
                              maxLength: 25,
                            ),
                            const SizedBox(height: 16),
                            AppTextField(
                              maxLength: 11,
                              hintText: "Mobile",
                              controller: controller.mobileController,
                              obscureText: false,
                              textInputType: TextInputType.phone,
                            ),
                            const SizedBox(height: 16),
                            AppTextField(
                              enabled: false,
                              hintText: "Email",
                              controller: controller.emailController,
                              obscureText: false,
                            ),
                            const SizedBox(height: 32),
                            AppButton(
                              text: "Save",
                              onPressed: () {
                                controller.uploadInfo();
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
