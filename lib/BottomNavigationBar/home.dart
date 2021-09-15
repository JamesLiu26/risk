import 'package:flutter/material.dart';

import 'Home/advice.dart';
import 'Home/questionnaire.dart';
import 'Home/notice.dart';

import '../appBar.dart';
import '../menu.dart';
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

            SizedBox(height: 20),

            // -----------------------

            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              homeRoute("預約看診", "images/放大.png", Text("")),
              homeRoute("問卷填寫", "images/問卷.png", Question())
            ]),
            SizedBox(height: 20),

            // // -----------------------

            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              homeRoute("醫師洽談", "images/醫師談.png", Text("")),
              homeRoute("健康飲食", "images/餐具.png", Text(""))
            ]),

            // -----------------------

            SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              homeRoute("飲食建議", "images/食物.png", Advice()),
              homeRoute("注意事項", "images/注意.png", Notice())
            ]),
          ]),
        ));
  }

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
        Navigator.push(context, MaterialPageRoute(builder: (context) => route));
      },
    );
  }
}
