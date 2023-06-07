import 'package:get/get.dart';
import 'package:voicepals/app/modules/edit_profile_module/edit_profile_binding.dart';
import 'package:voicepals/app/modules/edit_profile_module/edit_profile_page.dart';
import 'package:voicepals/app/modules/settings_module/settings_binding.dart';
import 'package:voicepals/app/modules/settings_module/settings_page.dart';
import 'package:voicepals/app/modules/chat_module/chat_binding.dart';
import 'package:voicepals/app/modules/chat_module/chat_page.dart';
import 'package:voicepals/app/modules/profile_module/profile_binding.dart';
import 'package:voicepals/app/modules/profile_module/profile_page.dart';
import 'package:voicepals/app/modules/lookup_module/lookup_binding.dart';
import 'package:voicepals/app/modules/lookup_module/lookup_page.dart';


import 'package:voicepals/app/modules/register_module/register_binding.dart';
import 'package:voicepals/app/modules/register_module/register_page.dart';
import 'package:voicepals/app/modules/home_module/home_binding.dart';
import 'package:voicepals/app/modules/home_module/home_page.dart';
import 'package:voicepals/app/modules/profile_details_module/profile_details_binding.dart';
import 'package:voicepals/app/modules/profile_details_module/profile_details_page.dart';
import 'package:voicepals/app/modules/login_module/login_binding.dart';
import 'package:voicepals/app/modules/login_module/login_page.dart';
import 'package:voicepals/app/modules/landing_module/landing_binding.dart';
import 'package:voicepals/app/modules/landing_module/landing_page.dart';
import 'package:voicepals/app/modules/splash_module/splash_binding.dart';
import 'package:voicepals/app/modules/splash_module/splash_page.dart';

part './app_routes.dart';

class AppPages {
  AppPages._();
  static final pages = [
    GetPage(
      name: AppRoutes.initial,
      page: () => const SplashPage(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.landing,
      page: () => const LandingPage(),
      binding: LandingBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.profileDetails,
      page: () => const ProfileDetailsPage(),
      binding: ProfileDetailsBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterPage(),
      binding: RegisterBinding(),
    ),
    
    GetPage(
        name: AppRoutes.lookup,
        page: () => const LookupPage(),
        binding: LookupBinding(),
    ),
    GetPage(
        name: AppRoutes.profile,
        page: () => const ProfilePage(),
        binding: ProfileBinding(),
    ),
    GetPage(
        name: AppRoutes.chat,
        page: () => const ChatPage(),
        binding: ChatBinding(),
    ),
    GetPage(
        name: AppRoutes.settings,
        page: () => const SettingsPage(),
        binding: SettingsBinding(),
    ),
    GetPage(
        name: AppRoutes.editProfile,
        page: () => const EditProfilePage(),
        binding: EditProfileBinding(),
    ),
  ];
}
