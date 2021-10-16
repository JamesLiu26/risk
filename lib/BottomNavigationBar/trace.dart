import 'package:flutter/material.dart';
import '../menu.dart';
import '../appBar.dart';

import 'package:charts_flutter/flutter.dart' as charts;

void main() {
  return runApp(MaterialApp(
    home: Trace(),
    debugShowCheckedModeBanner: false,
  ));
}

class Trace extends StatefulWidget {
  @override
  _TraceState createState() => _TraceState();
}

class BloodSugar {
  final int time;
  double data;
  BloodSugar(this.time, this.data);
}

class _TraceState extends State<Trace> {
  var beforeBS = [
    // 資料從1開始
    BloodSugar(0, 0),
    BloodSugar(1, 0),
    BloodSugar(2, 0),
    BloodSugar(3, 0),
  ];
  var afterBS = [
    // 資料從1開始
    BloodSugar(0, 0),
    BloodSugar(1, 0),
    BloodSugar(2, 0),
    BloodSugar(3, 0),
  ];

  var eatBefore = [
    BloodSugar(0, 100),
    BloodSugar(1, 100),
    BloodSugar(2, 100),
    BloodSugar(3, 100),
  ];

  var eat2Hours = [
    BloodSugar(0, 140),
    BloodSugar(1, 140),
    BloodSugar(2, 140),
    BloodSugar(3, 140),
  ];

  charts.Series<BloodSugar, num> seriesList(id, color, data) {
    return charts.Series<BloodSugar, num>(
      id: id,
      colorFn: (_, __) => color,
      //定義線的顏色
      domainFn: (BloodSugar sales, _) => sales.time,
      measureFn: (BloodSugar sales, _) => sales.data,
      data: data,
    );
  }

  Widget bChart() {
    Size size = MediaQuery.of(context).size;
    List<charts.Series<BloodSugar, num>> list = [
      seriesList('危險值', charts.MaterialPalette.red.shadeDefault, eatBefore),
      seriesList('飯前血糖量測值', charts.MaterialPalette.blue.shadeDefault, beforeBS),
    ];
    var chart = charts.LineChart(
      list,
      animate: true,
      behaviors: [
        charts.SeriesLegend(
            position: charts.BehaviorPosition.bottom,
            horizontalFirst: false,
            cellPadding: EdgeInsets.all(4),
            showMeasures: true, //是否顯示資料
            measureFormatter: (num? value) =>
                value == null ? '_' : '${value}mg/dL')
      ],
    );
    return Padding(
      padding: EdgeInsets.all(16),
      child: Container(
        height: size.height * 0.4,
        width: size.width,
        child: chart,
      ),
    );
  }

  Widget aChart() {
    Size size = MediaQuery.of(context).size;
    List<charts.Series<BloodSugar, num>> list = [
      seriesList('危險值', charts.MaterialPalette.red.shadeDefault, eat2Hours),
      seriesList('飯後血糖量測值', charts.MaterialPalette.green.shadeDefault, afterBS)
    ];
    var chart = charts.LineChart(
      list,
      animate: true,
      behaviors: [
        charts.SeriesLegend(
            position: charts.BehaviorPosition.bottom,
            horizontalFirst: false,
            cellPadding: EdgeInsets.all(4),
            showMeasures: true, //是否顯示資料
            measureFormatter: (num? value) =>
                value == null ? '_' : '${value}mg/dL')
      ],
    );
    return Padding(
      padding: EdgeInsets.all(16),
      child: Container(
        height: size.height * 0.4,
        width: size.width,
        child: chart,
      ),
    );
  }

  final beforeCon = TextEditingController();
  final afterCon = TextEditingController();
  int bCount = 1;
  int aCount = 1;
  int bDanger = 100;
  int aDanger = 140;
  String type = "目前為三餐飯前血糖";
  void addBefore() {
    setState(() {
      if (bCount <= 3) {
        if (beforeCon.text != "0" && beforeCon.text != "") {
          beforeBS[bCount].data = double.parse(beforeCon.text);
          bCount++;
        }
      }
    });
  }

  void addAfter() {
    setState(() {
      if (aCount <= 3) {
        if (afterCon.text != "0" && afterCon.text != "") {
          afterBS[aCount].data = double.parse(afterCon.text);
          aCount++;
        }
      }
    });
  }

  Icon? showIcon(TextEditingController con, int danger) {
    if (con.text != "0" && con.text != "") {
      if (double.parse(con.text) < danger) {
        return Icon(Icons.check_circle, color: Colors.green, size: 50);
      } else {
        return Icon(Icons.cancel, color: Colors.red, size: 50);
      }
    } else {
      return null;
    }
  }

  Padding beforeMeasure() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: TextField(
        controller: beforeCon,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            labelText: "請輸入飯前血糖",
            floatingLabelBehavior: FloatingLabelBehavior.never,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        // onSubmitted: (_) {
        //   addBefore();
        // },
      ),
    );
  }

  Padding afterMeasure() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: TextField(
        controller: afterCon,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            labelText: "請輸入血糖值",
            floatingLabelBehavior: FloatingLabelBehavior.never,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        // onSubmitted: (_) {
        //   addAfter();
        // },
      ),
    );
  }

  List rice = ["飯前", "飯後"];
  List<bool> boolVal = [true, false];
  ToggleButtons riceBA() {
    double screenWidth = MediaQuery.of(context).size.width;
    return ToggleButtons(
      textStyle: TextStyle(fontSize: screenWidth * 0.06),
      children: [Text(rice[0]), Text(rice[1])],
      constraints: BoxConstraints.expand(width: screenWidth * 0.25),
      isSelected: boolVal,
      fillColor: Colors.blue[800],
      selectedColor: Colors.white,
      borderRadius: BorderRadius.circular(20),
      borderColor: Colors.black,
      selectedBorderColor: Colors.black,
      //
      onPressed: (selIndex) {
        setState(() {
          if (selIndex == 0) {
            boolVal[0] = true;
            boolVal[1] = false;
          } else {
            boolVal[0] = false;
            boolVal[1] = true;
          }
        });
      },
    );
  }

  Text traceStyle(String text) {
    double fontSize = MediaQuery.of(context).size.width * 0.05;
    return Text(text, style: TextStyle(fontSize: fontSize));
  }

  @override
  Widget build(BuildContext context) {
    double fontSize = MediaQuery.of(context).size.width * 0.06;
    return Scaffold(
        drawer: menu(context),
        appBar: appBar("每日追蹤", menuButton()),
        body: SingleChildScrollView(
            child: Center(
          child: Column(
            children: [
              SizedBox(height: 20),
              Text(
                "血糖值量測(mg/dL)\n",
                style: TextStyle(fontSize: fontSize),
                textAlign: TextAlign.center,
              ),
              riceBA(),
              beforeMeasure(),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0xFF1565C0))),
                  onPressed: () {},
                  child: Text("提交", style: TextStyle(fontSize: fontSize)))

              // type == "目前為三餐飯前血糖"
              //     ? Column(children: [
              //         bChart(),
              //         beforeMeasure(),
              //         SizedBox(child: showIcon(beforeCon, bDanger)),
              //       ])
              //     : Column(children: [
              //         aChart(),
              //         afterMeasure(),
              //         SizedBox(child: showIcon(afterCon, aDanger))
              //       ]),
              // SizedBox(height: 10),
              // ElevatedButton(
              //     onPressed: () {
              //       setState(() {});
              //       if (type == "目前為三餐飯前血糖")
              //         type = "目前為三餐飯後血糖";
              //       else
              //         type = "目前為三餐飯前血糖";
              //     },
              //     child: Text(type, style: TextStyle(fontSize: fontSize)))
            ],
          ),
        )));
  }
}
