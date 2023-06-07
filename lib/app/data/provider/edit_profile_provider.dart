import 'dart:developer';
import 'dart:io';

import 'package:voicepals/app/data/api/api_connect.dart';
import 'package:voicepals/app/utils/constants.dart';

import '../../utils/common.dart';
import '../api/supabase_api.dart';
import '../api/supabase_auth.dart';

class EditProfileProvider {
  EditProfileProvider();
  final AuthService _authService = AuthService();
  final ApiService _apiService = ApiService();

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

  Future<String> uploadProfilePicture(
    String filePath,
    File file,
  ) async {
    try {
      var response = await _apiService.uploadProfilePicture(filePath, file, true);
      log(response.toString());
      return response;
    } catch (e) {
      Common.showError(e.toString());
      rethrow;
    }
  }
}
