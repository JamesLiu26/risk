import 'package:flutter/material.dart';
import '/appBar.dart';

class Notice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
                  size.width * 0.9,
                  Color(0xffbd2115),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(Icons.block,
                            color: Colors.red, size: size.height * 0.13),
                        textStyle("需注意食物", size.width * 0.05),
                        textStyle(
                            "1. 加工食品：精緻糕點\n2. 高膽固醇：動物內臟\n3. 高糖水果：荔枝、葡萄\n4. 辛燥傷陰：辣椒、蒜苗\n5. 黃豆製品",
                            size.width * 0.05)
                      ])),
              block(
                  size.width * 0.9,
                  Colors.brown,
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(children: [
                          Icon(Icons.info,
                              color: Colors.amber, size: size.height * 0.13),
                          textStyle("重點摘要", size.width * 0.05)
                        ]),
                        textStyle(
                            "1. 少鹽少油少加工\n2. 注意含醣的食物\n(水果、全榖雜糧、乳品)\n3. 維持理想的體重\n4. 攝取六大類食物",
                            size.width * 0.05)
                      ])),
              block(
                  size.width * 0.9,
                  Colors.indigo,
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        textStyle(
                            "1. 多吃多喝多尿\n2. 眼前視線模糊\n3. 體重莫名下降\n4. 牙齦反覆發炎\n5. 容易感到疲勞",
                            size.width * 0.05),
                        Column(
                          children: [
                            Icon(Icons.sell,
                                color: Colors.green, size: size.height * 0.13),
                            textStyle("糖尿病前期症狀", size.width * 0.05)
                          ],
                        )
                      ]))
            ])));
  }
}

Text textStyle(String text, double fontSize) {
  return Text(text,
      style: TextStyle(
          fontSize: fontSize, color: Colors.white, letterSpacing: 1.5));
}

Container block(double width, Color color, Widget child) {
  return Container(
      width: width,
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
      child: child);
}
