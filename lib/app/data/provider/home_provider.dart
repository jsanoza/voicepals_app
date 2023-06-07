import 'dart:async';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:voicepals/app/data/api/supabase_api.dart';
import 'package:voicepals/app/data/model/profile_information.dart';

import '../../routes/app_pages.dart';
import '../../utils/common.dart';
import '../api/supabase_auth.dart';
import '../model/friend.dart';
import '../model/message.dart';
import '../model/room.dart';

class HomeProvider {
  HomeProvider();
  final AuthService _service = AuthService();
  final ApiService _apiService = ApiService();

  ///UPDATE////
  ///
  ///

  Future<void> archiveRoom({required String roomId}) async {
    try {
      await _apiService.deleteRoom(roomId: roomId);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> visibleRoom({required String roomId}) async {
    try {
      await _apiService.visibleRoom(roomId: roomId);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<List<Room>> getRoomsUpdated() async {
    try {
      return await _apiService.getRoomsUpdated();
    } catch (e) {
      Common.showError(e.toString());
      throw (e);
    }
  }

  Future<Message?> getLastMessagePerRoom(String roomId) async {
    try {
      return await _apiService.subscribeToLastMessageFuture(roomId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addToFavorites({required String otherUserId}) async {
    try {
      return await _apiService.addToFavorite(otherUserId: otherUserId);
    } catch (e) {}
  }

  Future<void> removeToFavorites({required String otherUserId}) async {
    try {
      return await _apiService.removeToFavorites(otherUserId: otherUserId);
    } catch (e) {}
  }

  ///

  Future<void> signOutUsers() async {
    Common.showLoading();
    try {
      await _service.signOutUsers();
    } catch (e) {
      Get.back();
      Common.showError(e.toString());
    }
  }

  // Stream<List<Room>> getRoomsStream() {
  //   return _apiService.getRoomsStream();
  // }

  Future<List<ProfileInformation>> searchItems(String items) async {
    Common.dismissKeyboard();
    Common.showLoading();
    try {
      var searchItems = await _apiService.searchItems(items);
      Get.back();
      return searchItems;
    } on AuthException catch (error) {
      Get.back();
      Common.showError(error.message.toString());
      throw (error);
    } catch (e) {
      Get.back();
      Common.showError(e.toString());
      throw (e);
    }
  }

  Future<Status> isFriendPending(String friendId) async {
    try {
      var response = await _apiService.showPendingFriends(friendId);
      return response;
    } catch (e) {
      Common.showError(e.toString());
      throw e;
    }
  }
  // Future<User?> getSignedInUsers() async {
  //   try {
  //     var response = await _service.getSignedInUsers();
  //     return response;
  //   } catch (e) {
  //     Common.showError(e.toString());
  //     throw (e);
  //   }
  // }

  // Future<void> getUsers() async {
  //   Common.showLoading();
  //   try {
  //     var response = _apiService.getUsers("1856527a-d6bb-4ad3-8d3c-3e17cf66a656");
  //     log(response.toString());
  //     Get.back();
  //   } catch (e) {
  //     Common.showError(e.toString());
  //   }
  // }

  Future<ProfileInformation> getFriendsInfo(String friendId) async {
    var response = _apiService.getFriendsInfo(friendId);
    return response;
  }

  Future<ProfileInformation> getUserInfo() async {
    var response = _apiService.getUserInfo();
    return response;
  }

  Future<void> addFriends(String friendId) async {
    Common.showLoading();
    try {
      var response = _apiService.addFriends(friendId);
      log(response.toString());
      Get.back();
    } catch (e) {
      Common.showError(e.toString());
    }
  }

  Future<void> createRoom(String other_user_id) async {
    Common.showLoading();
    try {
      var response = _apiService.createRoom(other_user_id);
      log(response.toString());
    } catch (e) {
      Common.showError(e.toString());
      throw e;
    }
  }

  // Future<void> updateUserInfo() async {
  //   Common.showLoading();
  //   try {
  //     var response = _apiService.updateUserInfo();
  //     log(response.toString());
  //     Get.back();
  //   } catch (e) {
  //     Common.showError(e.toString());
  //   }
  // }

  // Future<void> showFriends() async {
  //   Common.showLoading();
  //   try {
  //     var response = _apiService.createRoom();
  //     // var response = _apiService.getRooms();
  //     log(response.toString());
  //     // return _apiService.rawRoomsSubscription;
  //   } catch (e) {
  //     Common.showError(e.toString());
  //     throw e;
  //   }
  // }
}
