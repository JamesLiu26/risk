import 'package:flutter/material.dart';
import 'package:risk/appBar.dart';

void main() {
  runApp(MaterialApp(
    home: PersonData(),
    theme: ThemeData(),
    debugShowCheckedModeBanner: false,
  ));
}

class PersonData extends StatefulWidget {
  @override
  _PersonDataState createState() => _PersonDataState();
}

class _PersonDataState extends State<PersonData> {
  Container block(Widget child) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [BoxShadow(color: Colors.black, blurRadius: 1)]),
        child: child);
  }

  Text textStyle(String text) {
    return Text(text,
        style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.05));
  }

  Padding textLayout(String text1, String text2) {
    return Padding(
      padding: EdgeInsets.only(left: 16, top: 10, bottom: 10),
      child: Row(children: [textStyle(text1 + "\n" + text2)]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(
          "個人資料",
          IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.blue[800]),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Center(
            child: SingleChildScrollView(
          child: Column(children: [
            Row(children: [textStyle("\n  基本資料")]),
            textLayout("姓名", "XXX"),
            textLayout("性別", "男"),
            textLayout("血型", "X型"),
            textLayout("年齡", "21歲"),
            textLayout("生日", "2021-07-28"),
            textLayout("行動電話", "0998765432"),
            Divider(
              color: Colors.grey,
            ),
            Row(children: [textStyle("  體態")]),
            textLayout("身高", "200cm"),
            textLayout("體重", "100kg"),
            Divider(
              color: Colors.grey,
            ),
            Row(children: [textStyle("  聯絡方式")]),
            textLayout("通訊地址", "XX市XX區XX路"),
            textLayout("電子郵件", "123@gmail.com"),
            Divider(
              color: Colors.grey,
            ),
            Row(children: [textStyle("  緊急聯絡人資料")]),
            textLayout("姓名", "AAA"),
            textLayout("關係", "XX"),
            textLayout("行動電話", "0912345678"),
          ]),
        )));
  }
}
