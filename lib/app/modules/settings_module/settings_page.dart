import 'package:cached_network_image/cached_network_image.dart';
import 'package:delayed_widget/delayed_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:octo_image/octo_image.dart';
import 'package:rive/rive.dart';
import 'package:voicepals/app/data/provider/edit_profile_provider.dart';
import 'package:voicepals/app/data/provider/profile_provider.dart';
import 'package:voicepals/app/modules/edit_profile_module/edit_profile_controller.dart';
import 'package:voicepals/app/modules/profile_module/profile_controller.dart';
import 'package:voicepals/app/utils/constants.dart';
import 'package:voicepals/app/utils/widgets/app_button/app_button.dart';
import '../../../app/modules/settings_module/settings_controller.dart';
import '../../routes/app_pages.dart';
import '../../themes/app_text_theme.dart';
import '../../utils/widgets/components/custom_image.dart';

class SettingsPage extends GetWidget<SettingsController> {
  const SettingsPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).buttonTheme.colorScheme!.primaryContainer,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.transparent,
        title: Text(
          "Settings",
          style: AppTextStyles.base.w900.s24,
        ),
        actions: [
          Obx(
            () => controller.isSwitchLoaded != false
                ? DelayedWidget(
                    animation: DelayedAnimations.SLIDE_FROM_RIGHT,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Container(
                        width: 70,
                        child: GestureDetector(
                          onTap: () {
                            controller.changeTheme();
                          },
                          child: Rive(
                            fit: BoxFit.contain,
                            artboard: controller.riveArtboard,
                          ),
                        ),
                      ),
                    ),
                  )
                : SizedBox.shrink(),
          ),
        ],
      ),
      body: Column(
        children: [
          DelayedWidget(
            delayDuration: Duration(milliseconds: 400),
            animation: DelayedAnimations.SLIDE_FROM_RIGHT,
            child: Obx(
              () => GestureDetector(
                onTap: () {
                  Get.put(ProfileController(provider: ProfileProvider()));
                  Get.find<ProfileController>().profileInfo.value = controller.profileInfo.value;
                  Get.toNamed(AppRoutes.profile);
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 18),
                  child: Container(
                    height: 150,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomImage(
                          assets: controller.profileInfo.value.profilePicture.toString(),
                          height: 100,
                          isCircle: true,
                          radius: 90,
                          width: 100,
                        ),
                        // Container(
                        //   width: 100.0,
                        //   height: 100.0,
                        //   child: OctoImage(
                        //     gaplessPlayback: true,
                        //     imageBuilder: (context, child) {
                        //       return ClipRRect(
                        //         borderRadius: BorderRadius.all(
                        //           Radius.circular(90),
                        //         ),
                        //         child: child,
                        //       );
                        //     },
                        //     image: CachedNetworkImageProvider(
                        //       controller.profileInfo.value.profilePicture.toString(),
                        //     ),
                        //     errorBuilder: OctoError.icon(color: Colors.red),
                        //     progressIndicatorBuilder: (context, progress) {
                        //       double? value;
                        //       var expectedBytes = progress?.expectedTotalBytes;
                        //       if (progress != null && expectedBytes != null) {
                        //         value = progress.cumulativeBytesLoaded / expectedBytes;
                        //       }
                        //       return Padding(
                        //         padding: const EdgeInsets.all(8.0),
                        //         child: SizedBox(
                        //           width: Get.width,
                        //           child: Column(
                        //             mainAxisAlignment: MainAxisAlignment.center,
                        //             crossAxisAlignment: CrossAxisAlignment.center,
                        //             children: [
                        //               CircularProgressIndicator(
                        //                 value: value,
                        //                 color: Theme.of(Get.context!).buttonTheme.colorScheme!.primaryContainer,
                        //               ),
                        //               value != null
                        //                   ? Padding(
                        //                       padding: const EdgeInsets.all(8.0),
                        //                       child: Text(
                        //                         "${value!.toStringAsFixed(2).substring(2)}%",
                        //                         style: TextStyle(color: Colors.black),
                        //                       ),
                        //                     )
                        //                   : Container()
                        //             ],
                        //           ),
                        //         ),
                        //       );
                        //     },
                        //     fit: BoxFit.cover,
                        //   ),

                        //   // CachedNetworkImage(
                        //   //   fit: BoxFit.fill,
                        //   //   imageUrl: controller.profileInfo.value.profilePicture.toString(),
                        //   //   imageBuilder: (context, imageProvider) => CircleAvatar(
                        //   //     radius: 90,
                        //   //     backgroundImage: imageProvider,
                        //   //   ),
                        //   //   errorWidget: (context, url, error) => const CircleAvatar(
                        //   //     radius: 90,
                        //   //     backgroundImage: NetworkImage("https://cdn-icons-png.flaticon.com/512/6915/6915987.png"),
                        //   //   ),
                        //   // ),
                        // ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${controller.profileInfo.value.firstName.toString().capitalizeFirstLetter()} ${controller.profileInfo.value.lastName.toString().capitalizeFirstLetter()}",
                                style: AppTextStyles.base.w900.s24,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                '@${controller.profileInfo.value.username.toString()}',
                                style: AppTextStyles.base.s12,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          padding: EdgeInsets.only(left: 30),
                          onPressed: () {
                            Get.put(EditProfileController(provider: EditProfileProvider()));
                            Get.find<EditProfileController>().profileInfo.value = controller.profileInfo.value;
                            Get.find<EditProfileController>().triggerInfo();
                            Get.toNamed(AppRoutes.editProfile);
                          },
                          icon: Icon(LucideIcons.fileEdit),
                        ),
                        IconButton(
                          padding: EdgeInsets.all(0),
                          onPressed: () {
                            Get.put(ProfileController(provider: ProfileProvider()));
                            Get.find<ProfileController>().profileInfo.value = controller.profileInfo.value;
                            Get.toNamed(AppRoutes.profile);
                          },
                          icon: Icon(LucideIcons.view),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
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
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0, right: 18, top: 10),
                        child: ListTile(
                          leading: Icon(
                            LucideIcons.user,
                            size: 32,
                          ),
                          title: Text(
                            "Account",
                            style: AppTextStyles.base,
                          ),
                          subtitle: Text(
                            "Privacy, Security, change email or number",
                            style: AppTextStyles.base.s12,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0, right: 18, top: 0),
                        child: ListTile(
                          leading: Icon(
                            LucideIcons.bellDot,
                            size: 32,
                          ),
                          title: Text(
                            "Notifications",
                            style: AppTextStyles.base,
                          ),
                          subtitle: Text(
                            "Messages, group & call tones",
                            style: AppTextStyles.base.s12,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0, right: 18, top: 0),
                        child: ListTile(
                          leading: Icon(
                            LucideIcons.serverCog,
                            size: 32,
                          ),
                          title: Text(
                            "Storage and Data",
                            style: AppTextStyles.base,
                          ),
                          subtitle: Text(
                            "Network usage, auto downlaods",
                            style: AppTextStyles.base.s12,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0, right: 18, top: 0),
                        child: ListTile(
                          leading: Icon(
                            LucideIcons.badgeHelp,
                            size: 32,
                          ),
                          title: Text(
                            "Help",
                            style: AppTextStyles.base,
                          ),
                          subtitle: Text(
                            "Help center, contact us, privacy & policy",
                            style: AppTextStyles.base.s12,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 100,
                      ),
                      AppButton(
                          text: "Sign Out",
                          onPressed: () {
                            controller.signOutUsers();
                          }),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      // Stack(
      //   children: [
      //     // DelayedWidget(
      //     //   animation: DelayedAnimations.SLIDE_FROM_TOP,
      //     //   child: ClipPath(
      //     //     clipper: WaveClipper(),
      //     //     child: Container(
      //     //       color: Theme.of(context).buttonTheme.colorScheme!.primaryContainer,
      //     //       height: 220,
      //     //       alignment: Alignment.center,
      //     //     ),
      //     //   ),
      //     // ),
      //     // DelayedWidget(
      //     //   animation: DelayedAnimations.SLIDE_FROM_TOP,
      //     //   child: ClipPath(
      //     //     clipper: WaveClipper(waveDeep: 0, waveDeep2: 100),
      //     //     child: Container(
      //     //       color: Theme.of(context).buttonTheme.colorScheme!.primaryContainer.withOpacity(0.3),
      //     //       height: 180,
      //     //       alignment: Alignment.center,
      //     //     ),
      //     //   ),
      //     // ),
      //     Column(
      //       children: [
      //         SizedBox(
      //           height: 100,
      //         ),
      //         // DelayedWidget(
      //         //   child: Padding(
      //         //     padding: const EdgeInsets.all(8.0),
      //         //     child: Container(
      //         //       height: 120,
      //         //       width: Get.width,
      //         //       decoration: BoxDecoration(
      //         //         color: Theme.of(context).scaffoldBackgroundColor,
      //         //         borderRadius: BorderRadius.circular(12.0),
      //         //         boxShadow: [
      //         //           BoxShadow(
      //         //             color: Colors.grey.withOpacity(0.2),
      //         //             spreadRadius: 5,
      //         //             blurRadius: 7,
      //         //             offset: Offset(0, 3), // changes position of shadow
      //         //           ),
      //         //         ],
      //         //       ),
      //         //       child: Row(
      //         //         children: [
      //         //           SizedBox(
      //         //             width: 20,
      //         //           ),
      //         //           CachedNetworkImage(
      //         //             imageUrl: controller.profileInfo.value.profilePicture.toString(),
      //         //             imageBuilder: (context, imageProvider) => CircleAvatar(
      //         //               radius: 50,
      //         //               backgroundImage: imageProvider,
      //         //             ),
      //         //             errorWidget: (context, url, error) => const CircleAvatar(
      //         //               radius: 40,
      //         //               backgroundImage: NetworkImage("https://cdn-icons-png.flaticon.com/512/6915/6915987.png"),
      //         //             ),
      //         //           ),
      //         //           SizedBox(
      //         //             width: 20,
      //         //           ),
      //         //           Column(
      //         //             children: [
      //         //               SizedBox(
      //         //                 height: 20,
      //         //               ),
      //         //               Container(
      //         //                   height: 30,
      //         //                   width: 200,
      //         //                   child: Text(
      //         //                     "${controller.profileInfo.value.firstName}".toString().capitalizeFirstLetter() + " " + "${controller.profileInfo.value.lastName}".toString().capitalizeFirstLetter(),
      //         //                     style: AppTextStyles.base.w900.s24,
      //         //                     overflow: TextOverflow.clip,
      //         //                   )),
      //         //               Text(
      //         //                 "@${controller.profileInfo.value.username}",
      //         //                 style: AppTextStyles.base.w900.s12,
      //         //               ),
      //         //             ],
      //         //           ),
      //         //         ],
      //         //       ),
      //         //     ),
      //         //   ),
      //         // ),
      //       ],
      //     ),
      //     Positioned.fill(
      //       child: Align(
      //         alignment: Alignment.bottomCenter,
      //         child: Padding(
      //           padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 20),
      //           child: Container(
      //             height: 50,
      //             width: Get.width,
      //             // color: Colors.red,
      //             child: AppButton(
      //               onPressed: () {
      //                 controller.signOutUsers();
      //               },
      //               text: "Sign Out",
      //             ),
      //           ),
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}
