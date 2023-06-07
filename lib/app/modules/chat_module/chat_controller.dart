import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:rive/rive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:video_player/video_player.dart';
import 'package:voicepals/app/data/model/message.dart';
import 'package:voicepals/app/themes/app_text_theme.dart';
import 'package:voicepals/app/utils/widgets/app_divider/app_divider.dart';
import '../../../app/data/provider/chat_provider.dart';
import '../../data/model/profile_information.dart';
import 'package:record/record.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import '../../utils/common.dart';
import 'package:just_audio/just_audio.dart';

import '../../utils/constants.dart';
import '../home_module/home_controller.dart';

import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class ChatController extends GetxController with GetSingleTickerProviderStateMixin {
  final ChatProvider? provider;
  ChatController({
    this.provider,
  });

  final _apiClient = supabase;
  late Artboard riveArtboard;
  late StateMachineController riveController;
  var asset = "assets/animations/kcBlooming.riv".obs;
  late SMIBool triggerSpeak;
  var isLoaded = false.obs;
  var audioRecorder = Record();
  String? path = "";
  var audioUrl = "".obs;
  StreamSubscription<List<Message>>? _roomsSubscription;
  final StreamController<List<Message>> _roomsStreamController = StreamController<List<Message>>.broadcast();
  final player = AudioPlayer();
  Stream<List<Message>> get roomsStream => _roomsStreamController.stream;
  var uuid = Uuid();
  var profileInfo = Rx<ProfileInformation>(ProfileInformation());
  var roomId = "".obs;
  var canVibrate = false.obs;
  var changeColor = false.obs;
  var isRecording = false.obs;
  var isSending = false.obs;
  var isPlaying = false.obs;
  RxString imagePath = RxString('');

  late VideoPlayerController videoPlayerController;

  void initialize() async {
    canVibrate.value = await Vibrate.canVibrate;
    log(canVibrate.value.toString());
    rootBundle.load(asset.value).then((data) async {
      final file = RiveFile.import(data);
      riveArtboard = file.mainArtboard;
      riveController = StateMachineController.fromArtboard(riveArtboard, 'State Machine 1')!;
      riveArtboard.addController(riveController);
      triggerSpeak = riveController.findSMI('Hover');
      riveController.inputs.forEach((element) {
        log(element.toString());
        log(element.name.toString());
      });
      triggerSpeak.change(false);
      isLoaded.value = true;
    });
    if (await audioRecorder.hasPermission()) {
      await audioRecorder.isEncoderSupported(
        AudioEncoder.wav,
      );
    }
  }

  saveFile(String contentType, String path) async {
    log(path.toString());
    switch (contentType) {
      case "Video":
        downloadVideo(path).then((value) {
          log("Saved");
          Get.back();
          Common.showError("Video saved to gallery.");
        });
        break;
      case "Image":
        downloadImage(path).then((value) {
          log("Saved");
          Get.back();
          Common.showError("Image saved to gallery.");
        });
        break;

      default:
        log("invalid entry");
    }
  }

  Future<void> downloadImage(String imageUrl) async {
    // Send a GET request to download the image
    http.Response response = await http.get(Uri.parse(imageUrl));

    // Get the external storage directory (gallery path)
    Directory? storageDir = await getExternalStorageDirectory();
    String galleryPath = storageDir!.path;

    // Generate a unique filename for the downloaded image
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    String imagePath = '$galleryPath/$fileName.jpg';

    // Write the response content to the file
    File file = File(imagePath);
    await file.writeAsBytes(response.bodyBytes);

    // Save the image to the gallery
    await GallerySaver.saveImage(imagePath, albumName: 'VoicePals');

    // Show a message or perform any desired action after successful download
  }

  Future<void> downloadVideo(String videoUrl) async {
    // Send a GET request to download the video
    http.Response response = await http.get(Uri.parse(videoUrl));

    // Get the external storage directory (gallery path)
    Directory? storageDir = await getExternalStorageDirectory();
    String galleryPath = storageDir!.path;

    // Generate a unique filename for the downloaded video
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    String videoPath = '$galleryPath/$fileName.mp4';

    // Write the response content to the file
    File file = File(videoPath);
    await file.writeAsBytes(response.bodyBytes);

    // Save the video to the gallery
    await GallerySaver.saveVideo(videoPath, albumName: 'VoicePals');

    // Show a message or perform any desired action after successful download
  }

  showBottomPicker(bool isImage) async {
    Get.bottomSheet(
        Container(
          height: 150,
          width: Get.width,
          child: Column(
            children: [
              ListTile(
                onTap: () {
                  pickImage(ImageSource.gallery, isImage);
                },
                leading: Icon(LucideIcons.album),
                title: Text(
                  "Gallery",
                  style: AppTextStyles.base,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AppDivider(),
              ),
              ListTile(
                onTap: () {
                  pickImage(ImageSource.camera, isImage);
                },
                leading: Icon(LucideIcons.camera),
                title: Text(
                  "Camera",
                  style: AppTextStyles.base,
                ),
              )
            ],
          ),
        ),
        backgroundColor: Theme.of(Get.context!).buttonTheme.colorScheme!.primaryContainer);
  }

  playVideo() async {
    if (videoPlayerController.value.isPlaying) {
      videoPlayerController.pause();
      isPlaying.value = false;
    } else {
      videoPlayerController.play();
      isPlaying.value = true;
    }
  }

  pickImage(ImageSource source, bool isImage) async {
    final pickedImage = isImage ? await ImagePicker().pickImage(source: source) : await ImagePicker().pickVideo(source: source);
    if (pickedImage != null) {
      imagePath.value = pickedImage.path;
      log(imagePath.value.toString());
      videoPlayerController = VideoPlayerController.file(
        File(imagePath.value),
      )..initialize();

      Get.defaultDialog(
        titlePadding: EdgeInsets.all(0),
        contentPadding: EdgeInsets.all(0),
        title: "",
        content: Padding(
          padding: const EdgeInsets.only(bottom: 0.0),
          child: Container(
            height: 300,
            width: Get.width,
            child: Column(
              children: [
                Expanded(
                  child: isImage
                      ? Image.file(
                          File(
                            imagePath.value.toString(),
                          ),
                          fit: BoxFit.contain,
                        )
                      : Stack(
                          children: [
                            AspectRatio(
                              aspectRatio: videoPlayerController.value.aspectRatio,
                              child: VideoPlayer(videoPlayerController),
                            ),
                            Obx(
                              () => IconButton(
                                onPressed: () {
                                  playVideo();
                                },
                                icon: Icon(
                                  !isPlaying.value ? LucideIcons.playCircle : LucideIcons.pauseCircle,
                                  size: 30,
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
                SizedBox(
                  height: 20,
                ),
                CircleAvatar(
                  radius: 30,
                  child: IconButton(
                    onPressed: () {
                      isImage ? sendImage("Image") : sendImage("Video");
                    },
                    icon: Icon(LucideIcons.send),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  sendImage(String contentType) async {
    uploadVoiceMessage(imagePath.value, contentType);
    isSending.value = true;
    listenToNewChanges();
    Get.close(2);
  }

  changeIsSending() async {
    if (isSending.value == false) {
      unsubscribeToChanges();
    }
  }

  unsubscribeToChanges() async {
    _apiClient
        .channel('public:messages')
        .on(
          RealtimeListenTypes.postgresChanges,
          ChannelFilter(
            event: '*',
            schema: 'public',
            table: 'messages',
          ),
          (payload, [ref]) {},
        )
        .unsubscribe();
  }

  listenToNewChanges() async {
    final myUserId = _apiClient.auth.currentUser!.id.toString();
    _apiClient.channel('public:messages').on(
      RealtimeListenTypes.postgresChanges,
      ChannelFilter(
        event: '*',
        schema: 'public',
        table: 'messages',
      ),
      (payload, [ref]) {
        var profileID = payload['new']['profile_id'].toString();
        if (profileID == myUserId) {
          isSending.value = false;
          unsubscribeToChanges();
        }
      },
    ).subscribe();
  }

  void triggerNext() {
    if (triggerSpeak.value == true) {
      triggerSpeak.change(false);
      onRecordStop();
    } else {
      triggerSpeak.change(true);
      onRecordStart();
    }
  }

  onRecordStop() async {
    path = await audioRecorder.stop();
    if (canVibrate.value) Vibrate.feedback(FeedbackType.success);
    if (path != null) {
      audioRecorder.dispose();
      if (GetPlatform.isIOS) {
        Uri uri = Uri.parse(path!);
        String pathForIos = uri.path;
        uploadVoiceMessage(pathForIos, "Voice");
        isSending.value = true;
        listenToNewChanges();
      } else {
        uploadVoiceMessage(path!, "Voice");
        isSending.value = true;
        listenToNewChanges();
      }
    }
  }

  onRecordStart() async {
    audioRecorder = Record();
    log(canVibrate.value.toString());
    if (canVibrate.value) Vibrate.feedback(FeedbackType.success);

    try {
      if (await audioRecorder.hasPermission()) {
        await audioRecorder.isEncoderSupported(
          AudioEncoder.wav,
        );
        await audioRecorder.start().then((value) {});
      }
    } catch (e) {
      log(e.toString());
    }
  }

  transcribeAudio(String path) async {
    Common.showLoading();
    try {
      await provider!.transcribeAudio(path).then((transcription) async {
        Get.back();
        log(transcription.toString());
        Get.dialog(
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(Get.context!).cardColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Material(
                      child: Column(
                        children: [
                          SizedBox(
                              height: 200,
                              width: Get.width,
                              child: AnimatedTextKit(
                                animatedTexts: [
                                  TypewriterAnimatedText(
                                    transcription,
                                    textStyle: AppTextStyles.base,
                                    speed: const Duration(milliseconds: 10),
                                  ),
                                ],
                                totalRepeatCount: 1,
                                pause: const Duration(milliseconds: 1000),
                                displayFullTextOnTap: true,
                                stopPauseOnTap: true,
                                isRepeatingAnimation: false,
                              )),

                          const SizedBox(height: 20),
                          //Buttons
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      });
    } catch (e) {
      Common.showError(e.toString());
      Get.back();
    }
  }

  uploadVoiceMessage(String path, String contentType) async {
    File file = File(path);
    var response = await provider!.uploadMessageToStorageBucket(path, file);
    await sendMessage(contentType, response);
    log(response.toString());
  }

  updateMessagPlayed({required String roomID, required String messageID}) async {
    await provider!.updateMessagPlayed(messageID: messageID, roomID: roomID);
  }

  // updateMessageRead({required String roomID, required String messageID}) async {
  //   await provider!.updateMessageRead(messageID: messageID, roomID: roomID);
  // }

  updateMessageVisibility({required String roomID, required String messageID}) async {
    await provider!.updateMessageVisibility(messageID: messageID, roomID: roomID);
  }

  clearRoomsStream() {
    _roomsStreamController.addError([]); // Clear the messages in the stream by adding an empty list
  }

  subscribeToRoomsStream(String roomID) {
    clearRoomsStream();
    _roomsSubscription?.cancel(); // Cancel the previous subscription if it exists
    _roomsSubscription = provider!.getRoomsStream(roomID).listen((rooms) {
      _roomsStreamController.add(rooms);
    }, onError: (error) {
      // Handle error
    });
  }

  sendMessage(String content, String content_link) async {
    await provider!.sendMessage(content, roomId.value, content_link);
    log("Sent");
  }

  // customSendMessage(String content, String roomID, String content_link)async {
  //   await provider!.sendMessage(content, roomID);
  //   log("Sent!");
  // }

  cancel() async {
    Get.back();
    // Get.find<HomeController>().reload();
  }

  load() async {
    // subscribeToRoomsStream(roomId.value);
    log("callsed");
  }

  @override
  void onInit() {
    initialize();
    // subscribeToRoomsStream(roomId.value);
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
