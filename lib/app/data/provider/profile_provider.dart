import 'dart:developer';
import 'dart:io';

import '../../utils/common.dart';
import '../api/supabase_api.dart';

class ProfileProvider {
  ProfileProvider();

  final ApiService _apiService = ApiService();

  Future<String> createRoom(String other_user_id) async {
    Common.showLoading();
    try {
      var response = _apiService.createRoom(other_user_id);
      return response;
    } catch (e) {
      Common.showError(e.toString());
      throw e;
    }
  }

  Future<String> uploadProfileCover(String filePath, File file, bool isUpdate) async {
    try {
      var response = await _apiService.uploadProfileCover(filePath, file, isUpdate);
      log(response.toString());
      return response;
    } catch (e) {
      Common.showError(e.toString());
      rethrow;
    }
  }

  Future<void> updateUserCover(String imagePath) async {
    try {
      await _apiService.updateCoverPhoto(imagePath: imagePath);
    } catch (e) {
      Common.showError(e.toString());
    }
  }
}
