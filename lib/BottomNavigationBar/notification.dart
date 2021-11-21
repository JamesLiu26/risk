import 'package:flutter/material.dart';
import '../menu.dart';
import '../appBar.dart';

void main() {
  return runApp(MaterialApp(
    home: Notify(),
    title: "通知",
    debugShowCheckedModeBanner: false,
  ));
}

class Notify extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double fontSize = MediaQuery.of(context).size.width * 0.06;
    Text textStyle(String text) {
      return Text(text, style: TextStyle(fontSize: fontSize));
    }

    return Scaffold(
        drawer: menu(context),
        appBar: appBar("通知", menuButton()),
        body: Center(child: textStyle("目前尚無通知")));
  }
}
