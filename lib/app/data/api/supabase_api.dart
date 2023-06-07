import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:voicepals/app/data/model/profile_information.dart';
import '../../utils/constants.dart';
import '../model/friend.dart';
import '../model/message.dart';
import '../model/room.dart';

class ApiService extends GetxService {
  final _apiClient = supabase;
  var uuid = Uuid();
  //UPDATE//

  Future<void> deleteRoom({required String roomId}) async {
    try {
      await _apiClient.from('rooms').update({'is_visible': false}).eq('id', roomId).onError((error, stackTrace) {
            log(error.toString());
          });
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> visibleRoom({required String roomId}) async {
    try {
      await _apiClient.from('rooms').update({'is_visible': true}).eq('id', roomId).onError((error, stackTrace) {
            log(error.toString());
          });
    } catch (e) {
      log(e.toString());
    }
  }

  Future<List<Room>> getRoomsUpdated() async {
    final myUserId = supabase.auth.currentUser!.id.toString();
    final response1 = await supabase.from('room_participants').select().order('created_at');
    final response2 = await supabase.from('rooms').select().order('created_at');

    if (response1 != null && response2 != null) {
      final participantMaps = response1 as List<dynamic>;
      final roomMaps = response2 as List<dynamic>;

      final rooms = participantMaps
          .map((participantMap) {
            final roomId = participantMap['room_id'];
            var isVisible;
            roomMaps.forEach((element) {
              if (element['id'] == roomId) {
                isVisible = element['is_visible'];
              }
            });
            return Room.fromRoomParticipants(participantMap, isVisible);
          })
          .where((room) => room.otherUserId != myUserId)
          .toList();

      rooms.sort((a, b) {
        final createdAtA = a.createdAt.toIso8601String();
        final createdAtB = b.createdAt.toIso8601String();
        return createdAtA.compareTo(createdAtB);
      });

      return rooms;
    } else {
      throw Exception('Failed to fetch rooms');
    }
  }

  Future<Message?> subscribeToLastMessageFuture(String roomID) async {
    var myUserId = _apiClient.auth.currentUser!.id.toString();
    final data = await _apiClient.from('messages').select().eq('room_id', roomID).order('created_at');

    if (data.isNotEmpty) {
      final messages = data.map<Message>((row) => Message.fromMap(map: row, myUserId: myUserId)).toList();
      return messages.first;
    } else {
      return null;
    }
  }

  Future<void> addToFavorite({required String otherUserId}) async {
    var myUserId = _apiClient.auth.currentUser!.id.toString();
    List<String> myFavoriteList = <String>[].obs;
    getUserInfo().then(
      (value) {
        value.favoriteList!.forEach((element) {
          myFavoriteList.add(element);
        });
      },
    ).whenComplete(() async {
      myFavoriteList.add(otherUserId);
      try {
        await _apiClient.from('profile_information').update({'favorite_list': myFavoriteList}).eq('profile_id', myUserId).onError((error, stackTrace) {
              log(error.toString());
            });
      } catch (e) {
        log(e.toString());
      }
    });
  }

  Future<void> removeToFavorites({required String otherUserId}) async {
    var myUserId = _apiClient.auth.currentUser!.id.toString();
    List<String> myFavoriteList = <String>[].obs;
    getUserInfo().then(
      (value) {
        value.favoriteList!.forEach((element) {
          myFavoriteList.add(element);
        });
      },
    ).whenComplete(() async {
      myFavoriteList.removeWhere((element) => element == otherUserId);
      try {
        await _apiClient.from('profile_information').update({'favorite_list': myFavoriteList}).eq('profile_id', myUserId).onError((error, stackTrace) {
              log(error.toString());
            });
      } catch (e) {
        log(e.toString());
      }
    });
  }

//////////

  Future<Status> showPendingFriends(String friendId) async {
    var myUserId = _apiClient.auth.currentUser!.id.toString();
    Status status = Status.notPending;
    final data = await _apiClient.from('friends').select().eq('profile_id', myUserId).eq('friend_id', friendId).limit(1);
    final items = (data as List<dynamic>).map((json) => Friend.fromJson(json)).toList();
    if (items.isNotEmpty) {
      if (items.first.isAccepted == "pending") status = Status.pending;
    } else {
      status = Status.notPending;
    }
    return status;
  }

  Future<String> createRoom(String other_user_id) async {
    final data = await _apiClient.rpc('create_new_room', params: {'other_user_id': other_user_id});
    log(data.toString());
    return data as String;
  }

  // Stream<List<Room>> getRoomsStream() {
  //   final myUserId = supabase.auth.currentUser!.id.toString();
  //   return _apiClient.from('room_participants').stream(primaryKey: ['room_id', 'profile_id']).map<List<Room>>((participantMaps) {
  //     final rooms = participantMaps.map(Room.fromRoomParticipants).where((room) => room.otherUserId != myUserId).toList();
  //     return rooms;
  //   });
  // }

  Stream<List<Message>> subscribeToMessagesStream(String roomID) {
    var myUserId = _apiClient.auth.currentUser!.id.toString();
    return _apiClient.from('messages').stream(primaryKey: ['id']).eq('room_id', roomID).order('created_at').map<List<Message>>(
          (data) => data.map<Message>((row) => Message.fromMap(map: row, myUserId: myUserId)).toList(),
        );
  }

  Future<void> sendMessage(String content, String roomID, String content_link) async {
    var myUserId = _apiClient.auth.currentUser!.id.toString();
    final message = Message(
      content: content,
      id: 'new',
      roomId: roomID,
      profileId: myUserId,
      createdAt: DateTime.now(),
      isMine: true,
      contentLink: content_link,
      isRead: false,
      isVisible: true,
    );
    await _apiClient.from('messages').insert(message.toMap());
  }

  Future<void> addFriends(String friendId) async {
    var myUserId = _apiClient.auth.currentUser!.id.toString();

    var existingRecord = await _apiClient.from('friends').select().eq('profile_id', myUserId).eq('friend_id', friendId).limit(1);
    if (existingRecord != null) {
      log("already friend");
    } else {
      await _apiClient.from('friends').upsert({'profile_id': myUserId, 'friend_id': friendId, 'isAccepted': false});
    }
  }

  Future<List<ProfileInformation>> searchItems(String searchTerm) async {
    final response = await _apiClient.from('profile_information').select().ilike('user_name', '%$searchTerm%').execute();
    final items = (response.data as List<dynamic>).map((json) => ProfileInformation.fromJson(json)).toList();
    return items;
  }

  Future<void> updateInitialLogin(String username, String profilePicture, String email) async {
    var myUserId = _apiClient.auth.currentUser!.id.toString();
    await _apiClient.from('profile_information').insert({
      'profile_id': myUserId,
      'user_name': username,
      'profile_picture': profilePicture,
      'email': email,
      'initial_signup': true,
    });
  }

  Future<void> updateUserInfo({
    required String firstName,
    required String lastName,
    required String mobile,
    required String profilePicture,
  }) async {
    var myUserId = _apiClient.auth.currentUser!.id.toString();

    try {
      await _apiClient
          .from('profile_information')
          .update({
            'first_name': firstName,
            'last_name': lastName,
            'mobile': mobile,
            'profile_picture': profilePicture,
            'initial_signup': false,
          })
          .eq('profile_id', myUserId)
          .onError((error, stackTrace) {
            log(error.toString());
          });
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> updateMessagPlayed({required String messageID, required String roomID}) async {
    try {
      await _apiClient.from('messages').update({
        'isRead': true,
        'isPlayed': true,
        'read_time': DateTime.now().toIso8601String(),
      }).eq("id", messageID);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> updateMessageRead({required String messageID, required String roomID}) async {
    try {
      await _apiClient.from('messages').update({
        'isRead': true,
        'read_time': DateTime.now().toIso8601String(),
      }).eq("id", messageID);
      log("Called2");
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> updateMessageVisibility({required String messageID, required String roomID}) async {
    try {
      await _apiClient.from('messages').update({
        'isVisible': false,
      }).eq("id", messageID);
      log("Called2");
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> updateCoverPhoto({required String imagePath}) async {
    var myUserId = _apiClient.auth.currentUser!.id.toString();
    try {
      await _apiClient.from('profile_information').update({'profile_cover': imagePath}).eq('profile_id', myUserId).onError((error, stackTrace) {
            log(error.toString());
          });
    } catch (e) {
      log(e.toString());
    }
  }

  Future<ProfileInformation> getFriendsInfo(String friendId) async {
    final data = await _apiClient.from('profile_information').select().eq('profile_id', friendId);
    var profile = ProfileInformation.fromJson(data[0]);
    return profile;
  }

  Future<ProfileInformation> getUserInfo() async {
    var myUserId = _apiClient.auth.currentUser!.id.toString();
    final data = await _apiClient.from('profile_information').select().eq('profile_id', myUserId);
    var profile = ProfileInformation.fromJson(data[0]);
    return profile;
  }

  Future<String> uploadMessageToStorageBucket(String filePath, File file) async {
    var myUserId = _apiClient.auth.currentUser!.id.toString();
    final uuidForMessage = uuid.v4();

    await _apiClient.storage.from("voicemessages").upload("${myUserId}/${uuidForMessage}", file);
    var response2 = await _apiClient.storage.from("voicemessages").createSignedUrl("${myUserId}/${uuidForMessage}", 999999999999);
    log(response2.toString());
    return response2;
  }

  Future<String> uploadProfilePicture(String filePath, File file, bool isUpdate) async {
    var myUserId = _apiClient.auth.currentUser!.id.toString();
    if (isUpdate) {
      await _apiClient.storage.from("voicemessages").update("${myUserId}/profile.jpg", file);
      var response2 = _apiClient.storage.from("voicemessages").createSignedUrl("${myUserId}/profile.jpg", 99999999999999);
      return response2;
    } else {
      await _apiClient.storage.from("voicemessages").upload("${myUserId}/profile.jpg", file);
      var response2 = _apiClient.storage.from("voicemessages").createSignedUrl("${myUserId}/profile.jpg", 99999999999999);
      return response2;
    }
  }

  Future<String> uploadProfileCover(String filePath, File file, bool isUpdate) async {
    var myUserId = _apiClient.auth.currentUser!.id.toString();
    if (isUpdate) {
      await _apiClient.storage.from("voicemessages").update("${myUserId}/cover.jpg", file);
      var response2 = _apiClient.storage.from("voicemessages").createSignedUrl("${myUserId}/cover.jpg", 99999999999999);
      return response2;
    } else {
      await _apiClient.storage.from("voicemessages").upload("${myUserId}/cover.jpg", file);
      var response2 = _apiClient.storage.from("voicemessages").createSignedUrl("${myUserId}/cover.jpg", 99999999999999);
      return response2;
    }
  }

  @override
  void onInit() {
    super.onInit();
  }
}

enum Status {
  pending,
  notPending,
}
