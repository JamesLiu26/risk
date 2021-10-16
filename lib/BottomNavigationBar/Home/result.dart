import 'package:flutter/material.dart';

import '/appBar.dart';

class Result extends StatelessWidget {
  final int total;
  Result(this.total);
  @override
  Widget build(BuildContext context) {
    tbcenter(String text, [color = Colors.black]) {
      return Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: MediaQuery.of(context).size.width * 0.07,
        ),
        textAlign: TextAlign.center,
      );
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
            children: [
              SizedBox(height: 30),
              Row(children: [
                tbcenter("  分數如下："),
                tbcenter(total.toString(), Colors.red),
                tbcenter("分"),
              ]),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Table(
                    border: TableBorder.all(
                        color: Colors.black87,
                        width: 2.0,
                        style: BorderStyle.solid),
                    columnWidths: <int, TableColumnWidth>{
                      0: FlexColumnWidth(),
                      1: FlexColumnWidth(3),
                    },
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: <TableRow>[
                      TableRow(
                        children: [
                          Text(
                            "分數",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05),
                          ),
                          Text(
                            "評語",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05),
                          )
                        ],
                      ),
                      TableRow(
                          decoration: BoxDecoration(color: Colors.green[50]),
                          children: [
                            TableCell(
                              child: Container(child: tbcenter("0~6")),
                            ),
                            TableCell(
                                child: Container(
                                    child: Text("屬於安全地帶，罹病風險低，但需要密切注意自身身體。",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.05))))
                          ]),
                      TableRow(children: [
                        TableCell(child: Container(child: tbcenter("7~15"))),
                        TableCell(
                            child: Container(
                                child: Text("很有可能罹患糖尿病，需改變生活習慣及飲食。",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.05,
                                    ))))
                      ]),
                      TableRow(
                          decoration: BoxDecoration(color: Colors.green[50]),
                          children: [
                            TableCell(
                                child: Container(child: tbcenter("16~22"))),
                            TableCell(
                                child: Container(
                                    child: Text("須立刻找尋醫師幫助，發現問題，立即處理。",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.05,
                                        ))))
                          ]),
                    ]),
              ),
            ],
          ),
        ));
  }
}
