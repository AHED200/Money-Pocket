import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:intl/intl.dart';
import 'package:money_bank/Model/Language.dart';
import 'package:money_bank/UI/Home.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:money_bank/private.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stack_appodeal_flutter/stack_appodeal_flutter.dart';

bool darkMode = false;
bool temp = darkMode;

bool intersIsReady = false;
bool intersIsShown = false;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await lang();

  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.none) {
    runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xFF219ebc),
        body: Center(
          child: Text(
            'No connection network!',
            textAlign: TextAlign.center,
            softWrap: true,
            style: TextStyle(
              fontSize: 40,
            ),
          ),
        ),
      ),
    ));
  } else {
    ConsentManager.requestConsentInfoUpdate(adKey);

    ConsentManager.setConsentInfoUpdateListener(
        (onConsentInfoUpdated, consent) async {
      var consentStatus = await ConsentManager.getConsentStatus();
      var shouldShow = await ConsentManager.shouldShowConsentDialog();
      ConsentManager.loadConsentForm();
      var isLoaded = await ConsentManager.consentFormIsLoaded();
      ConsentManager.showAsDialogConsentForm();
      ConsentManager.showAsActivityConsentForm();
    }, (onFailedToUpdateConsentInfo, error) => {});

    // bool shouldShow = await ConsentManager.getConsentStatus();
    // if (shouldShow) await Appodeal.requestConsentAuthorization();
    //
    Status consentStatus = await ConsentManager.getConsentStatus();
    bool hasConsent = consentStatus == Status.PERSONALIZED ||
        consentStatus == Status.PARTLY_PERSONALIZED;

    //For enable test mode
    Appodeal.setTesting(true);
    Appodeal.setLogLevel(Appodeal.LogLevelVerbose);
    Appodeal.disableNetwork("admob");
    Appodeal.initialize(
        adKey, [Appodeal.BANNER, Appodeal.INTERSTITIAL], hasConsent);

    Appodeal.setInterstitialCallbacks(
        (onInterstitialLoaded, isPrecache) => {intersIsReady = true},
        (onInterstitialFailedToLoad) => {},
        (onInterstitialShown) => {},
        (onInterstitialShowFailed) => {intersIsReady = false},
        (onInterstitialClicked) => {},
        (onInterstitialClosed) => {
              intersIsShown = true,
              intersIsReady = false,
              Timer(Duration(minutes: 1, seconds: 30), () {
                intersIsReady = true;
              }),
            },
        (onInterstitialExpired) => {});

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
