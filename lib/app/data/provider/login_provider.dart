import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../routes/app_pages.dart';
import '../../utils/common.dart';
import '../api/supabase_auth.dart';

class LoginProvider {
  LoginProvider();

  final AuthService _service = AuthService();

  Future<void> signInUsers(email, password) async {
    Common.dismissKeyboard();
    Common.showLoading();
    try {
      await _service.signInUsers(email, password);
    } on AuthException catch (error) {
      Get.back();
      Common.showError(error.message.toString());
    } catch (e) {
      Get.back();
      Common.showError(e.toString());
    }
  }

  Future<void> signInUsersGitHub() async {
    Common.dismissKeyboard();
    Common.showLoading();
    try {
      await _service.signInUsersGitHub();
    } on AuthException catch (error) {
      Get.back();
      Common.showError(error.message.toString());
    } catch (e) {
      Get.back();
      Common.showError(e.toString());
    }
  }
}
