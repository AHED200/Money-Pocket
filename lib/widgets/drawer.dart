import 'package:flash/flash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:money_bank/Model/Language.dart';
import 'package:money_bank/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {


  @override
  Widget build(BuildContext context) {
    final InAppReview inAppReview = InAppReview.instance;
    TextStyle style = TextStyle(
      color: Colors.white,
      fontSize: 17,
      fontWeight: FontWeight.w600,
      fontFamily: 'Inter',
    );
    return Drawer(
      child: Container(
        color: HexColor('219ebc'),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        Language.language['language'].toString(),
                        style: style,
                      ),
                      trailing: DropdownButton<String>(
                        value: Language.currentLanguage == 'EN'
                            ? 'English'
                            : 'عربي',
                        style: style,
                        onChanged: (value) async {
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          showToast1();
                          setState(() {
                            if (value == 'عربي') {
                              Language.currentLanguage = 'AR';
                              prefs.setString('language', 'AR');
                            } else {
                              Language.currentLanguage = 'EN';
                              prefs.setString('language', 'EN');
                            }
                          });
                        },
                        items: <String>[
                          'عربي',
                          'English',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(color:darkMode?Colors.white:Colors.black),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        Language.language['darkMode'].toString(),
                        style: style,
                      ),
                      trailing: CupertinoSwitch(
                        value: temp,
                        onChanged: (bool value) async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.setBool('darkMode', value);
                          temp = value;
                          if (temp != darkMode) showToast1();
                        },
                      ),
                    ),
                    //Rate the application
                    ListTile(
                      title: Text(
                        Language.language['rate'].toString(),
                        style: style,
                      ),
                      trailing: Icon(Icons.star_outlined, color: Colors.white,),
                      onTap: ()async{
                        if (await inAppReview.isAvailable()) {
                          inAppReview.requestReview();
                        }else{
                          showFlash(
                              context: context,
                              duration: Duration(seconds: 4),
                              builder: (context, controller) => Flash.bar(
                                  controller: controller,
                                  backgroundColor: Color(0xF0393939),
                                  borderRadius: BorderRadius.circular(10),
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 40),
                                  forwardAnimationCurve: Curves.easeOutBack,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child:
                                    Text('You already rating the app. Thank you.',
                                        style: TextStyle(
                                          fontSize: 18,
                                        )),
                                  )));
                        }
                      },
                    ),
                    //Got to application store page
                    // ListTile(
                    //   title: Text(
                    //     Language.language['rate'].toString(),
                    //     style: style,
                    //   ),
                    //   trailing: Icon(Icons.star_outlined, color: Colors.white,),
                    //   onTap: ()async{
                    //     final InAppReview inAppReview = InAppReview.instance;
                    //     if (await inAppReview.isAvailable()) {
                    //       inAppReview.requestReview();
                    //     }else{
                    //       showFlash(
                    //           context: context,
                    //           duration: Duration(seconds: 4),
                    //           builder: (context, controller) => Flash.bar(
                    //               controller: controller,
                    //               backgroundColor: Color(0xF0393939),
                    //               borderRadius: BorderRadius.circular(10),
                    //               margin: EdgeInsets.symmetric(
                    //                   horizontal: 15, vertical: 40),
                    //               forwardAnimationCurve: Curves.easeOutBack,
                    //               child: Padding(
                    //                 padding: const EdgeInsets.all(8.0),
                    //                 child:
                    //                 Text('You already rating the app. Thank you.',
                    //                     style: TextStyle(
                    //                       fontSize: 18,
                    //                     )),
                    //               )));
                    //     }
                    //   },
                    // ),
                  ],
                ),
              ),
              CupertinoButton(
                  color: HexColor('#254B7D'),
                  child: Text(Language.language['massageButton'].toString(),
                      style: style),
                  onPressed: () async {
                    final String url = 'mailto:ahmed200t@hotmail.com';
                    if (await canLaunch(url)) launch(url);
                  }),
            ],
          ),
        ),
      ),
    );
  }

  void showToast1() {
    showToast(
      Language.language['toastMassage'],
      context: context,
      animation: StyledToastAnimation.scale,
      reverseAnimation: StyledToastAnimation.fade,
      position: StyledToastPosition.center,
      animDuration: Duration(seconds: 1),
      duration: Duration(seconds: 4),
      curve: Curves.elasticOut,
      reverseCurve: Curves.linear,
    );
  }
}
