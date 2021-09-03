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
  final int data;
  SeriesDatas(this.time, this.data);
}

class _TraceState extends State<Trace> {
  var serial = [
    SeriesDatas(1, 81),
    SeriesDatas(2, 90),
    SeriesDatas(3, 120),
    SeriesDatas(4, 86),
  ];
  double avg() {
    int sum = 0;
    for (int i = 0; i < serial.length; i++) {
      sum += serial[i].data;
    }
    return sum / serial.length;
  }

  var serial2 = [
    SeriesDatas(0, 80),
    SeriesDatas(1, 80),
    SeriesDatas(2, 80),
    SeriesDatas(3, 80),
    SeriesDatas(4, 80),
  ];
  var serial3 = [
    SeriesDatas(0, 180),
    SeriesDatas(1, 180),
    SeriesDatas(2, 180),
    SeriesDatas(3, 180),
    SeriesDatas(4, 180),
  ];

  charts.Series<SeriesDatas, int> seriesList(id, color, data) {
    return charts.Series<SeriesDatas, int>(
      id: id,
      colorFn: (_, __) => color,
      //定義線的顏色
      domainFn: (SeriesDatas sales, _) => sales.time,
      measureFn: (SeriesDatas sales, _) => sales.data,
      data: data,
    );
  }

  Widget chart() {
    List<charts.Series<SeriesDatas, int>> sList = [
      seriesList('血糖值', charts.MaterialPalette.blue.shadeDefault, serial),
      seriesList('下限值', charts.MaterialPalette.red.shadeDefault, serial2),
      seriesList('上限值', charts.MaterialPalette.red.shadeDefault, serial3)
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
      child: new Container(
        height: 300,
        width: 500,
        child: chart,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: menu(context),
        appBar: appBar("每日追蹤", menuButton()),
        body: Center(
          child: Column(
            children: [
              chart(),
              Text(avg().toString(), style: TextStyle(fontSize: 16))
            ],
          ),
        ));
  }
}
