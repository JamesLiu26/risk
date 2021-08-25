import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './questionnaire.dart';

import './appBar.dart';
import './menu.dart';
// -------------

void main() {
  return runApp(MaterialApp(
    home: Home(),
    debugShowCheckedModeBanner: false,
  ));
}

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  String dateNow = DateFormat("yyyy-MM-dd EEEE").format(DateTime.now());
  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
        drawer: menu(context),
        appBar: appBar("首頁", menuButton()),
        body: Container(
          color: Color(0XFFFFF0F5),
          child: Column(children: [
            SizedBox(height: 20),

            // -----------------------

            Text(dateNow, style: TextStyle(fontSize: size * 0.05)),
            SizedBox(height: 20),

            // -----------------------

            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              homeRoute("線上掛號", "images/放大.png", Text("")),
              homeRoute("問卷填寫", "images/問卷.png", Question()),
            ]),
            SizedBox(height: 20),

            // -----------------------
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              homeRoute("醫師洽談", "images/醫師談.png", Text("")),
              homeRoute("飲食紀錄", "images/餐具.png", Text("")),
            ]),
          ]),
        ));
  }

  GestureDetector homeRoute(String text, String imageAsset, Widget route) {
    double size = MediaQuery.of(context).size.width;
    return GestureDetector(
      child: Stack(alignment: AlignmentDirectional.center, children: [
        Image.asset(imageAsset, height: size * 0.25, width: size * 0.25),
        Container(
            height: size * 0.42,
            width: size * 0.42,
            decoration: BoxDecoration(
                color: Color(0xAF000000),
                borderRadius: BorderRadius.circular(10))),
        Text(text,
            style: TextStyle(color: Colors.white, fontSize: size * 0.045))
      ]),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => route));
      },
    );
  }
}
