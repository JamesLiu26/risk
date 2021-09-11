import 'package:flutter/material.dart';
import '../appBar.dart';

// MediaQuery.of(context).size.width * 0.05
void main() {
  runApp(MaterialApp(
    home: PersonData(),
    debugShowCheckedModeBanner: false,
  ));
}

class PersonData extends StatefulWidget {
  @override
  _PersonDataState createState() => _PersonDataState();
}

class _PersonDataState extends State<PersonData> {
  Text textStyle(String text, [double rate = 0.045]) {
    return Text(text,
        style: TextStyle(fontSize: MediaQuery.of(context).size.width * rate));
  }

  Padding textLayout(String text1, String text2) {
    return Padding(
      padding: EdgeInsets.only(left: 14, top: 10, bottom: 10, right: 14),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [textStyle(text1), textStyle(text2)]),
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
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: textStyle("  基本資料", 0.05),
            ),
            textLayout("姓名", "XXX"),
            textLayout("性別", "男"),
            textLayout("血型", "X型"),
            textLayout("生日", "2000-07-28"),
            textLayout("行動電話", "0998765432"),
            Divider(
              color: Colors.grey,
            ),
            Row(children: [textStyle("  體態", 0.05)]),
            textLayout("身高", "200cm"),
            textLayout("體重", "100kg"),
            Divider(
              color: Colors.grey,
            ),
            Row(children: [textStyle("  聯絡方式", 0.05)]),
            textLayout("通訊地址", "XX市XX區XX路"),
            textLayout("電子郵件", "123@gmail.com"),
            Divider(
              color: Colors.grey,
            ),
            Row(children: [textStyle("  緊急聯絡人資料", 0.05)]),
            textLayout("姓名", "AAA"),
            textLayout("關係", "XX"),
            textLayout("行動電話", "0912345678"),
          ]),
        )));
  }
}
