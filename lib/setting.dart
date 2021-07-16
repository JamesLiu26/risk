import 'package:flutter/material.dart';
import './appBar.dart';
import './contact.dart';

void main() => runApp(MaterialApp(
      home: Settings(),
      debugShowCheckedModeBanner: false,
    ));

class Settings extends StatelessWidget {
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
          settingPages(Text("1"), context, "提醒時間"),
          underline(context),
          settingPages(Contact(), context, "醫院聯絡方式"),
          underline(context),
          settingPages(Text("1"), context, "意見回饋"),
          underline(context),
          Spacer(flex: 8)
        ],
      ),
    );
  }
}

Container underline(BuildContext context) {
  return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10),
      height: 1,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(color: Colors.grey));
}

GestureDetector settingPages(Widget route, BuildContext context, String text) {
  return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => route));
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
                    fontSize: MediaQuery.of(context).size.width * 0.05),
              ),
            ],
          )));
}
