import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:delayed_widget/delayed_widget.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu_custom/focused_menu.dart';
import 'package:focused_menu_custom/modals.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:octo_image/octo_image.dart';
import 'package:rive/rive.dart';
import 'package:siri_wave/siri_wave.dart';
import 'package:timeago/timeago.dart';
import 'package:video_player/video_player.dart';
import 'package:voice_message_package/voice_message_package.dart';
import 'package:voicepals/app/themes/app_text_theme.dart';
import 'package:voicepals/app/utils/constants.dart';
import '../../../app/modules/chat_module/chat_controller.dart';
import '../../data/model/message.dart';
import '../../data/provider/profile_provider.dart';
import '../../routes/app_pages.dart';
import '../../themes/app_colors.dart';
import '../../utils/common.dart';
import '../../utils/loading.dart';
import '../../utils/widgets/components/clippers.dart';
import '../../utils/widgets/components/custom_image.dart';
import '../../utils/widgets/components/emptystate.dart';
import '../profile_module/profile_controller.dart';

class ChatPage extends GetWidget<ChatController> {
  const ChatPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          title: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Get.put(ProfileController(provider: ProfileProvider()));
                  Get.find<ProfileController>().profileInfo.value = controller.profileInfo.value;
                  Get.toNamed(AppRoutes.profile);
                },
                child: Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(90.0)),
                    border: Border.all(
                      color: AppColors.kPrimaryColor,
                      width: 2.0,
                    ),
                  ),
                  child: CachedNetworkImage(
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
                ),
              ),
              SizedBox(
                width: 16,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "${controller.profileInfo.value.firstName}".toString().capitalizeFirstLetter(),
                        style: AppTextStyles.base.s20,
                      ),
                    ],
                  ),
                  controller.profileInfo.value.isOnline != null
                      ? controller.profileInfo.value.isOnline == true
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
                                  style: AppTextStyles.base.s12,
                                ),
                              ],
                            )
                          : Row(
                              children: [
                                Text(
                                  "Active ${format(controller.profileInfo.value.lastOnline!)}",
                                  style: AppTextStyles.base.s12,
                                ),
                              ],
                            )
                      : Row(children: []),
                ],
              )
            ],
          ),
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(
              LucideIcons.chevronLeft,
            ),
            onPressed: () {
              controller.cancel();
            },
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Container(
                width: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    bottomLeft: Radius.circular(20.0),
                  ),
                  color: Theme.of(context).buttonTheme.colorScheme!.primaryContainer,
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
                                'Send Image',
                                style: AppTextStyles.base.w600,
                              ),
                            ],
                          ),
                          value: 'option1',
                        ),
                        PopupMenuItem(
                          textStyle: AppTextStyles.base,
                          child: Row(
                            children: [
                              Icon(LucideIcons.video),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Send Video',
                                style: AppTextStyles.base.w600,
                              ),
                            ],
                          ),
                          value: 'option2',
                        ),
                      ],
                    ).then((value) {
                      if (value != null) {
                        // Handle menu item selection here
                        switch (value) {
                          case 'option1':
                            controller.showBottomPicker(true);
                            // controller.pickImage(ImageSource.gallery);
                            // Do something for Option 1
                            break;
                          case 'option2':
                            controller.showBottomPicker(false);
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
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: DelayedWidget(
                delayDuration: Duration(milliseconds: 1000),
                child: Container(
                  height: Get.height,
                  width: Get.width,
                  child: StreamBuilder<List<Message>>(
                    stream: controller.roomsStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // Loading state
                        return Center(
                          child: Loading(
                            loadingType: LoadingType.doubleBounce,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        // Error state
                        return Center(child: Text('Error occurred: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        // Empty state
                        return Center(
                            child: EmptyState(
                          message: "Start the conversation now!",
                        ));
                      } else {
                        // Data state
                        final rooms = snapshot.data!;
                        return Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                cacheExtent: 9999999,
                                reverse: true,
                                itemCount: rooms.length,
                                itemBuilder: (context, index) {
                                  final message = rooms[index];
                                  return _ChatBubble(
                                    message: message,
                                    onLongPressEnd: () {
                                      controller.transcribeAudio(message.contentLink.toString());
                                    },
                                    onPlay: ({required String roomID, required String messageID}) {
                                      controller.updateMessagPlayed(roomID: roomID, messageID: messageID);
                                    },
                                    onRemove: ({required String roomID, required String messageID}) {
                                      controller.updateMessageVisibility(roomID: roomID, messageID: messageID);
                                    },
                                    onLoad: ({required String roomID, required String messageID}) {
                                      // controller.updateMessageRead(roomID: roomID, messageID: messageID);
                                    },
                                    onSave: ({required String contentType, required String path}) {
                                      controller.saveFile(contentType, path);
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
            DelayedWidget(
              delayDuration: Duration(milliseconds: 1000),
              animationDuration: Duration(milliseconds: 800),
              animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
              child: GestureDetector(
                onTap: () {
                  controller.isRecording.value = !controller.isRecording.value;
                  controller.triggerNext();
                },
                child: Obx(
                  () => controller.isRecording.value != false
                      ? Container(
                          height: 100,
                          width: Get.width,
                          child: Stack(
                            children: [
                              Center(
                                  child: SiriWave(
                                options: SiriWaveOptions(),
                              )),
                              Center(
                                child: CircleAvatar(
                                  backgroundColor: Get.isDarkMode ? Colors.black : Colors.white,
                                  radius: 25,
                                  child: Icon(
                                    LucideIcons.mic,
                                  ),
                                ),
                              ),
                              Center(
                                child: Image.asset("assets/kcTrial.gif"),
                              ),
                            ],
                          ),
                        )
                      : controller.isSending.value == true
                          ? Container(
                              height: 100,
                              width: Get.width,
                              child: Center(
                                  child: Loading(
                                loadingType: LoadingType.dualRing,
                              )),
                            )
                          : Container(
                              height: 100,
                              width: Get.width,
                              child: Center(
                                child: CircleAvatar(
                                  radius: 25,
                                  child: Icon(
                                    LucideIcons.micOff,
                                  ),
                                ),
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

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({
    Key? key,
    required this.message,
    required this.onLongPressEnd,
    required this.onPlay,
    required this.onRemove,
    required this.onLoad,
    required this.onSave,
  }) : super(key: key);

  final Message message;
  final Function() onLongPressEnd;
  final Function({required String roomID, required String messageID}) onPlay;
  final Function({required String roomID, required String messageID}) onRemove;
  final Function({required String roomID, required String messageID}) onLoad;
  final Function({required String contentType, required String path}) onSave;

  @override
  Widget build(BuildContext context) {
    var viewTime = false.obs;
    message.isMine ? null : onLoad(messageID: message.id, roomID: message.roomId);
    log(message.contentLink.toString());
    List<Widget> chatContents = [
      const SizedBox(width: 10),
      Flexible(
        child: FocusedMenuHolder(
          onPressed: () {
            viewTime.value = !viewTime.value;
          },
          menuItems: [
            FocusedMenuItem(
              title: Row(
                children: [
                  Icon(
                    Icons.transcribe_outlined,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    "Transcribe",
                    style: AppTextStyles.base.blackColor,
                  ),
                ],
              ),
              onPressed: () {
                if (message.content == "Voice") onLongPressEnd();
                if (message.content == "Image") Common.showError("Cannot transcribe images.");
                if (message.content == "Video") Common.showError("Cannot transcribe images.");
              },
            ),
            message.isMine
                ? FocusedMenuItem(
                    title: Row(
                      children: [
                        Icon(LucideIcons.undo),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          "Unsend",
                          style: AppTextStyles.base.blackColor,
                        ),
                      ],
                    ),
                    onPressed: () {
                      onRemove(messageID: message.id, roomID: message.roomId);
                    },
                  )
                : FocusedMenuItem(
                    title: Row(
                      children: [
                        Icon(
                          Icons.delete_forever_outlined,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          "Remove",
                          style: AppTextStyles.base.blackColor,
                        ),
                      ],
                    ),
                    onPressed: () {},
                  ),
          ],
          child: Column(
            crossAxisAlignment: message.isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              message.isVisible == true
                  ? GestureDetector(
                      onTap: () {
                        viewTime.value = !viewTime.value;
                      },
                      child: message.content == "Voice"
                          ? VoiceMessage(
                              onPlay: () {
                                message.isMine ? null : onPlay(messageID: message.id, roomID: message.roomId);
                                log(message.id.toString() + " " + message.roomId.toString());
                              },
                              radius: 20,
                              audioSrc: message.contentLink,
                              me: message.isMine,
                              contactBgColor: Get.isDarkMode ? Colors.white : Theme.of(context).buttonTheme.colorScheme!.primaryContainer,
                              contactCircleColor: Get.isDarkMode ? Theme.of(context).buttonTheme.colorScheme!.primaryContainer : Colors.white,
                              contactPlayIconBgColor: Get.isDarkMode ? Theme.of(context).buttonTheme.colorScheme!.primaryContainer : Colors.white,
                              contactPlayIconColor: Get.isDarkMode ? Colors.white : Colors.black,
                              contactFgColor: Get.isDarkMode ? Theme.of(context).buttonTheme.colorScheme!.primaryContainer : Colors.black,
                              played: message.isPlayed == true ? true : false,
                              meBgColor: Theme.of(context).buttonTheme.colorScheme!.primaryContainer,
                              meFgColor: Colors.black,
                              mePlayIconColor: Colors.white,
                            )
                          : message.content == "Video"
                              ? GestureDetector(
                                  onLongPress: () {
                                    Get.defaultDialog(
                                      titlePadding: EdgeInsets.all(0),
                                      contentPadding: EdgeInsets.all(0),
                                      title: "",
                                      content: Column(
                                        children: [
                                          Container(
                                            height: 300,
                                            width: Get.width,
                                            child: ReusableVideoPlayer(videoUrl: message.contentLink!),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          ListTile(
                                            onTap: () {
                                              onSave(contentType: message.content, path: message.contentLink!);
                                            },
                                            leading: Icon(LucideIcons.download),
                                            title: Text(
                                              "Save to gallery",
                                              style: AppTextStyles.base.s14,
                                            ),
                                          ),
                                          message.isMine
                                              ? ListTile(
                                                  onTap: () {
                                                    onRemove(messageID: message.id, roomID: message.roomId);
                                                    Get.back();
                                                  },
                                                  leading: Icon(LucideIcons.undo),
                                                  title: Text(
                                                    "Unsend",
                                                    style: AppTextStyles.base.s14,
                                                  ),
                                                )
                                              : SizedBox.shrink(),
                                        ],
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 200,
                                    width: 150,
                                    child: ReusableVideoPlayer(videoUrl: message.contentLink!),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.all(Radius.circular(9)),
                                        border: Border.all(
                                          color: Theme.of(context).buttonTheme.colorScheme!.primaryContainer,
                                          width: 3.0,
                                        )),
                                  ),
                                )
                              : GestureDetector(
                                  onLongPress: () {
                                    Get.defaultDialog(
                                      titlePadding: EdgeInsets.all(0),
                                      contentPadding: EdgeInsets.all(0),
                                      title: "",
                                      content: Column(
                                        children: [
                                          CustomImage(
                                            assets: message.contentLink!,
                                            width: Get.width,
                                            height: 300,
                                            isCircle: false,
                                            radius: 0,
                                            fit: BoxFit.contain,
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          ListTile(
                                            onTap: () {
                                              onSave(contentType: message.content, path: message.contentLink!);
                                            },
                                            leading: Icon(LucideIcons.download),
                                            title: Text(
                                              "Save to gallery",
                                              style: AppTextStyles.base.s14,
                                            ),
                                          ),
                                          message.isMine
                                              ? ListTile(
                                                  onTap: () {
                                                    onRemove(messageID: message.id, roomID: message.roomId);
                                                    Get.back();
                                                  },
                                                  leading: Icon(LucideIcons.undo),
                                                  title: Text(
                                                    "Unsend",
                                                    style: AppTextStyles.base.s14,
                                                  ),
                                                )
                                              : SizedBox.shrink(),
                                        ],
                                      ),
                                    );
                                  },
                                  child: CustomImage(
                                    assets: message.contentLink!,
                                    height: 200,
                                    isCircle: false,
                                    radius: 30,
                                    width: 150,
                                  ),
                                ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        color: Get.isDarkMode && message.isMine ? Theme.of(context).buttonTheme.colorScheme!.primaryContainer : Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomLeft: message.isMine ? Radius.circular(20) : const Radius.circular(4),
                          bottomRight: !message.isMine ? Radius.circular(20) : const Radius.circular(4),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16, top: 8, bottom: 8),
                        child: Text(
                          "Removed",
                          style: AppTextStyles.base.italic,
                        ),
                      ),
                    ),
              Obx(() => viewTime.value != false
                  ? Row(
                      mainAxisAlignment: message.isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
                      children: [
                        message.isMine
                            ? Padding(
                                padding: const EdgeInsets.only(left: 3.0),
                                child: Text(
                                  message.isRead == true
                                      ? "Read ${format(
                                          message.createdAt,
                                        )}"
                                      : "",
                                  style: AppTextStyles.base.s12,
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.only(left: 3.0),
                                child: Text(
                                  "Sent ${format(
                                    message.createdAt,
                                  )}",
                                  style: AppTextStyles.base.s12,
                                ),
                              ),
                      ],
                    )
                  : SizedBox.shrink())
            ],
          ),
        ),
      ),
    ];
    if (message.isMine) {
      chatContents = chatContents.reversed.toList();
    }
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: message.isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: chatContents,
            ),
          ],
        ),
      ),
    );
  }
}

class ReusableVideoPlayer extends StatefulWidget {
  final String videoUrl;

  const ReusableVideoPlayer({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _ReusableVideoPlayerState createState() => _ReusableVideoPlayerState();
}

class _ReusableVideoPlayerState extends State<ReusableVideoPlayer> {
  late VideoPlayerController _videoPlayerController;
  late Future<void> _videoPlayerInitialization;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network(widget.videoUrl);
    _videoPlayerInitialization = _videoPlayerController.initialize();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _videoPlayerInitialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return GestureDetector(
            onTap: () {
              setState(() {
                if (_videoPlayerController.value.isPlaying) {
                  _videoPlayerController.pause();
                } else {
                  _videoPlayerController.play();
                }
              });
            },
            child: AspectRatio(
              aspectRatio: _videoPlayerController.value.aspectRatio,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  VideoPlayer(_videoPlayerController),
                  if (!_videoPlayerController.value.isPlaying)
                    Icon(
                      LucideIcons.playCircle,
                      size: 40,
                      color: Theme.of(context).buttonTheme.colorScheme!.primaryContainer,
                    ),
                ],
              ),
            ),
          );
        } else {
          return Center(
            child: Loading(
              loadingType: LoadingType.fadingCircle,
            ),
          );
        }
      },
    );
  }
}
