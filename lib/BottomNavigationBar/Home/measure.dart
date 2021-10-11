import 'package:flutter/material.dart';
import '/appBar.dart';

class Measure extends StatefulWidget {
  @override
  _MeasureState createState() => _MeasureState();
}

class _MeasureState extends State<Measure> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
          "問卷調查",
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios, color: Colors.blue[800]))),
    );
  }
}
