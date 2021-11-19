import 'package:flutter/material.dart';
import '/appBar.dart';

class Advice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Text adviceTitle(String text) {
      double titleSize = MediaQuery.of(context).size.width * 0.065;
      return Text(text,
          style: TextStyle(
              color: Colors.blue[700],
              fontSize: titleSize,
              fontWeight: FontWeight.bold));
    }

    Text adviceContent(String text) {
      double contentSize = MediaQuery.of(context).size.width * 0.05;
      return Text(text,
          style: TextStyle(
              color: Colors.black,
              fontSize: contentSize,
              fontWeight: FontWeight.bold));
    }

    Row textLayout(String text1, String text2) {
      return Row(children: [
        Image.asset("images/攝取水分.png", height: 100, width: 100),
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [adviceTitle(text1), adviceContent(text2 + "\n")])
      ]);
    }

    return Scaffold(
        backgroundColor: Color(0xfffff5c0),
        appBar: appBar(
            "飲食建議",
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios, color: Colors.blue[800]))),
        body: Center(
          child: Column(
            children: [
              textLayout("低糖蔬菜", "韭菜 冬瓜 綠葉青菜\n青椒 紫茄子 苦瓜"),
              textLayout("攝取鈣質", "海帶 芝麻 黃豆 牛奶"),
              textLayout("含硒食物", "魚類 白菜 青菜\n韭菜 豆類食品 橄欖"),
              textLayout("富含纖維素", "未加工的豆類、水果\n蔬菜、全穀類"),
              textLayout("攝取水分", "依據個人飲用適量水分"),
            ],
          ),
        ));
  }
}
