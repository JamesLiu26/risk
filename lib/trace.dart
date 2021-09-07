import 'package:flutter/material.dart';
import './menu.dart';
import './appBar.dart';

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

class SeriesDatas {
  final int time;
  double data;
  SeriesDatas(this.time, this.data);
}

class _TraceState extends State<Trace> {
  var currentBloodSugar = [
    SeriesDatas(1, 0),
    SeriesDatas(2, 0),
    SeriesDatas(3, 0),
    SeriesDatas(4, 0),
  ];

  var lowBloodSugar = [
    SeriesDatas(0, 70),
    SeriesDatas(1, 70),
    SeriesDatas(2, 70),
    SeriesDatas(3, 70),
    SeriesDatas(4, 70),
  ];
  var eatBefore = [
    SeriesDatas(0, 100),
    SeriesDatas(1, 100),
    SeriesDatas(2, 100),
    SeriesDatas(3, 100),
    SeriesDatas(4, 100),
  ];

  var eat2Hours = [
    SeriesDatas(0, 140),
    SeriesDatas(1, 140),
    SeriesDatas(2, 140),
    SeriesDatas(3, 140),
    SeriesDatas(4, 140),
  ];

  charts.Series<SeriesDatas, num> seriesList(id, color, data) {
    return charts.Series<SeriesDatas, num>(
      id: id,
      colorFn: (_, __) => color,
      //定義線的顏色
      domainFn: (SeriesDatas sales, _) => sales.time,
      measureFn: (SeriesDatas sales, _) => sales.data,
      data: data,
    );
  }

  Widget chart() {
    Size size = MediaQuery.of(context).size;
    List<charts.Series<SeriesDatas, num>> sList = [
      seriesList(
          '飯後2小時血糖危險值', charts.MaterialPalette.red.shadeDefault, eat2Hours),
      seriesList(
          '飯前血糖危險值', charts.MaterialPalette.purple.shadeDefault, eatBefore),
      seriesList(
          '低血糖', charts.MaterialPalette.cyan.shadeDefault, lowBloodSugar),
      seriesList(
          '量測之血糖值', charts.MaterialPalette.blue.shadeDefault, currentBloodSugar)
    ];
    var chart = charts.LineChart(
      sList,
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
        height: size.height * 0.5,
        width: size.width,
        child: chart,
      ),
    );
  }

  //計算量測次數
  int count = 0;
  double bloodSugarAverage() {
    double sum = 0;
    for (int i = 0; i < currentBloodSugar.length; i++) {
      sum += currentBloodSugar[i].data;
    }
    return sum / currentBloodSugar.length;
  }

  final bloodSugar = TextEditingController();
  String? error;

  @override
  Widget build(BuildContext context) {
    double fontSize = MediaQuery.of(context).size.width * 0.05;
    return Scaffold(
        drawer: menu(context),
        appBar: appBar("每日追蹤", menuButton()),
        body: SingleChildScrollView(
            child: Center(
          child: Column(
            children: [
              SizedBox(height: 20),
              Text(
                "今日血糖值量測次數：$count次\n點擊圖形即可查看數值",
                style: TextStyle(fontSize: fontSize),
                textAlign: TextAlign.center,
              ),
              chart(),
              // count!=4，輸入血糖值，直到次數為4為止
              count != 4
                  ? Column(children: [
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: TextField(
                          controller: bloodSugar,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              labelText: "血糖值",
                              hintText: "單位：mg/dL",
                              errorText: error,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          onSubmitted: (_) {
                            error = null;
                            setState(() {
                              if (bloodSugar.text != "0" &&
                                  bloodSugar.text != "") {
                                currentBloodSugar[count].data =
                                    double.parse(bloodSugar.text);
                                count++;
                              } else
                                error = "請輸入正常數值！";
                            });
                          },
                        ),
                      ),
                    ])
                  // 次數=4，輸入框拿掉，並顯示當日平均血糖值
                  : Text(
                      "今日血糖平均值：" +
                          bloodSugarAverage().toStringAsFixed(1) +
                          "mg/dL",
                      style: TextStyle(fontSize: fontSize))
            ],
          ),
        )));
  }
}
