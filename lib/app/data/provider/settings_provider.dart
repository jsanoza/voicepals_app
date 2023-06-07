import 'package:get/get.dart';
import 'package:voicepals/app/data/api/api_connect.dart';
import 'package:voicepals/app/utils/constants.dart';

import '../../routes/app_pages.dart';
import '../../utils/common.dart';
import '../api/supabase_api.dart';
import '../api/supabase_auth.dart';
import '../model/profile_information.dart';

class SettingsProvider {
  SettingsProvider();
  final AuthService _service = AuthService();
  final ApiService _apiService = ApiService();

  Future<ProfileInformation> getUserInfo() async {
    var response = _apiService.getUserInfo();
    return response;
  }

  Future<void> signOutUsers() async {
    Common.showLoading();
    try {
      await _service.signOutUsers();
    } catch (e) {
      Get.back();
      Common.showError(e.toString());
    }
  }
}
