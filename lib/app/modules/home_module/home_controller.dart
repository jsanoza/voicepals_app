import 'dart:async';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:voicepals/app/data/model/profile_information.dart';
import 'package:voicepals/app/data/provider/home_provider.dart';
import 'package:voicepals/app/data/provider/profile_provider.dart';
import 'package:voicepals/app/modules/profile_module/profile_controller.dart';
import 'package:voicepals/app/routes/app_pages.dart';
import '../../data/api/supabase_api.dart';
import '../../data/model/chat_list.dart';
import '../../data/model/event.dart';
import '../../data/model/message.dart';
import '../../data/model/room.dart';
import '../../data/provider/chat_provider.dart';
import '../../utils/constants.dart';
import '../../utils/widgets/components/emptystate.dart';
import '../chat_module/chat_controller.dart';

class HomeController extends GetxController {
  HomeController({this.provider});
  final HomeProvider? provider;

  // final _apiClient = Get.find<SupabaseClient>();
  final _apiClient = supabase;
  final _box = GetStorage();
  var profileInfo = Rx<ProfileInformation>(ProfileInformation());
  var isLoading = false.obs;

  TextEditingController searchController = TextEditingController();
  final searchText = ''.obs;
  final searchResults = <ProfileInformation>[].obs;

  StreamSubscription<List<Room>>? _roomsSubscription;
  final StreamController<List<Room>> _roomsStreamController = StreamController<List<Room>>.broadcast();
  Stream<List<Room>> get roomsStream => _roomsStreamController.stream;

  List<String> notifications = <String>[].obs;
  List<Room> updatedRooms = <Room>[].obs;
  List<Message> lastRoomMessage = <Message>[].obs;
  List<CombinedData> favoriteList = <CombinedData>[].obs;
  List<CombinedData> combinedList = <CombinedData>[].obs;
  List<ProfileInformation> friendsInfo = <ProfileInformation>[].obs;
  var isRoomsLoaded = false.obs;
  var isRoomsEmpty = false.obs;
  var isFaveListEmpty = false.obs;
  List<String> usersFaveList = <String>[].obs;

  ///UPDATE///
  ///
  ///

  deleteRoom({required String roomId}) async {
    isRoomsLoaded.value = false;
    log("called");
    await provider!.archiveRoom(roomId: roomId);
    combinedList.removeWhere((element) => element.id == roomId);
    isRoomsLoaded.value = true;
  }

  visibleRoom({required String roomId}) async {
    isRoomsLoaded.value = false;
    log("called");
    await provider!.visibleRoom(roomId: roomId);
    isRoomsLoaded.value = true;
  }

  getUserInfo() async {
    usersFaveList.clear();
    await provider!.getUserInfo().then((value) {
      if (value.favoriteList != null) {
        usersFaveList.addAll(value.favoriteList!);
      }
    }).whenComplete(() {
      usersFaveList.isNotEmpty ? isFaveListEmpty.value = false : isFaveListEmpty.value = true;
    });
  }

  addToFavorites(String otherUserId) async {
    isRoomsLoaded.value = false;
    await provider!.addToFavorites(otherUserId: otherUserId).whenComplete(() {
      favoriteList.add(combinedList.firstWhere((element) => element.otherUserId == otherUserId));
      combinedList.removeWhere((element) => element.otherUserId == otherUserId);
    });
    isRoomsLoaded.value = true;
    isFaveListEmpty.value = false;
    if (combinedList.isEmpty && favoriteList.isEmpty) isRoomsEmpty.value = true;
  }

  removeToFavorites(String otherUserId) async {
    isRoomsLoaded.value = false;
    await provider!.removeToFavorites(otherUserId: otherUserId).whenComplete(() {
      combinedList.add(favoriteList.firstWhere((element) => element.otherUserId == otherUserId));
      favoriteList.removeWhere((element) => element.otherUserId == otherUserId);
    });
    isRoomsLoaded.value = true;

    if (favoriteList.isEmpty) isFaveListEmpty.value = true;
    if (combinedList.isEmpty && favoriteList.isEmpty) isRoomsEmpty.value = true;
  }

  getRooms() async {
    favoriteList.clear();
    combinedList.clear();
    getUserInfo();
    List<CombinedData> listHolder = <CombinedData>[];
    List<CombinedData> favoriteListHolder = <CombinedData>[];
    await provider!.getRoomsUpdated().then((roomsValue) async {
      await Future.wait(roomsValue.map((element) {
        return provider!.getFriendsInfo(element.otherUserId.toString()).then((friendsValue) async {
          await provider!.getLastMessagePerRoom(element.id).then((value) {
            CombinedData combinedData = CombinedData(
              id: element.id,
              otherUserId: element.otherUserId,
              firstName: friendsValue.firstName!,
              lastName: friendsValue.lastName!,
              profilePicture: friendsValue.profilePicture!,
              createdAt: value?.createdAt,
              profileInfo: friendsValue,
              isRoomVisible: element.isVisible,
            );
            if (usersFaveList.contains(element.otherUserId)) {
              favoriteListHolder.add(combinedData);
            } else {
              listHolder.add(combinedData);
            }
            // listHolder.add(combinedData);
            combinedList = sortCombinedDataDescending(listHolder);
            favoriteList = sortCombinedDataDescending(favoriteListHolder);
          });
        });
      }));
    });
    log("Refreshed.");

    isRoomsLoaded.value = true;
    if (combinedList.isEmpty && favoriteList.isEmpty) isRoomsEmpty.value = true;
    if (combinedList.isNotEmpty || favoriteList.isNotEmpty) isRoomsEmpty.value = false;
  }

  List<CombinedData> sortCombinedDataDescending(List<CombinedData> dataList) {
    dataList.sort((a, b) {
      if (a.createdAt == null && b.createdAt == null) {
        return 0;
      } else if (a.createdAt == null) {
        return 1;
      } else if (b.createdAt == null) {
        return -1;
      } else {
        return b.createdAt!.compareTo(a.createdAt!);
      }
    });
    return dataList;
  }

  ///
  ///

  signOutUsers() async {
    await provider!.signOutUsers();
  }

  searchItems() async {
    final searchTerm = searchText.value;

    if (searchTerm.isEmpty) {
      searchResults.clear();
      return;
    }

    final items = await provider!.searchItems(searchTerm);
    searchResults.value = items;

    Get.bottomSheet(
      Column(
        children: [
          Expanded(
            child: Obx(
              () => searchResults.isNotEmpty
                  ? ListView.builder(
                      itemCount: searchResults.length,
                      itemBuilder: (context, index) {
                        final item = searchResults[index];
                        log(item.profilePicture.toString());
                        Rx<Status> status = Rx<Status>(Status.notPending);
                        provider!.isFriendPending(item.profileId!).then((value) {
                          status.value = value;
                          log(status.value.toString());
                        });

                        return Padding(
                          padding: EdgeInsets.only(top: 20, left: 18, right: 18),
                          child: ListTile(
                            onTap: () {
                              Get.put(ProfileController(provider: ProfileProvider()));
                              Get.find<ProfileController>().profileInfo.value = item;
                              Get.toNamed(AppRoutes.profile);
                              // log(item.profileId.toString());
                              // addRoom(item.profileId.toString());
                            },
                            leading: Container(
                              height: 40,
                              width: 40,
                              child: CachedNetworkImage(
                                imageUrl: item.profilePicture.toString(),
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
                            title: Text(item.username.toString()),
                          ),
                        );
                      },
                    )
                  : Expanded(
                      child: EmptyState(
                        message: "No results found.",
                        image: "assets/animations/kcEmptyState.png",
                      ),
                    ),
            ),
          ),
        ],
      ),
      backgroundColor: Theme.of(Get.context!).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(50.0),
          topLeft: Radius.circular(50.0),
        ),
      ),
    );
  }

  addRoom(String userID) async {
    await provider!.createRoom(userID);
  }

  void clearRoomsStream() {
    isLoading.value = true;
    _roomsStreamController.add([]); // Clear the messages in the stream by adding an empty list
  }

  // subscribeToRoomsStream() {
  //   clearRoomsStream();

  //   _roomsSubscription?.cancel(); // Cancel the previous subscription if it exists
  //   _roomsSubscription = provider!.getRoomsStream().listen((rooms) {
  //     _roomsStreamController.add(rooms);
  //     rooms.forEach((element) async {
  //       isLoading.value = false;
  //       await provider!.getFriendsInfo(element.otherUserId.toString()).then((value) {
  //         friendsInfo.add(value);
  //       });
  //     });
  //   }, onError: (error) {});
  // }

  reload() async {
    isRoomsLoaded.value = false;

    friendsInfo.clear();
    updatedRooms.clear();
    lastRoomMessage.clear();
    getUserInfo();
    getRooms();
    // subscribeToRoomsStream();
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
        if (profileID != myUserId) {
          newChanges(payload);
        }
      },
    ).subscribe();
  }

  newChanges(payload) async {
    EventModel event = EventModel.fromJson(payload);
    var fullNameNotication = "".obs;

    await provider!.getFriendsInfo(event.newMessage!.profileId).then((value) {
      fullNameNotication.value = "${value.firstName} ${value.lastName}";
    });

    notifications.add(event.newMessage!.roomId.toString());
    Get.snackbar(fullNameNotication.value, event.newMessage!.content.toString());
  }

  goToChatPage(String roomId, ProfileInformation profileInformation) async {
    Get.put(ChatController(provider: ChatProvider()));
    Get.find<ChatController>().roomId.value = roomId;
    Get.find<ChatController>().profileInfo.value = profileInformation;
    Get.toNamed(AppRoutes.chat);
    Get.find<ChatController>().subscribeToRoomsStream(roomId);
  }

  // isUserOnline() async {
  //   final myUserId = _apiClient.auth.currentUser!.id.toString();
  //   _apiClient.channel('public:profile_information').on(
  //     RealtimeListenTypes.postgresChanges,
  //     ChannelFilter(),
  //     (payload, [ref]) {
  //       // var profileID = payload['new']['profile_id'].toString();
  //       log(payload.toString() + "🇵🇭");
  //     },
  //   ).subscribe();
  // }

  @override
  void onInit() {
    getUserInfo();
    getRooms();
    // isUserOnline();
    // listenToNewChanges();
    // subscribeToRoomsStream();
    super.onInit();
  }

  @override
  void onClose() {
    // _roomsSubscription?.cancel();
    super.onClose();
  }
}
