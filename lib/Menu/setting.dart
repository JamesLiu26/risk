import 'package:flutter/material.dart';
import '/appBar.dart';
import 'Setting/contact.dart';
// import 'Setting/feedback.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MaterialApp(
      home: Setting(),
      debugShowCheckedModeBanner: false,
    ));

class Setting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        "設定",
        IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.blue[800]),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Spacer(flex: 1),
          settingPages(context, "提醒時間"),
          Divider(color: Colors.grey),
          settingPages(context, "醫院聯絡方式"),
          Divider(color: Colors.grey),
          settingPages(context, "意見回饋"),
          Divider(color: Colors.grey),
          Spacer(flex: 10)
        ],
      ),
    );
  }
}

GestureDetector settingPages(BuildContext context, String text) {
  String mail = "fkproject123@gmail.com";
  Future<void> toMail() async {
    if (await canLaunch("mailto:$mail")) {
      launch("mailto:$mail");
    } else {
      throw "Error!";
    }
  }

  return GestureDetector(
    onTap: () {
      if (text == "提醒時間") {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Text("1")));
      } else if (text == "醫院聯絡方式") {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Contact()));
      } else if (text == "意見回饋") {
        toMail();
      }
    },
    child: Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.05,
                  height: 2),
            ),
          ],
        )),
  );
}
