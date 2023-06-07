import 'dart:developer';
import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:voicepals/app/data/model/profile_information.dart';

import '../../utils/common.dart';
import '../api/supabase_api.dart';
import '../api/supabase_auth.dart';

class ProfileDetailsProvider {
  ProfileDetailsProvider();

  final AuthService _authService = AuthService();
  final ApiService _apiService = ApiService();

  Future<User?> getUserMetadata() async {
    return await _authService.getUserMetadata();
  }

  Future<ProfileInformation> getUserInfo() async {
    return await _apiService.getUserInfo();
  }

  Future<void> updateUserInfo(
    String firstName,
    String lastName,
    String mobile,
    String profilePicture,
  ) async {
    try {
      await _apiService.updateUserInfo(
        firstName: firstName,
        lastName: lastName,
        mobile: mobile,
        profilePicture: profilePicture,
      );
    } catch (e) {
      Common.showError(e.toString());
    }
  }

  Future<void> updateUserInfoFromMetaData(String username, String email) async {
    try {
      await _apiService.updateInitialLogin(username, "", email);
    } catch (e) {
      Common.showError(e.toString());
    }
  }

  Future<String> uploadProfilePicture(String filePath, File file) async {
    try {
      var response = await _apiService.uploadProfilePicture(filePath, file, false);
      log(response.toString());
      return response;
    } catch (e) {
      Common.showError(e.toString());
      rethrow;
    }
  }
}
