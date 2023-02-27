import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:money_bank/Database/DbGoal.dart';
import 'package:money_bank/Model/Goal.dart';
import 'package:money_bank/Model/History.dart';
import 'package:money_bank/Model/Language.dart';
import 'package:money_bank/UI/AddGoal.dart';
import 'package:money_bank/UI/Home.dart';
import 'package:money_bank/helper/constant.dart';
import 'package:money_bank/icons_icons.dart';
import 'package:money_bank/main.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class GoalDetail extends StatefulWidget {
  Goal goal;

  GoalDetail(this.goal);

  @override
  State<StatefulWidget> createState() {
    return goalDetail(goal);
  }
}

class goalDetail extends State<GoalDetail> {
  Goal goal;
  List<History> historyList = <History>[];
  int historyCount = 0;
  SqlHelper helper = SqlHelper();
  HomeWidget method = HomeWidget();

  goalDetail(this.goal);

  @override
  Widget build(BuildContext context) {
    updateHistoryList();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        shadowColor: Colors.transparent,
        centerTitle: true,
        title: Constant.pageTitle(Language.language['goalDetail']),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_outlined,
          ),
          onPressed: () {
            Navigator.pop(
              context,
            );
          },
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddGoal(false, goal)));
              },
              icon: Icon(
                Icons.edit_outlined,
              )),
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return deleteGoal(goal);
                    });
              },
              icon: Icon(
                CupertinoIcons.delete,
                color: Colors.red,
              ))
        ],
      ),
      body: Container(
          decoration: darkMode?null:
          Constant.linearColor,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 20, left: 30, right: 30),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          goal.name,
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 30,
                              fontWeight: FontWeight.w600),
                        ),
                        ElevatedButton.icon(
                          icon: Icon(CupertinoIcons.money_dollar),
                          label: Text(Language.language['depositButton'].toString()),
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(HexColor('219ebc')),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ))),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return method.alertDialog(goal, context);
                                });
                          },
                        )
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    LinearPercentIndicator(
                      animation: true,
                      lineHeight: 30,
                      animationDuration: 1000,
                      percent: method.getPercent(goal.goal, goal.currentGoal)/100,
                      center: Text(
                        method.MoneyDisable(goal.currentGoal),
                        style: TextStyle(
                          color: Colors.black54,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),),
                      barRadius: Radius.circular(50),
                      progressColor: HexColor('A7CF4D'),
                      backgroundColor: Colors.white70,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    goalInform(),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                    padding: EdgeInsets.only(top: 10),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: HexColor('219ebc'),
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(50),
                          topLeft: Radius.circular(50)),
                    ),
                    child: Column(
                      children: [
                        Text(
                          Language.language['history'].toString(),
                          style: TextStyle(
                              fontFamily: 'Inter',
                              color: Colors.white,
                              fontSize: 23,
                              fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          height: 13,
                        ),
                        Expanded(
                          child: history(goal),
                        )
                      ],
                    )),
              )
            ],
          )),
    );
  }

  ListView history(Goal goal) {
    TextStyle style = TextStyle(
        fontFamily: 'Inter',
        color: Colors.white,
        fontSize: 17,
        fontWeight: FontWeight.w500);

    return ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: historyCount,
        itemBuilder: (BuildContext context, int x) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
            child: Slidable(
              actionPane: SlidableDrawerActionPane(),
              secondaryActions: <Widget>[
                IconSlideAction(
                  iconWidget: Icon(
                    CupertinoIcons.delete_solid,
                    color: HexColor('fb3640'),
                    size: 22,
                  ),
                  color: Colors.transparent,
                  onTap: () {
                    withdraw(historyList[x]);
                  },
                )
              ],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '#${x + 1}',
                    style: style,
                  ),
                  Text(
                    historyList[x].date,
                    style: style,
                  ),
                  Text(
                    method.MoneyDisable(historyList[x].deposit),
                    style: style,
                  )
                ],
              ),
            ),
          );
        });
  }

  Column goalInform() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Icon(
                  Ico.goal_icon,
                  color: HexColor('219ebc'),
                  size: 40,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  method.MoneyDisable(goal.goal),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Icon(
                  CupertinoIcons.money_dollar_circle_fill,
                  color: HexColor('219ebc'),
                  size: 40,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                method.getGoalDef(goal),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Icon(
                  CupertinoIcons.calendar,
                  color: HexColor('219ebc'),
                  size: 40,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  goal.date,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Icon(
                  Ico.calendar_rem,
                  color: HexColor('219ebc'),
                  size: 40,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  ('${Language.language['days'].toString()}: ${method.reminderDay(goal)}'),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }

  void withdraw(History history) {
    this.goal.currentGoal = goal.currentGoal - history.deposit;

    helper.updateGoal(goal);
    helper.deleteHistory(history.id);
  }

  void updateHistoryList() {
    final Future<Database> db = this.helper.initDatabase();
    db.then((database) {
      Future<List<History>> goals = this.helper.getHistoryList(goal.id);
      goals.then((theList) {
        setState(() {
          this.historyList = theList;
          this.historyCount = theList.length;
        });
      });
    });
  }

  AlertDialog deleteGoal(Goal goal) {
    TextStyle style1 = TextStyle(
        fontFamily: 'Inter',
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.white);
    return AlertDialog(
      backgroundColor: HexColor('fb3640'),
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Align(
          alignment: Language.currentLanguage=='EN'?
          Alignment.topLeft:
          Alignment.topRight,
          child: Text(
            Language.language['deleteTitle'].toString(),
            style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
        ),
      ),
      content: SafeArea(
        child: Text(
            Language.language['deleteContent'].toString(),
            style: style1),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(Language.language['cancel'].toString(), style: style1)),
        TextButton(
            onPressed: () {
              deleteGoalMethod();
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text(Language.language['ok'].toString(), style: style1)),
      ],
    );
  }

  void deleteGoalMethod() async {
    int result = await helper.deleteGoal(goal.id);
    int result1 = await helper.deleteAllHistory(goal.id);
  }
}
