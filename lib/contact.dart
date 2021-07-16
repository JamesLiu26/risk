import 'package:flutter/material.dart';
import './appBar.dart';

void main() {
  return runApp(MaterialApp(
    home: Contact(),
    debugShowCheckedModeBanner: false,
  ));
}

class Contact extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(
          "醫院聯絡方式",
          IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.blue[800]),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            contactText(" 亞東醫院地址：\n  220新北市板橋區南雅南路二段21號",
                MediaQuery.of(context).size.width * 0.05),
            contactText(
                " 服務時間：8:00~17:00", MediaQuery.of(context).size.width * 0.05),
            contactText(" 總機(24hrs)：(02)8966-7000",
                MediaQuery.of(context).size.width * 0.05),
            contactText(
                " 顧客服務中心：\n  服務時間：8:30~16:30\n  幫您專線：(02)7738-2525\n  E-Mail：CRC@mail.femh.org.tw",
                MediaQuery.of(context).size.width * 0.05),
            contactText(" 服務台：(02)8966-7000轉2144",
                MediaQuery.of(context).size.width * 0.05),
            contactText(" 亞東醫院網址：www.femh.org.tw",
                MediaQuery.of(context).size.width * 0.05),
          ],
        ));
  }
}

Text contactText(String text, double fontSize) {
  return Text(text, style: TextStyle(fontSize: fontSize));
}
