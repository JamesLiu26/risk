import 'package:flutter/material.dart';
import '/appBar.dart';

class Notice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    double iconSize = screenWidth * 0.25;
    //
    Container block(Color color, Widget child) {
      double blockWidth = screenWidth * 0.95;
      return Container(
          width: blockWidth,
          padding: EdgeInsets.only(top: 5, bottom: 5),
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(10)),
          child: child);
    }

    Text textStyle(String text) {
      double fontSize = screenWidth * 0.055;
      return Text(text,
          style: TextStyle(
              fontSize: fontSize,
              color: Colors.white,
              letterSpacing: 1.5,
              height: 1.5));
    }

    return Scaffold(
      appBar: appBar(
          "注意事項",
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios, color: Colors.blue[800]))),
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
            block(
                Color(0xffbd2115),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      textStyle("加工食品 精緻糕點\n高膽固醇 動物內臟\n高糖水果 荔枝、葡萄\n辛燥傷陰 辣椒、蒜苗"),
                      Column(children: [
                        Icon(Icons.block, color: Colors.red, size: iconSize),
                        textStyle("食物"),
                      ])
                    ])),
            block(
                Colors.brown,
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(children: [
                        Icon(Icons.info, color: Colors.amber, size: iconSize),
                        textStyle("重要")
                      ]),
                      textStyle("少鹽少油少加工\n注意含醣的食物\n維持理想的體重\n攝取六大類食物")
                    ])),
            block(
                Colors.indigo,
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      textStyle("多吃多喝多尿\n眼前視線模糊\n體重莫名下降\n牙齦反覆發炎\n容易感到疲勞"),
                      Column(
                        children: [
                          Icon(Icons.sell, color: Colors.green, size: iconSize),
                          textStyle("糖尿病前期")
                        ],
                      )
                    ])),
          ])),
    );
  }
}
