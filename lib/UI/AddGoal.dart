import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:intl/intl.dart';
import 'package:money_bank/Database/DbGoal.dart';
import 'package:money_bank/Model/Goal.dart';
import 'package:money_bank/Model/Language.dart';
import 'package:money_bank/UI/Home.dart';
import 'package:money_bank/helper/constant.dart';
import 'package:money_bank/main.dart';

class AddGoal extends StatefulWidget {
  late bool state;
  late Goal goal;

  AddGoal(this.state, this.goal);

  @override
  State<StatefulWidget> createState() {
    return addGoal(this.state, this.goal);
  }
}

class addGoal extends State<AddGoal> {
  late bool state;
  late Goal goal;

  addGoal(this.state, this.goal);

  DateTime dateTime = DateTime.now();
  SqlHelper helper = SqlHelper();
  late TextEditingController name;
  late TextEditingController money;
  HomeWidget method = HomeWidget();
  BoxDecoration buttonDecoration=BoxDecoration(
    border: Border.all(
      color: Colors.blueAccent,
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black45,
        offset: Offset(
          2.0,
          2.0,
        ),
      )
    ],
    gradient:LinearGradient(
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      colors: [HexColor('78CBE6'), HexColor('BEEEC4')],
    ),
    borderRadius: BorderRadius.all(Radius.circular(15.0)),
  );
  BoxDecoration buttonDecorationDark=BoxDecoration(
    border: Border.all(
      color: Colors.blueAccent,
    ),
    color: HexColor('219ebc'),
    boxShadow: [
      BoxShadow(
        color: Colors.black45,
        offset: Offset(
          2.0,
          2.0,
        ),
      )
    ],
    borderRadius: BorderRadius.all(Radius.circular(15.0)),
  );


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(!state){
      dateTime=DateTime.parse(goal.date);
    }

    name = TextEditingController(text: goal.name);
    money = TextEditingController(text: goal.goal.toString()=='0.0'?'':goal.goal.toString());
  }

  @override
  Widget build(BuildContext context) {

    final GlobalKey<ScaffoldState> date = new GlobalKey<ScaffoldState>();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        shadowColor: Colors.transparent,
        title: Constant.pageTitle(title(state)),
        centerTitle: true,
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
      ),
      body: Container(
          decoration: darkMode?null:
          Constant.linearColor,
          child: Padding(
            padding: EdgeInsets.only(top: 40, left: 20, right: 20),
            child: Column(
              children: [
                TextFormField(
                  controller: name,
                  onChanged: (value) {
                    goal.name = value;
                  },
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepPurple),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    labelText: Language.language['goal'].toString(),
                    alignLabelWithHint: true,
                    labelStyle: TextStyle(fontFamily: 'Inter',
                        fontSize: 20, fontWeight: FontWeight.w500),
                    prefixIcon: Icon(Icons.emoji_events_outlined),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: money,
                  onChanged: (value) {
                    goal.goal = double.parse(value);
                  },
                  maxLength: 10,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepPurple),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    labelText: Language.language['moneyGoal'].toString(),
                    alignLabelWithHint: true,
                    labelStyle: TextStyle(fontFamily: 'Inter',
                        fontSize: 20, fontWeight: FontWeight.w500),
                    prefixIcon: Icon(CupertinoIcons.money_dollar),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        Language.language['date'].toString(),
                        style: TextStyle(fontFamily: 'Inter',
                            fontSize: 27, fontWeight: FontWeight.w400),
                      ),
                      CupertinoButton(
                          child: Text(dateFormat(dateTime.toString())),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: HexColor('B5EAEA'),
                                    title: Text(
                                      Language.language['date'].toString(),
                                      style: TextStyle(fontFamily: 'Inter',
                                          fontSize: 25, color: Colors.black),
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            Language.language['ok'].toString(),
                                            style: TextStyle(fontFamily: 'Inter',
                                                fontSize: 20,
                                                color: Colors.black),
                                          ))
                                    ],
                                    content: SizedBox(
                                      height: 100,
                                      width: 300,
                                      child: CupertinoDatePicker(
                                        key: date,
                                        initialDateTime: dateTime,
                                        backgroundColor: Colors.transparent,
                                        minimumYear: DateTime.now().year,
                                        minimumDate:
                                            DateTime(DateTime.now().year),
                                        mode: CupertinoDatePickerMode.date,
                                        onDateTimeChanged: (DateTime value) {
                                          setState(() {
                                            dateTime = value;
                                          });
                                        },
                                      ),
                                    ),
                                  );
                                });
                          }),
                    ],
                  ),
                ),
                SizedBox(
                  height: 230,
                ),
                Container(
                  width: 170,
                  height: 60,
                  decoration: darkMode? buttonDecorationDark:
                      buttonDecoration,
                  child: CupertinoButton(
                    padding: EdgeInsets.only(bottom: 1),
                    child: Text(buttonTitle(state),
                        style: TextStyle(fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                            fontSize: 30)),
                    onPressed: () {
                      if (state) {
                        setState(() {
                          if (money.text.isEmpty || name.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                  Language.language['enterMoney'].toString(),
                              style: TextStyle(fontFamily: 'Inter',fontSize: 15),
                            )));
                          } else {
                            insertGoal();
                            goBack();
                          }
                        });
                      } else {
                        setState(() {
                          updateGoal();
                          goBack();
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          )),
    );
  }

  String dateFormat(String date) {
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final DateFormat serverFormater = DateFormat('yyyy-MM-dd');
    final DateTime displayDate = displayFormater.parse(date);
    final String formatted = serverFormater.format(displayDate);
    return formatted;
  }

  void goBack() {
    setState(() {
      Navigator.pop(context);
    });
  }

  void insertGoal() async {
    String nameG = name.text;
    double goal = double.parse(money.text);
    String dateg = dateFormat(dateTime.toString());
    Goal goalg = Goal(nameG, goal, 0, dateg);
    await helper.insertGoal(goalg);
  }

  void updateGoal() async {
    goal.date = dateFormat(dateTime.toString());
    await helper.updateGoal(goal);
  }

  String moneyController() {
    if (state) {
      return '';
    } else {
      return goal.goal.toString();
    }
  }

  String title(bool state) {
    if (state) {
      return Language.language['newGoal'].toString();
    } else {
      return goal.name;
    }
  }

  String buttonTitle(bool state) {
    if (state)
      return Language.language['create'].toString();
    else
      return Language.language['save'].toString();
  }
}
