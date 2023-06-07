import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:voicepals/app/routes/app_pages.dart';
import 'package:voicepals/app/themes/app_theme.dart';
import 'package:voicepals/app/translations/app_translations.dart';
import 'package:voicepals/app/utils/common.dart';

import 'app/data/api/supabase_auth.dart';
import 'app/modules/splash_module/splash_controller.dart';
import 'app/modules/splash_module/splash_page.dart';
import 'app/themes/theme_service.dart';
import 'app/utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: "https://oegvnolldynzxeulqpqy.supabase.co",
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9lZ3Zub2xsZHluenhldWxxcHF5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODQzODQzMzEsImV4cCI6MTk5OTk2MDMzMX0.dF_fTWfTeL_46wRxkP6GU_IN5-PLx7OSILDgXDrB_xA",
  );

  await GetStorage.init();
  // Get.lazyPut(() => GetStorage());
  Get.lazyPut(() => ThemeService());
  Get.lazyPut(() => AuthService());
  // Get.put(AuthService());

  runApp(MyApp());
}

class AppLifecycleObserver extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.inactive) {
      log("background");
      log("hello there!");
      try {
        await supabase.from('profile_information').update({
          'is_online': false,
          'last_online': DateTime.now().toIso8601String(),
        }).eq("profile_id", supabase.auth.currentUser!.id);
        log("I was called again");
      } catch (e) {
        log(e.toString());
      }
    }

    if (state == AppLifecycleState.resumed) {
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

    if (state == AppLifecycleState.detached) {
      try {
        await supabase.from('profile_information').update({
          'is_online': false,
          'last_online': DateTime.now().toIso8601String(),
        }).eq("profile_id", supabase.auth.currentUser!.id);
        log("I was called again");
      } catch (e) {
        log(e.toString());
      }
    }
  }
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  late AppLifecycleObserver _lifecycleObserver;

  final ThemeService _themeService = Get.find();

  @override
  void initState() {
    super.initState();

    _lifecycleObserver = AppLifecycleObserver();
    WidgetsBinding.instance.addObserver(_lifecycleObserver);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(_lifecycleObserver);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Common.dismissKeyboard(),
      child: Obx(
        () => GetMaterialApp(
          builder: (context, child) => ResponsiveBreakpoints.builder(
            child: child!,
            breakpoints: [
              const Breakpoint(start: 0, end: 480, name: MOBILE),
              const Breakpoint(start: 451, end: 800, name: TABLET),
              const Breakpoint(start: 801, end: 1000, name: DESKTOP),
              const Breakpoint(start: 2460, end: double.infinity, name: '4K'),
            ],
          ),
          getPages: AppPages.pages,
          initialRoute: AppRoutes.initial,
          // home: SplashPage(),
          theme: AppThemes.themeDataLight,
          darkTheme: AppThemes.themeDataDark,
          themeMode: _themeService.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          locale: AppTranslation.locale,
          translationsKeys: AppTranslation.translations,
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
