import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:flutter_rounded_progress_bar/flutter_rounded_progress_bar.dart';
import 'package:flutter_rounded_progress_bar/rounded_progress_bar_style.dart';
import 'package:intl/intl.dart';
import 'package:money_bank/Database/DbGoal.dart';
import 'package:money_bank/Model/Goal.dart';
import 'package:money_bank/Model/History.dart';
import 'package:money_bank/Model/Language.dart';
import 'package:money_bank/UI/AddGoal.dart';
import 'package:money_bank/UI/GoalDetail.dart';
import 'package:money_bank/helper/constant.dart';
import 'package:money_bank/main.dart';
import 'package:money_bank/widgets/drawer.dart';
import 'package:sqflite/sqflite.dart';
import 'package:stack_appodeal_flutter/stack_appodeal_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return HomeWidget();
  }
}

class HomeWidget extends State<Home> {
  bool bannerIsReady=false;
  bool bannerIsShown=false;
  SqlHelper helper = new SqlHelper();
  List<Goal> goalList = <Goal>[];
  int count = 0;
  late int _selectedGoal;
  TextStyle style = TextStyle(
    fontFamily: 'Inter',
    color: Colors.black,
    fontSize: 36,
    fontWeight: FontWeight.w500,
  );
  BoxDecoration cardN = BoxDecoration(
      boxShadow: [
        BoxShadow(color: Colors.blueGrey, spreadRadius: 0.1, blurRadius: 5)
      ],
      border: Border.all(color: Colors.blueAccent),
      borderRadius: BorderRadius.circular(30),
      gradient: LinearGradient(
        colors: [HexColor('BEEEC4'), HexColor('78CBE6')],
        end: Alignment.bottomCenter,
        begin: Alignment.topCenter,
      ));
  BoxDecoration cardDark = BoxDecoration(
      boxShadow: [
        BoxShadow(color: Colors.black45, spreadRadius: 0.1, blurRadius: 5)
      ],
      borderRadius: BorderRadius.circular(30),
      gradient: LinearGradient(
        colors: [Color(0xFF219ebc), Color(0xff4f78ff)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ));

  @override
  void dispose() {
    super.dispose();
    updateListView();
  }

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
    Appodeal.setBannerCallbacks(
            (onBannerLoaded, isPrecache) => {
          setState(() {bannerIsReady=true;
            Appodeal.show(Appodeal.BANNER_BOTTOM);
          })
        },
            (onBannerFailedToLoad) => {},
            (onBannerShown) => {bannerIsShown=true},
            (onBannerShowFailed) => {bannerIsReady=false},
            (onBannerClicked) => {},
            (onBannerExpired) => {});
  }

  @override
  Widget build(BuildContext context) {
    updateListView();
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        titleSpacing: 33,
        centerTitle: true,
        shadowColor: Colors.transparent,
        title: Constant.pageTitle(Language.language['title']),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.info_outline,
              size: 30,
            ),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return massage();
                  });
            },
          ),
          IconButton(
            icon: Icon(Icons.add, size: 30,),
            onPressed: () {
              if (intersIsReady) {
                Appodeal.show(Appodeal.INTERSTITIAL);
              }else
                goToNewGoal();
            },
          ),

        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: darkMode ? null : Constant.linearColor,
            child: SafeArea(
              minimum: EdgeInsets.only(left: 7, right: 7, top: 0, bottom: 0),
              top: true,
              bottom: true,
              child: GoalsList(),
            ),
          ),
        ],
      ),
    );
  }

  Column GoalsList() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 30),
            itemCount: count,
            itemBuilder: (BuildContext context, int n) {
              return GestureDetector(
                onTap: () {
                  _selectedGoal = n;
                  if (intersIsReady) {
                    Appodeal.show(Appodeal.INTERSTITIAL);
                  }else
                    goToGoalDetail(goalList[n]);
                },
                child: Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Container(
                      padding: EdgeInsets.only(top: 10),
                      decoration: darkMode ? cardDark : cardN,
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 12.5, right: 12.5, top: 12.5, bottom: 0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  goalList[n].name,
                                  style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 25,
                                      fontWeight: FontWeight.w800),
                                ),
                                Text(
                                  getGoalDef(goalList[n]),
                                  style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 25,
                                      fontWeight: FontWeight.w800),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 28,
                            ),
                            progressBar(goalList[n]),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${Language.language['days'].toString()}: ${reminderDay(goalList[n])}",
                                  style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  Language.language['goal'].toString() +
                                      ': ' +
                                      MoneyDisable(goalList[n].goal),
                                  style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700),
                                ),
                                IconButton(
                                  iconSize: 40,
                                  color: HexColor('293B5F'),
                                  icon: Icon(
                                    Icons.add_circle,
                                  ),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return alertDialog(goalList[n], context);
                                        });
                                  },
                                )
                              ],
                            ),
                          ],
                        ),
                      )),
                ),
              );
            },
          ),
        ),
        bannerIsReady?SizedBox(height: 52,):Container(),
      ],
    );
  }

  String MoneyDisable(double goal) {
    if ((goal.toInt() - goal) != 0) {
      return "\$" + goal.toString();
    } else {
      return "\$" + goal.toInt().toString();
    }
  }

  String getGoalDef(Goal goal) {
    if (goal.goal >= goal.currentGoal) {
      return "${MoneyDisable((goal.goal - goal.currentGoal))}";
    } else {
      return '\$0';
    }
  }

  String reminderDay(Goal goal) {
    DateTime dateTimeCreatedAt = DateTime.parse(goal.date);
    DateTime dateTimeNow = DateTime.now();
    int result = dateTimeCreatedAt.difference(dateTimeNow).inDays.toInt() + 1;
    if (result > 0) {
      return result.toString();
    } else {
      return Language.language['finish'].toString();
    }
  }

  double getPercent(double max, double min) {
    if (max >= min && max != 0) {
      return (min / max) * 100;
    } else
      return 0;
  }

  void updateListView() {
    final Future<Database> db = this.helper.initDatabase();
    db.then((database) {
      Future<List<Goal>> goals = this.helper.getGoalList();
      goals.then((theList) {
        setState(() {
          this.goalList = theList;
          this.count = theList.length;
        });
      });
    });
  }

  void updateDeposit(Goal goal, History history) {
    helper.insertHistory(history);
    helper.updateGoal(goal);
  }

  String dateFormat(String date) {
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final DateFormat serverFormater = DateFormat('yyyy-MM-dd');
    final DateTime displayDate = displayFormater.parse(date);
    final String formatted = serverFormater.format(displayDate);
    return formatted;
  }

  AlertDialog alertDialog(Goal goal, BuildContext context) {
    TextEditingController amount = TextEditingController();

    return AlertDialog(
      title: Text(
        Language.language['depositTitle'].toString(),
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 25,
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              Language.language['cancel'].toString(),
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 20,
              ),
            )),
        TextButton(
            onPressed: () {
              if (amount.toString().isNotEmpty) {
                double amou = double.parse(amount.text);
                goal.currentGoal = goal.currentGoal + amou;
                String date = dateFormat(DateTime.now().toString());
                History history = History(goal.id, date, amou);
                updateDeposit(goal, history);
              }
              Navigator.pop(context);
            },
            child: Text(
              Language.language['ok'].toString(),
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 20,
              ),
            )),
      ],
      content: TextFormField(
        controller: amount,
        maxLength: 10,
        maxLines: 1,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.deepPurple),
            borderRadius: BorderRadius.circular(20),
          ),
          labelText: Language.language['depositFiled'].toString(),
          alignLabelWithHint: true,
          labelStyle: TextStyle(
              fontFamily: 'Inter', fontSize: 20, fontWeight: FontWeight.w500),
          prefixIcon: Icon(CupertinoIcons.money_dollar),
        ),
      ),
    );
  }

  AlertDialog massage() {
    return AlertDialog(
      title: Text(
        Language.language['massageTitle'].toString(),
        style: TextStyle(
            fontFamily: 'Inter', fontSize: 26, fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            Language.language['massageContent'].toString(),
            style: TextStyle(
                fontFamily: 'Inter', fontSize: 18, fontWeight: FontWeight.w600),
          ),
          CupertinoButton(
              color: HexColor('#254B7D'),
              child: Text(
                Language.language['massageButton'].toString(),
                style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15,
                    fontWeight: FontWeight.w600),
              ),
              onPressed: () async {
                final String url = 'mailto:AhmedDeve@hotmail.com';
                if (await canLaunch(url)) launch(url);
              })
        ],
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              Language.language['ok'].toString(),
              style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ))
      ],
    );
  }

  Widget progressBar(Goal goal) {
    if (goal.goal > goal.currentGoal) {
      return RoundedProgressBar(
        percent: getPercent(goal.goal, goal.currentGoal),
        borderRadius: BorderRadius.circular(24),
        style: RoundedProgressBarStyle(
          borderWidth: 0,
          widthShadow: 0,
          backgroundProgress: Colors.white,
          colorProgress: HexColor('A7CF4D'),
        ),
        height: 30,
        childCenter: Text(
          MoneyDisable(goal.currentGoal),
          style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: Colors.black54),
        ),
      );
    } else {
      return Center(
        child: Text(
          Language.language['done'].toString(),
          style: TextStyle(
              fontFamily: 'Inter', fontSize: 20, fontWeight: FontWeight.bold),
        ),
      );
    }
  }


  void goToGoalDetail(Goal goal) {
    Navigator.push(
        context,
        PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 300),
            transitionsBuilder: (context, animation, animationTime, child) {
              animation = CurvedAnimation(
                  parent: animation, curve: Curves.elasticInOut);
              return ScaleTransition(
                scale: animation,
                child: child,
                alignment: Alignment.center,
              );
            },
            pageBuilder: (context, animation, animationTime) {
              return GoalDetail(goal);
            }));
  }

  void goToNewGoal() {
    Navigator.push(
        context,
        PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 300),
            transitionsBuilder: (context, animation, animationTime, child) {
              animation = CurvedAnimation(
                  parent: animation, curve: Curves.elasticInOut);
              return ScaleTransition(
                scale: animation,
                child: child,
                alignment: Alignment.center,
              );
            },
            pageBuilder: (context, animation, animationTime) {
              return AddGoal(
                  true, Goal('', 0, 0, dateFormat(DateTime.now().toString())));
            }));
  }
}
