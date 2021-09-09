import 'package:flutter/material.dart';
import 'Menu/person_data.dart';
import 'Menu/setting.dart';
import './login.dart';

// 建立一個選單button
Builder menuButton() {
  return Builder(
      builder: (context) => IconButton(
          icon: ImageIcon(AssetImage("images/選單.png"), color: Colors.blue[800]),
          // 點擊打開選單
          onPressed: () => Scaffold.of(context).openDrawer()));
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
          "\nXXX5454545\n先生",
          style: TextStyle(fontSize: sizeWidth * 0.045),
          textAlign: TextAlign.center,
        )),

        Divider(color: Colors.grey),
        // -------------------------------

        menuPages(
            PersonData(),
            Image.asset("images/個人資料.png",
                height: sizeWidth * 0.13, width: sizeWidth * 0.14),
            context,
            "個人資料",
            15),
        Divider(color: Colors.grey),
        // -------------------------------

        menuPages(
            Settings(),
            Icon(Icons.settings,
                size: sizeWidth * 0.13,
                color: Color.fromARGB(255, 0, 160, 233)),
            context,
            "設定"),

        Divider(color: Colors.grey),
        // -------------------------------

        menuPages(
            Login(),
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
