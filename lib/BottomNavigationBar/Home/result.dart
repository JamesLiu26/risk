import 'package:flutter/material.dart';

import '/change.dart';
import '/appBar.dart';

class Result extends StatelessWidget {
  final int total;
  Result(this.total);
  @override
  Widget build(BuildContext context) {
    Padding tbCenter(String text, [fontWeight = FontWeight.normal]) {
      return Padding(
          padding: EdgeInsets.only(top: 8, bottom: 8),
          child: Text(
            text,
            style: TextStyle(
                color: Colors.black,
                fontSize: MediaQuery.of(context).size.width * 0.06,
                fontWeight: fontWeight),
            textAlign: TextAlign.center,
          ));
    }

    Padding tbContent(String text) {
      return Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            text,
            style: TextStyle(
                color: Colors.black,
                fontSize: MediaQuery.of(context).size.width * 0.06,
                letterSpacing: 1.5),
            textAlign: TextAlign.left,
          ));
    }

    return Scaffold(
        appBar: appBar(
            "問卷調查",
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios, color: Colors.blue[800]))),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                tbCenter("  分數："),
                Text(total.toString(),
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.1,
                        color: Colors.red,
                        fontWeight: FontWeight.bold)),
                tbCenter("分"),
              ]),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Table(
                    border: TableBorder.all(
                        color: Colors.black87,
                        width: 2.0,
                        style: BorderStyle.solid),
                    columnWidths: {
                      0: FlexColumnWidth(),
                      1: FlexColumnWidth(3),
                    },
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      TableRow(
                        children: [
                          tbCenter("分數", FontWeight.bold),
                          tbCenter("評語", FontWeight.bold)
                        ],
                      ),
                      TableRow(
                          decoration: BoxDecoration(color: Colors.green[50]),
                          children: [
                            TableCell(child: tbCenter("0~6")),
                            TableCell(child: tbContent("罹病風險低，但需要密切注意自身身體。"))
                          ]),
                      TableRow(children: [
                        TableCell(child: tbCenter("7~15")),
                        TableCell(child: tbContent("很有可能罹患糖尿病，需改變生活習慣及飲食。"))
                      ]),
                      TableRow(
                          decoration: BoxDecoration(color: Colors.green[50]),
                          children: [
                            TableCell(child: tbCenter("16~22")),
                            TableCell(child: tbContent("須立刻找尋醫師幫助，發現問題，立即處理。"))
                          ]),
                    ]),
              ),
              OutlinedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green)),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => Change()),
                        (Route route) => false);
                  },
                  child: Text("返回首頁",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width * 0.06)))
            ],
          ),
        ));
  }
}
