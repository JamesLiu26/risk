import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Menu/person_data.dart';
import 'Menu/setting.dart';
import './main.dart';

FirebaseAuth _auth = FirebaseAuth.instance;
String _phNum = _auth.currentUser!.phoneNumber!;
String _name = "";

// 建立一個選單button
StatefulBuilder menuButton() {
  return StatefulBuilder(
      builder: (context, StateSetter setState) => IconButton(
          icon: ImageIcon(AssetImage("images/選單.png"), color: Colors.blue[800]),
          // 點擊打開選單
          onPressed: () {
            Scaffold.of(context).openDrawer();
            FirebaseFirestore.instance
                .collection("user")
                .doc(_phNum)
                .get()
                .then((snapshot) {
              setState(() {
                _name = snapshot.get("name").toString();
              });
            });
          }));
}

Container menu(BuildContext context) {
  double sizeHeight = MediaQuery.of(context).size.height;
  double sizeWidth = MediaQuery.of(context).size.width;
  return Container(
    color: Colors.white,
    height: sizeHeight,
    width: sizeWidth * 0.7,
    child: Column(
      children: [
        // 避免文字跑到最上面去
        SafeArea(
            child: Text(
          "$_name\n您好",
          style: TextStyle(fontSize: sizeWidth * 0.05),
          textAlign: TextAlign.center,
        )),

        Divider(color: Colors.grey),
        // -------------------------------

        menuPages(
            PersonData(),
            Image.asset("images/個人資料.png",
                height: sizeWidth * 0.14, width: sizeWidth * 0.14),
            context,
            "個人資料",
            15),
        Divider(color: Colors.grey),
        // -------------------------------

        menuPages(
            Setting(),
            Icon(Icons.settings,
                size: sizeWidth * 0.13,
                color: Color.fromARGB(255, 0, 160, 233)),
            context,
            "設定"),
        Divider(color: Colors.grey),
        // -------------------------------

        menuPages(
            Risk(),
            Icon(Icons.run_circle,
                size: sizeWidth * 0.13,
                color: Color.fromARGB(255, 0, 160, 233)),
            context,
            "登出"),
        Divider(color: Colors.grey),
      ],
    ),
  );
}

/*
  導向各個頁面
  route 頁面
  image 頁面代表圖片
  pageText 頁面代表文字
  [padding=20] 間距，預設20
*/

GestureDetector menuPages(
    Widget route, Widget image, BuildContext context, String pageText,
    [double padding = 20]) {
  return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => route));
        if (pageText == "登出") {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => route),
              (Route route) => false);
          _auth.signOut();
        }
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
