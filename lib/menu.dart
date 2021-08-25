import 'package:flutter/material.dart';
import './person_data.dart';
import './setting.dart';
import './login.dart';

Builder menuButton() {
  return Builder(
      builder: (context) => IconButton(
          icon: ImageIcon(AssetImage("images/選單.png"), color: Colors.blue[800]),
          onPressed: () => Scaffold.of(context).openDrawer()));
}

Container menu(BuildContext context) {
  Size size = MediaQuery.of(context).size;
  return Container(
    color: Colors.white,
    height: size.height,
    width: size.width * 0.7,
    child: Column(
      children: [
        SafeArea(
            child: Text(
          "\nXXX5454545\n先生",
          style: TextStyle(fontSize: size.width * 0.045),
          textAlign: TextAlign.center,
        )),

        Divider(color: Colors.grey),
        // -------------------------------

        menuPages(
            PersonData(),
            Image.asset("images/個人資料.png",
                height: size.width * 0.13, width: size.width * 0.14),
            context,
            "個人資料",
            15),
        Divider(color: Colors.grey),
        // -------------------------------

        menuPages(
            Settings(),
            Icon(Icons.settings,
                size: size.width * 0.13,
                color: Color.fromARGB(255, 0, 160, 233)),
            context,
            "設定"),

        Divider(color: Colors.grey),
        // -------------------------------

        menuPages(
            Login(),
            Icon(Icons.run_circle,
                size: size.width * 0.13,
                color: Color.fromARGB(255, 0, 160, 233)),
            context,
            "登出"),
        Divider(color: Colors.grey),
      ],
    ),
  );
}

GestureDetector menuPages(
    Widget route, Widget image, BuildContext context, String pageText,
    [double padding = 20]) {
  return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => route));
      },
      child: Container(
          width: MediaQuery.of(context).size.width * 0.7,
          margin: EdgeInsets.only(left: 10),
          color: Colors.transparent,
          child: Row(
            children: [
              Padding(padding: EdgeInsets.only(right: padding), child: image),
              Text(
                pageText,
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.05),
              )
            ],
          )));
}
