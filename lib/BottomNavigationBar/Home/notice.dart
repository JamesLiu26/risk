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
                  size.width * 0.95,
                  Color(0xffbd2115),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(Icons.block,
                            color: Colors.red, size: size.height * 0.13),
                        textStyle("食物", size.width * 0.045),
                        textStyle(
                            "加工食品：精緻糕點\n高膽固醇：動物內臟\n高糖水果：荔枝、葡萄\n辛燥傷陰：辣椒、蒜苗\n黃豆製品",
                            size.width * 0.045)
                      ])),
              block(
                  size.width * 0.95,
                  Colors.brown,
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(children: [
                          Icon(Icons.info,
                              color: Colors.amber, size: size.height * 0.13),
                          textStyle("重要", size.width * 0.045)
                        ]),
                        textStyle(
                            "少鹽少油少加工\n注意含醣的食物\n(水果、雜糧、乳品)\n維持理想的體重\n攝取六大類食物",
                            size.width * 0.045)
                      ])),
              block(
                  size.width * 0.95,
                  Colors.indigo,
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        textStyle("多吃多喝多尿\n眼前視線模糊\n體重莫名下降\n牙齦反覆發炎\n容易感到疲勞",
                            size.width * 0.045),
                        Column(
                          children: [
                            Icon(Icons.sell,
                                color: Colors.green, size: size.height * 0.13),
                            textStyle("糖尿病前期", size.width * 0.045)
                          ],
                        )
                      ]))
            ])));
  }
}

Text textStyle(String text, double fontSize) {
  return Text(text,
      style: TextStyle(
          fontSize: fontSize,
          color: Colors.white,
          letterSpacing: 1.5,
          height: 1.5));
}

Container block(double width, Color color, Widget child) {
  return Container(
      width: width,
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
      child: child);
}
