import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'controllers/auth_controller.dart';
import 'controllers/language_controller.dart';
import 'controllers/data_controller.dart';
import 'screens/splash_screen.dart';
import 'utils/theme.dart';
import 'utils/app_localizations.dart';

void main() {
  runApp(TutorLinkApp());
}

class TutorLinkApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.put(AuthController());
    Get.put(LanguageController());
    Get.put(DataController());

    return GetMaterialApp(
      title: 'TutorLink',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: SplashScreen(),
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en', 'US'),
        Locale('ar', 'SA'),
      ],
      locale: Get.find<LanguageController>().currentLocale,
      fallbackLocale: Locale('en', 'US'),
    );
  }
}