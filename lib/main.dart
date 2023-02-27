import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:money_bank/Model/Language.dart';
import 'package:money_bank/UI/Home.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool darkMode = false;
bool temp = darkMode;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  await lang();

    runApp(MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Language.currentLanguage == 'AR' ? Locale('ar', '') : Locale('en', ''),
      ],
      theme: darkMode
          //Dark mode
          ? ThemeData(
              brightness: Brightness.dark,
              primaryIconTheme: IconThemeData(color: HexColor('293B5F')),
              appBarTheme: AppBarTheme(
                color: Color(0xFF219ebc),
              ),
              floatingActionButtonTheme: FloatingActionButtonThemeData(
                  backgroundColor: Color(0xff219ebc)))
          //Light mode
          : ThemeData(
              primaryIconTheme: IconThemeData(color: Colors.black54),
              appBarTheme: AppBarTheme(
                  color: Color(0xFFB5EAEA),
                  iconTheme: IconThemeData(color: Colors.black)),
              dialogBackgroundColor: HexColor('B5EAEA'),
            ),
      home: Home(),
      debugShowCheckedModeBanner: false,
    ));
  }


Future<void> lang() async {
  String curntLang = Intl.getCurrentLocale();
  curntLang = curntLang.substring(0, 2);
  curntLang = curntLang.toUpperCase();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (await prefs.containsKey('language') && prefs.containsKey('darkMode')) {
    Language.currentLanguage = prefs.getString('language');
    darkMode = prefs.getBool('darkMode')!;
  } else {
    Language.currentLanguage = curntLang;
    await prefs.setString('language', curntLang);
    await prefs.setBool('darkMode', false);
  }
}