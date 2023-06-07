import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:voicepals/app/data/api/supabase_api.dart';
import 'package:voicepals/app/data/model/profile_information.dart';

import '../../utils/common.dart';

class LookupProvider {
  LookupProvider();

  final ApiService _apiService = ApiService();

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
}
