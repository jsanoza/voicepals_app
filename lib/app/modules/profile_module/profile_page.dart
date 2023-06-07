import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:delayed_widget/delayed_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:voicepals/app/themes/app_text_theme.dart';
import 'package:voicepals/app/utils/constants.dart';
import 'package:voicepals/app/utils/widgets/app_button/app_button.dart';
import '../../../app/modules/profile_module/profile_controller.dart';
import '../../themes/app_colors.dart';
import '../../utils/widgets/components/custom_image.dart';
import '../home_module/home_controller.dart';

class ProfilePage extends GetWidget<ProfileController> {
  const ProfilePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).buttonTheme.colorScheme!.primaryContainer,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            LucideIcons.chevronLeft,
            color: Colors.white,
          ),
          onPressed: () {
            Get.find<HomeController>().reload();
            Get.back();
          },
        ),
        title: Text(
          "Profile",
          style: AppTextStyles.base.whiteColor,
        ),
        actions: [
          controller.myUserId == controller.profileInfo.value.profileId.toString()
              ? Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Container(
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        bottomLeft: Radius.circular(20.0),
                      ),
                      color: Theme.of(context).buttonTheme.colorScheme!.background,
                    ),
                    child: IconButton(
                      onPressed: () {
                        showMenu(
                          context: context,
                          position: RelativeRect.fromLTRB(50, 50, 0, 0),
                          items: [
                            PopupMenuItem(
                              textStyle: AppTextStyles.base,
                              child: Row(
                                children: [
                                  Icon(LucideIcons.image),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Replace Cover Photo',
                                    style: AppTextStyles.base.w600,
                                  ),
                                ],
                              ),
                              value: 'option1',
                            ),
                          ],
                        ).then((value) {
                          if (value != null) {
                            // Handle menu item selection here
                            switch (value) {
                              case 'option1':
                                controller.pickImage(ImageSource.gallery);
                                // Do something for Option 1
                                break;
                              case 'option2':
                                log("Option 2");
                                // Do something for Option 2
                                break;
                            }
                          }
                        });
                      },
                      icon: Icon(
                        Icons.more_vert,
                        color: Get.isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Container(
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), bottomLeft: Radius.circular(20.0)),
                      color: AppColors.kButtonThemeColor,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.more_vert,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
        ],
      ),
      body: Container(
        height: Get.height,
        width: Get.width,
        child: Stack(
          children: [
            DelayedWidget(
              delayDuration: Duration(milliseconds: 400),
              animation: DelayedAnimations.SLIDE_FROM_TOP,
              child: Stack(
                children: [
                  Obx(
                    () => controller.profileInfo.value.profileCover != null && controller.imagePath == ""
                        ? Container(
                            height: Get.height / 1.5,
                            width: Get.width,
                            decoration: BoxDecoration(
                              color: Theme.of(context).buttonTheme.colorScheme!.primaryContainer,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(30.0),
                                bottomLeft: Radius.circular(30.0),
                              ),
                              child: CachedNetworkImage(
                                imageUrl: controller.profileInfo.value.profileCover.toString(),
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : controller.imagePath != ""
                            ? Container(
                                height: Get.height / 1.5,
                                width: Get.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(30.0),
                                    bottomLeft: Radius.circular(30.0),
                                  ),
                                  color: Theme.of(context).cardColor,
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: FileImage(
                                      File(
                                        controller.imagePath.toString(),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Container(
                                height: Get.height / 1.5,
                                width: Get.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(30.0),
                                    bottomLeft: Radius.circular(30.0),
                                  ),
                                  color: Theme.of(context).cardColor,
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage("assets/kcProfileBg.png"),
                                  ),
                                ),
                              ),
                  ),
                ],
              ),
            ),
            DelayedWidget(
              delayDuration: Duration(milliseconds: 400),
              animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
              child: Align(
                alignment: AlignmentDirectional(0.0, 0.67),
                child: Container(
                  width: 330,
                  height: 300,
                  decoration: BoxDecoration(
                    color: Theme.of(Get.context!).cardColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 4,
                        color: Color(0x33000000),
                        offset: Offset(0, 2),
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 80,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Center(
                              child: Text(
                                "${controller.profileInfo.value.firstName.toString().capitalizeFirstLetter()} ${controller.profileInfo.value.lastName.toString().capitalizeFirstLetter()}",
                                style: AppTextStyles.base.s32,
                                overflow: TextOverflow.visible,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Center(
                              child: Text(
                                "@" + controller.profileInfo.value.username!,
                                style: AppTextStyles.base.s14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Obx(
                        () => controller.myUserId != controller.profileInfo.value.profileId.toString()
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                      child: AppButton(
                                    onPressed: () {
                                      log(controller.profileInfo.value.profileId.toString());
                                      controller.addRoom(controller.profileInfo.value.profileId.toString());
                                    },
                                    text: "Message",
                                  )),
                                ],
                              )
                            : controller.imagePath != ""
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                          child: AppButton(
                                        onPressed: () {
                                          controller.uploadInfo();
                                        },
                                        text: "Update Profile Cover",
                                      )),
                                    ],
                                  )
                                : SizedBox.shrink(),
                      )
                    ],
                  ),
                ),
              ),
            ),
            DelayedWidget(
              delayDuration: Duration(milliseconds: 400),
              animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
              child: Align(
                alignment: AlignmentDirectional(-0.0, 0.05),
                child: GestureDetector(
                  onTap: () {
                    Get.defaultDialog(
                      titlePadding: EdgeInsets.all(0),
                      contentPadding: EdgeInsets.all(0),
                      title: "",
                      content: Column(
                        children: [
                          CustomImage(
                            assets: controller.profileInfo.value.profilePicture.toString(),
                            width: Get.width,
                            height: 300,
                            isCircle: false,
                            radius: 0,
                            fit: BoxFit.contain,
                          ),
                          // Container(
                          //   height: 300,
                          //   width: Get.width,
                          //   decoration: BoxDecoration(
                          //     image: DecorationImage(
                          //       image: NetworkImage(
                          //         controller.profileInfo.value.profilePicture.toString(),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          SizedBox(
                            height: 14,
                          ),
                        ],
                      ),
                    );
                  },
                  child: CustomImage(
                    assets: controller.profileInfo.value.profilePicture.toString(),
                    height: 120,
                    isCircle: true,
                    radius: 90,
                    width: 120,
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
