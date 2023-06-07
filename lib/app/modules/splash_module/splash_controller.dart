import 'dart:developer';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../app/data/provider/splash_provider.dart';
import '../../data/api/supabase_api.dart';
import '../../data/api/supabase_auth.dart';
import '../../routes/app_pages.dart';
import '../../utils/constants.dart';

class SplashController extends GetxController {
  final SplashProvider? provider;
  SplashController({this.provider});

  bool _redirectCalled = false;
  AuthService _authService = AuthService();
  ApiService _apiService = ApiService();
  @override
  void onReady() {
    super.onReady();
    _redirect();
  }

  Future<void> _redirect() async {
    log(_redirectCalled.toString());
    _redirectCalled = true;
    final session = supabase.auth.currentSession;
    log(session.toString());
    if (session != null) {
      await _apiService.getUserInfo().then((value) async {
        if (value.isInitial == true) {
          Get.offAllNamed(AppRoutes.profileDetails);
        } else {
          Get.offAllNamed(AppRoutes.lookup);
          try {
            await supabase.from('profile_information').update({
              'is_online': true,
              'last_online': DateTime.now().toIso8601String(),
            }).eq("profile_id", supabase.auth.currentUser!.id);
            log("I was called again");
          } catch (e) {
            log(e.toString());
          }
        }
      }).onError((error, stackTrace) {
        Get.offAllNamed(AppRoutes.lookup);
      });
    } else {
      log("no session going to landing");
      Get.offAllNamed(AppRoutes.landing);
    }
    // Get.offAllNamed(AppRoutes.lookup);
  }
}
