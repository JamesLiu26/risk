import 'package:flutter/material.dart';

import 'Home/advice.dart';
import 'Home/assessment.dart';
import 'Home/notice.dart';
import 'Home/appointment.dart';
import 'Home/chat.dart';
import 'Home/measure.dart';
import '../appBar.dart';
import '../menu.dart';
// -------------

// void main() {
//   return runApp(MaterialApp(
//     home: Home(),
//     debugShowCheckedModeBanner: false,
//   ));
// }

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    GestureDetector homeRoute(String text, String imageAsset, Widget route) {
      double size = MediaQuery.of(context).size.width;
      return GestureDetector(
        child: Stack(alignment: AlignmentDirectional.center, children: [
          Container(
              height: size * 0.35,
              width: size * 0.4,
              decoration: BoxDecoration(
                  color: Color(0xCFFFFFFF),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black))),
          Column(children: [
            Image.asset(imageAsset, height: size * 0.2, width: size * 0.2),
            Text(text,
                style: TextStyle(color: Colors.black, fontSize: size * 0.045))
          ])
        ]),
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => route));
        },
      );
    }

    return Scaffold(
        drawer: menu(context),
        appBar: appBar("首頁", menuButton()),
        body: Container(
          color: Color(0XFFFFF0F5),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      homeRoute("預約看診", "images/放大.png", Appointment()),
                      homeRoute("風險評估", "images/問卷.png", Assessment())
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      homeRoute("醫師洽談", "images/醫師談.png", Chatscreen()),
                      homeRoute("問卷調查", "images/量測.png", Measure())
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      homeRoute("飲食建議", "images/食物.png", Advice()),
                      homeRoute("注意事項", "images/注意.png", Notice())
                    ]),
              ]),
        ));
  }
}
