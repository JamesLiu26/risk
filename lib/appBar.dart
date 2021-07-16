import 'package:flutter/material.dart';

AppBar appBar(String title, Widget leadingIcon) => AppBar(
    title: Text(title, style: TextStyle(color: Colors.black)),
    backgroundColor: Color.fromARGB(255, 225, 230, 255),
    leading: leadingIcon);
