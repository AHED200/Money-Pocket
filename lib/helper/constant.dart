import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:money_bank/main.dart';

class Constant{

  static BoxDecoration linearColor= BoxDecoration(
      gradient: LinearGradient(
        colors: [HexColor('B5EAEA'), HexColor('DEFFFF')],
        end: Alignment.bottomCenter,
        begin: Alignment.topCenter,
      ));


  static Text pageTitle(String? title){
    return  Text(
      title.toString(),
      style: TextStyle(
          fontFamily: 'Inter', fontSize: 36, fontWeight: FontWeight.bold,
          color: darkMode?
          Colors.white:
              Colors.black,
      ),
    );
  }

}