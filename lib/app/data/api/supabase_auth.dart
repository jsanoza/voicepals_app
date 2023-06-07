import 'dart:developer';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:uni_links/uni_links.dart';
import 'package:voicepals/app/data/api/supabase_api.dart';
import 'package:voicepals/app/modules/splash_module/splash_page.dart';

import '../../routes/app_pages.dart';
import '../../utils/constants.dart';

class AuthService extends GetxService {
  // final _authClient = Get.find<SupabaseClient>();
// Supabase.initialize(url: url, anonKey: anonKey)
  // SupabaseClient _authClient = Supabase.instance.client;
  final _apiService = ApiService();
  final _box = GetStorage();

  final _authClient = supabase;
  @override
  Future<void> onInit() async {
    // _authClient = Supabase.instance.client;
    await initialize();
    super.onInit();
  }

  Future<void> refreshSession() async {
    await _authClient.auth.refreshSession();
  }

  Future<void> initialize() async {
    _authClient.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;

      // final session = data.session;
      if (session != null) {
        Get.offAllNamed(AppRoutes.lookup);
      }
      if (event.name == AuthChangeEvent.signedOut) {
        Get.offAllNamed(AppRoutes.landing);
      }

      if (event.name == AuthChangeEvent.signedIn) {
        Get.offAllNamed(AppRoutes.initial);
      }
    });
  }

  Future<void> signUpUsers(String email, String password, String username) async {
    final response = await _authClient.auth.signUp(email: email, password: password, data: {
      'user_name': username,
    });
    _apiService.updateInitialLogin(username, "", email);
    await _box.write('session', response.session!.persistSessionString);
  }

  Future<void> signInUsers(String email, String password) async {
    final response = await _authClient.auth.signInWithPassword(email: email, password: password);

    await _box.write('session', response.session!.persistSessionString);
    Get.offAll(SplashPage());
    // await initialize();
  }

  Future<User?> getUserMetadata() async {
    final User? user = _authClient.auth.currentUser;
    log(user!.id.toString());
    return user;
  }

  Future<Session> getCurrentSession() async {
    return _authClient.auth.currentSession!;
  }

  Future<void> signOutUsers() async {
    await _authClient.auth.signOut();
    await _box.remove("session");
    Get.offAllNamed(AppRoutes.landing);
    // Get.offAllNamed(AppRoutes.landing);
  }

  Future<void> recoverSession(String fromBox) async {
    await _authClient.auth.recoverSession(fromBox);
    await _authClient.auth.refreshSession();
  }

  Future<void> signInUsersGitHub() async {
    await _authClient.auth.signInWithOAuth(Provider.github, redirectTo: "io.supabase.flutterquickstart://login-callback/");
    // initUniLinks();
    await initialize();
  }

  Future<void> getSessionFromUrl(String url) async {
    AuthSessionUrlResponse response = await _authClient.auth.getSessionFromUrl(Uri.parse(url));
    await _box.write('session', response.session.persistSessionString);
    // try {
    //   await _apiService.getUserInfo();
    // } catch (e) {
    //   _apiService.updateInitialLogin(response.session.user.userMetadata!['user_name'].toString(), "", response.session.user.email.toString());
    // }
  }

  // Future<void> initUniLinks() async {
  //   uriLinkStream.listen((Uri? uri) {
  //     if (uri != null) {
  //       getSessionFromUrl(uri.toString());
  //       // Get.offAllNamed(AppRoutes.home);
  //       Get.offAll(SplashPage());
  //     }
  //   }, onError: (err) {});

  //   // final initialUri = await getInitialUri();
  //   // if (initialUri != null) {
  //   //   getSessionFromUrl(initialUri.toString());
  //   // }
  // }

  bool get isAuthenticated => _authClient.auth.currentUser != null;
}
