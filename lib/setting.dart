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
          Divider(color: Colors.grey),
          settingPages(Contact(), context, "醫院聯絡方式"),
          Divider(color: Colors.grey),
          settingPages(Text("1"), context, "意見回饋"),
          Divider(color: Colors.grey),
          Spacer(flex: 8)
        ],
      ),
    );
  }
}

GestureDetector settingPages(Widget route, BuildContext context, String text) {
  return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => route));
      },
      child: Container(
          margin: EdgeInsets.all(8),
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
