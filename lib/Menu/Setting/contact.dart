import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '/appBar.dart';

void main() {
  return runApp(MaterialApp(
    home: Contact(),
    debugShowCheckedModeBanner: false,
  ));
}

class Contact extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double fontSize = MediaQuery.of(context).size.width * 0.045;
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
            contactText("  亞東醫院地址：\n  220新北市板橋區南雅南路二段21號", fontSize),
            contactText("  服務時間：8:00~17:00", fontSize),
            contactText("  總機(24hrs)：(02)8966-7000", fontSize),
            contactText(
                "  顧客服務中心：\n  服務時間：8:30~16:30\n  幫您專線：(02)7738-2525", fontSize),
            contactText("  服務台：(02)8966-7000轉2144", fontSize),
            Row(
              children: [
                contactText("  亞東醫院網址：", fontSize),
                toLinkWeb("www.femh.org.tw", fontSize)
              ],
            ),
          ],
        ));
  }
}

Text contactText(String text, double size) {
  return Text(text,
      style: TextStyle(fontSize: size, letterSpacing: 1, height: 2));
}

Text link(
  String text,
  double size,
) {
  return Text(text,
      style: TextStyle(
          fontSize: size,
          decoration: TextDecoration.underline,
          color: Colors.blue,
          letterSpacing: 1,
          height: 2));
}

GestureDetector toLinkWeb(String url, double size) {
  return GestureDetector(
      child: link(url, size),
      onTap: () async {
        if (await canLaunch("https://$url"))
          launch("https://$url");
        else
          throw "Couldn't launch $url";
      });
}
