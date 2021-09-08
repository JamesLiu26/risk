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
    return Scaffold(
      drawer: menu(context),
      appBar: appBar("通知", menuButton()),
    );
  }
}
