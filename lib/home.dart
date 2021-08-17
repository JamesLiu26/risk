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
    return Scaffold(
        drawer: menu(context),
        appBar: appBar("首頁", menuButton()),
        body: Container(
          color: Color(0XFFFFF0F5),
          child: Column(children: [
            SizedBox(height: 20),
            // -----------------------

            Text(dateNow,
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.025)),
            SizedBox(height: 20),
            // -----------------------

            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              homeRoute("線上掛號", context, "images/放大.png", Text("")),
              homeRoute("問卷填寫", context, "images/問卷.png", Question()),
            ]),
            SizedBox(height: 20),

            // -----------------------
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              homeRoute("醫師洽談", context, "images/醫師談.png", Text("")),
              homeRoute("飲食紀錄", context, "images/餐具.png", Text("")),
            ]),
          ]),
        ));
  }
}

GestureDetector homeRoute(
    String text, BuildContext context, String imageAsset, Widget route) {
  return GestureDetector(
    child: Stack(alignment: AlignmentDirectional.center, children: [
      Image.asset(imageAsset,
          height: MediaQuery.of(context).size.width * 0.25,
          width: MediaQuery.of(context).size.width * 0.25),
      Container(
          height: MediaQuery.of(context).size.height * 0.2,
          width: MediaQuery.of(context).size.width * 0.42,
          decoration: BoxDecoration(
              color: Color(0xAF000000),
              borderRadius: BorderRadius.circular(10))),
      Text(text,
          style: TextStyle(
              color: Colors.white,
              fontSize: MediaQuery.of(context).size.height * 0.025))
    ]),
    onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => route));
    },
  );
}
