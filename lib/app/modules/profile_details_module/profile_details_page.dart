import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:delayed_widget/delayed_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:voicepals/app/themes/app_text_theme.dart';
import 'package:voicepals/app/utils/widgets/app_button/app_button.dart';
import 'package:voicepals/app/utils/widgets/app_text_field/app_text_field.dart';
import '../../../app/modules/profile_details_module/profile_details_controller.dart';
import '../../themes/app_colors.dart';
import '../../utils/common.dart';
import '../../utils/widgets/components/clippers.dart';

class ProfileDetailsPage extends GetWidget<ProfileDetailsController> {
  const ProfileDetailsPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Common.dismissKeyboard();
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Stack(
              children: [
                DelayedWidget(
                  animation: DelayedAnimations.SLIDE_FROM_TOP,
                  child: ClipPath(
                    clipper: WaveClipper(),
                    child: Container(
                      color: Theme.of(context).buttonTheme.colorScheme!.primaryContainer,
                      height: 220,
                      alignment: Alignment.center,
                    ),
                  ),
                ),
                DelayedWidget(
                  animation: DelayedAnimations.SLIDE_FROM_TOP,
                  child: ClipPath(
                    clipper: WaveClipper(waveDeep: 0, waveDeep2: 100),
                    child: Container(
                      color: Theme.of(context).buttonTheme.colorScheme!.primaryContainer.withOpacity(0.3),
                      height: 180,
                      alignment: Alignment.center,
                    ),
                  ),
                ),
                Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    DelayedWidget(
                      animation: DelayedAnimations.SLIDE_FROM_LEFT,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 18.0, right: 18),
                                child: Text(
                                  "Enhance your profile:",
                                  style: AppTextStyles.base.s24.w900,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 18.0, right: 18),
                                  child: Text(
                                    'Unleash your personalized potential!'.tr,
                                    style: AppTextStyles.base.s14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    GestureDetector(
                      onTap: () {
                        controller.pickImage(ImageSource.gallery);
                      },
                      child: Container(
                        height: 200,
                        width: 200,
                        padding: EdgeInsets.all(8),
                        child: Stack(
                          children: [
                            Obx(
                              () => controller.imagePath.isNotEmpty
                                  ? Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: FileImage(
                                            File(
                                              controller.imagePath.value,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : CachedNetworkImage(
                                      fit: BoxFit.contain,
                                      imageUrl: "https://cdn-icons-png.flaticon.com/512/6915/6915987.png",
                                    ),
                            ),
                            Positioned.fill(
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: GestureDetector(
                                  onTap: () {
                                    controller.pickImage(ImageSource.gallery);
                                  },
                                  child: Container(
                                    height: 20,
                                    width: 20,
                                    child: Icon(
                                      Icons.photo_camera,
                                      size: 30,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    DelayedWidget(
                        child: Column(
                      children: [
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
                          text: "Continue",
                          onPressed: () {
                            controller.uploadInfo();
                          },
                        ),
                      ],
                    ))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
