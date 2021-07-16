import 'package:flutter/material.dart';
import './menu.dart';
import './appBar.dart';

void main() {
  return runApp(MaterialApp(
    home: Trace(),
    debugShowCheckedModeBanner: false,
  ));
}

class Trace extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: menu(context),
      appBar: appBar("每日追蹤", menuButton()),
      body: Column(),
    );
  }
}
