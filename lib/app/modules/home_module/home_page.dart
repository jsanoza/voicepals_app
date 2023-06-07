import 'dart:developer';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:delayed_widget/delayed_widget.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:focused_menu_custom/focused_menu.dart';
import 'package:focused_menu_custom/modals.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timeago/timeago.dart';
import 'package:voicepals/app/modules/home_module/home_controller.dart';
import 'package:voicepals/app/themes/app_text_theme.dart';
import 'package:voicepals/app/utils/constants.dart';
import 'package:voicepals/app/utils/widgets/components/emptystate.dart';

import '../../utils/widgets/components/custom_image.dart';

class HomePage extends GetWidget<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ErrorWidget.builder = (FlutterErrorDetails details) => SizedBox.shrink();
    return Scaffold(
      backgroundColor: Theme.of(context).buttonTheme.colorScheme!.primaryContainer,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        actions: [
          Stack(
            children: [
              Container(
                width: Get.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 14.0),
                          child: Text(
                            "Voice Pals",
                            style: AppTextStyles.base.w900.s24,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: Get.width,
                padding: const EdgeInsets.only(left: 8.0, right: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AnimSearchBar(
                      key: key,
                      autoFocus: true,
                      color: Colors.transparent,
                      boxShadow: false,
                      searchIconColor: Get.isDarkMode ? Colors.white : Colors.black,
                      onSubmitted: (p0) {
                        controller.searchText.value = p0;
                        controller.searchItems();
                      },
                      width: Get.width - 20,
                      textController: controller.searchController,
                      onSuffixTap: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Obx(() => controller.isFaveListEmpty.value == false
              ? Container(
                  height: 130,
                  width: Get.width,
                  child: Obx(
                    () => controller.isRoomsLoaded.value == true
                        ? Column(
                            children: [
                              SizedBox(
                                height: 4,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    "Favorites",
                                    style: AppTextStyles.base,
                                  ),
                                ],
                              ),
                              Container(
                                height: 100,
                                width: Get.width,
                                child: DelayedWidget(
                                  animation: DelayedAnimations.SLIDE_FROM_RIGHT,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListView.builder(
                                      padding: EdgeInsets.all(0),
                                      itemCount: controller.favoriteList.length,
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      itemBuilder: ((context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.only(left: 4.0),
                                          child: FocusedMenuHolder(
                                            onPressed: () {},
                                            menuItems: [
                                              FocusedMenuItem(
                                                  title: Text(
                                                    "Remove",
                                                    style: AppTextStyles.base.blackColor,
                                                  ),
                                                  trailingIcon: Icon(
                                                    LucideIcons.trash,
                                                    color: Colors.black,
                                                  ),
                                                  onPressed: () {
                                                    controller.removeToFavorites(controller.favoriteList[index].otherUserId);
                                                  }),
                                            ],
                                            child: GestureDetector(
                                              onTap: () {
                                                controller.notifications.removeWhere((element) => element == controller.favoriteList[index].id);
                                                controller.goToChatPage(controller.favoriteList[index].id, controller.favoriteList[index].profileInfo);
                                              },
                                              child: Container(
                                                child: CachedNetworkImage(
                                                  imageUrl: controller.favoriteList[index].profilePicture.toString(),
                                                  imageBuilder: (context, imageProvider) => Container(
                                                    width: 60.0,
                                                    height: 60.0,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                                                    ),
                                                  ),
                                                  placeholder: (context, url) => CircularProgressIndicator(),
                                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Padding(
                            padding: const EdgeInsets.only(left: 24.0, right: 24, bottom: 10, top: 10),
                            child: Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                  color: Theme.of(context).splashColor,
                                ),
                              ),
                            ),
                          ),
                  ),
                )
              : SizedBox.shrink()),
          Expanded(
            child: DelayedWidget(
              delayDuration: Duration(milliseconds: 600),
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
                child: Column(
                  children: [
                    SizedBox(
                      height: 8,
                    ),
                    Expanded(
                      child: EasyRefresh(
                        onRefresh: controller.reload,
                        child: Container(
                            height: Get.height,
                            width: Get.width,
                            child: Obx(
                              () => controller.isRoomsLoaded.value == true
                                  ? Obx(() => controller.isRoomsEmpty.value == false
                                      ? Container(
                                          child: ListView.builder(
                                          itemCount: controller.combinedList.length,
                                          itemBuilder: ((context, index) {
                                            return controller.combinedList[index].isRoomVisible == true || controller.combinedList[index].isRoomVisible == null
                                                ? Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Slidable(
                                                        endActionPane: ActionPane(
                                                          motion: ScrollMotion(),
                                                          children: [
                                                            SlidableAction(
                                                              flex: 1,
                                                              onPressed: (BuildContext context) {
                                                                controller.deleteRoom(roomId: controller.combinedList[index].id.toString());
                                                              },
                                                              backgroundColor: Colors.red,
                                                              foregroundColor: Colors.white,
                                                              icon: LucideIcons.trash,
                                                              label: 'Remove',
                                                            ),
                                                          ],
                                                        ),
                                                        child: FocusedMenuHolder(
                                                          onPressed: () {},
                                                          menuItems: [
                                                            FocusedMenuItem(
                                                              onPressed: () {
                                                                controller.addToFavorites(controller.combinedList[index].otherUserId.toString());
                                                              },
                                                              title: Text(
                                                                "Add to favorites",
                                                                style: AppTextStyles.base,
                                                              ),
                                                              trailingIcon: Icon(
                                                                LucideIcons.plusCircle,
                                                                color: Colors.black,
                                                              ),
                                                            ),
                                                          ],
                                                          child: ListTile(
                                                            // onLongPress: () {
                                                            //   log(controller.combinedList[index].otherUserId.toString());
                                                            //   controller.addToFavorites(controller.combinedList[index].otherUserId.toString());
                                                            // },
                                                            onTap: () {
                                                              controller.notifications.removeWhere((element) => element == controller.combinedList[index].id);
                                                              controller.goToChatPage(controller.combinedList[index].id, controller.combinedList[index].profileInfo);
                                                            },
                                                            dense: true,
                                                            visualDensity: VisualDensity.adaptivePlatformDensity,
                                                            leading: CustomImage(
                                                              assets: controller.combinedList[index].profilePicture.toString(),
                                                              height: 50,
                                                              isCircle: true,
                                                              radius: 90,
                                                              width: 50,
                                                              fit: BoxFit.cover,
                                                            ),
                                                            title: Text(
                                                              "${"${controller.combinedList[index].firstName}".toString().capitalizeFirstLetter()} ${"${controller.combinedList[index].lastName}".toString().capitalizeFirstLetter()}",
                                                              style: AppTextStyles.base.s16,
                                                            ),
                                                            subtitle: controller.combinedList[index].profileInfo.isOnline != null
                                                                ? controller.combinedList[index].profileInfo.isOnline == true
                                                                    ? Row(
                                                                        children: [
                                                                          Icon(
                                                                            Icons.circle,
                                                                            color: Colors.green,
                                                                            size: 10,
                                                                          ),
                                                                          SizedBox(
                                                                            width: 8,
                                                                          ),
                                                                          Text(
                                                                            "Active now",
                                                                            style: AppTextStyles.base,
                                                                          ),
                                                                        ],
                                                                      )
                                                                    : Row(
                                                                        children: [
                                                                          Text(
                                                                            "Active ${format(controller.combinedList[index].profileInfo.lastOnline!)}",
                                                                            style: AppTextStyles.base,
                                                                          ),
                                                                        ],
                                                                      )
                                                                : Row(children: []),
                                                            trailing: Column(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                Text(
                                                                  controller.combinedList[index].createdAt != null ? format(controller.combinedList[index].createdAt!, locale: 'en_short') : '-',
                                                                  style: AppTextStyles.base,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )),
                                                  )
                                                : SizedBox.shrink();
                                          }),
                                        ))
                                      : EmptyState(message: "uh-oh"))
                                  : Container(
                                      height: Get.height,
                                      width: Get.width,
                                      child: ListView.builder(
                                        itemCount: 10,
                                        itemBuilder: ((context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.only(left: 24.0, right: 24, top: 10),
                                            child: Shimmer.fromColors(
                                              baseColor: Colors.grey[300]!,
                                              highlightColor: Colors.grey[100]!,
                                              child: Container(
                                                height: 90,
                                                width: Get.width,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                                  color: Theme.of(context).splashColor,
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                      ),
                                    ),
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
