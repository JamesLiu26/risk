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
  return Container(
    color: Colors.white,
    height: MediaQuery.of(context).size.height,
    width: MediaQuery.of(context).size.width * 0.7,
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 50, bottom: 8),
          child: Text("XXX先生，您好",
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.03)),
        ),
        Divider(color: Colors.grey),
        // -------------------------------

        GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PersonData()));
            },
            child: Container(
                width: MediaQuery.of(context).size.width * 0.7,
                color: Colors.transparent,
                margin: EdgeInsets.only(left: 10, top: 10, bottom: 10),
                child: Row(children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: Image.asset("images/個人資料.png",
                        height: MediaQuery.of(context).size.width * 0.13,
                        width: MediaQuery.of(context).size.width * 0.14),
                  ),
                  Text(
                    "個人資料",
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.05),
                  )
                ]))),
        Divider(color: Colors.grey),
        // -------------------------------

        menuPages(Settings(), Icons.settings, context, "設定"),

        Divider(color: Colors.grey),
        // -------------------------------

        menuPages(Login(), Icons.logout, context, "登出"),
        Divider(color: Colors.grey),
      ],
    ),
  );
}

Container menuUnderline(BuildContext context) {
  return Container(
      height: 1,
      width: MediaQuery.of(context).size.width * 0.7,
      decoration: BoxDecoration(color: Colors.grey[300]));
}

GestureDetector menuPages(
    Widget route, IconData icon, BuildContext context, String pageText) {
  return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => route));
      },
      child: Container(
          width: MediaQuery.of(context).size.width * 0.7,
          margin: EdgeInsets.only(left: 10, top: 10, bottom: 10),
          color: Colors.transparent,
          child: Row(
            children: [
              Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Icon(icon,
                      size: MediaQuery.of(context).size.width * 0.13,
                      color: Color.fromARGB(255, 0, 160, 233))),
              Text(
                pageText,
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.05),
              )
            ],
          )));
}
