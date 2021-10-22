import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../menu.dart';
import '../appBar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// void main() {
//   return runApp(MaterialApp(
//     home: Trace(),
//     debugShowCheckedModeBanner: false,
//   ));
// }

class Trace extends StatefulWidget {
  @override
  _TraceState createState() => _TraceState();
}

class BS {
  final String level;
  double times;
  final Color color;
  BS(this.level, this.times, this.color);
}

class BSline {
  final DateTime day;
  final double bsValue;
  BSline(this.day, this.bsValue);
}

class _TraceState extends State<Trace> {
  String phNum = FirebaseAuth.instance.currentUser!.phoneNumber!;
  CollectionReference collection =
      FirebaseFirestore.instance.collection("user");
  //
  final bsCon = TextEditingController();
  DateTime? setDate;
  // TimeOfDay? setTime;
  // DateTime? dateTime;
  String dateTimeString = "選擇";
  double low = 0, normal = 0, high = 0;

  late List<BS> bs;
  @override
  void initState() {
    super.initState();
    bs = [
      BS("低", low, Colors.blue),
      BS("正常", normal, Colors.green),
      BS("高", high, Colors.red)
    ];
    circleCal("before");

    // circleCal("after");
  }

  circleCal(String text) {
    low = 0;
    normal = 0;
    high = 0;
    collection.doc(phNum).collection(text).get().then((snapshot) {
      for (var query in snapshot.docs) {
        int val = int.parse(query.get("bloodSugar"));
        if (val < 70)
          low += 1;
        else if (val < 100)
          normal += 1;
        else
          high += 1;
      }
      setState(() {
        bs = [
          BS("低", low, Colors.blue),
          BS("正常", normal, Color(0xff43a047)),
          BS("高", high, Colors.red)
        ];
      });
    });
  }

  List<BSline> bsline = [
    BSline(DateTime(2021, 10, 22), 80),
    BSline(DateTime(2021, 10, 23), 90),
    BSline(DateTime(2021, 10, 24), 70),
    BSline(DateTime(2021, 10, 25), 120),
    BSline(DateTime(2021, 10, 30), 200),
  ];

  pieChart() {
    return SfCircularChart(
        legend: Legend(
            textStyle: TextStyle(fontSize: 18),
            position: LegendPosition.left,
            isVisible: true),
        series: [
          PieSeries<BS, String>(
              dataSource: bs,
              dataLabelSettings: DataLabelSettings(
                  isVisible: true, textStyle: TextStyle(fontSize: 18)),
              xValueMapper: (data, _) => data.level,
              yValueMapper: (data, _) => data.times,
              pointColorMapper: (data, _) => data.color,
              explode: true)
        ]);
  }

  lineChart() {
    return SfCartesianChart(
        primaryXAxis: DateTimeAxis(dateFormat: DateFormat.Md()),
        series: [
          LineSeries<BSline, DateTime>(
            dataSource: bsline,
            dataLabelSettings: DataLabelSettings(
                isVisible: true, textStyle: TextStyle(fontSize: 14)),
            xValueMapper: (data, _) => data.day,
            yValueMapper: (data, _) => data.bsValue,
          )
        ]);
  }

  Padding bsField() {
    double fontSize = MediaQuery.of(context).size.width * 0.06;
    return Padding(
      padding: EdgeInsets.all(10),
      child: TextField(
        style: TextStyle(fontSize: fontSize),
        inputFormatters: [LengthLimitingTextInputFormatter(6)],
        controller: bsCon,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            labelText: "mg/dL",
            floatingLabelBehavior: FloatingLabelBehavior.never,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      ),
    );
  }

  List rice = ["飯前", "飯後"];
  List<bool> boolVal = [true, false];

  ToggleButtons riceButton() {
    double screenWidth = MediaQuery.of(context).size.width;
    return ToggleButtons(
      textStyle: TextStyle(fontSize: screenWidth * 0.06),
      children: [Text(rice[0]), Text(rice[1])],
      constraints: BoxConstraints.expand(width: screenWidth * 0.15),
      isSelected: boolVal,
      fillColor: Colors.blue[800],
      selectedColor: Colors.white,
      borderRadius: BorderRadius.circular(10),
      borderColor: Colors.black,
      selectedBorderColor: Colors.black,
      //
      onPressed: (selIndex) {
        setState(() {
          if (selIndex == 0) {
            boolVal[0] = true;
            boolVal[1] = false;
            circleCal("before");
          } else {
            boolVal[0] = false;
            boolVal[1] = true;
            circleCal("after");
          }
        });
      },
    );
  }

  Text traceStyle(String text) {
    double fontSize = MediaQuery.of(context).size.width * 0.055;
    return Text(text, style: TextStyle(fontSize: fontSize));
  }

  Future<void> setDateTime() async {
    // 選擇(年月日)
    setDate = await showDatePicker(
        // 更改顏色
        builder: (conetxt, child) => Theme(
            child: child!,
            data: ThemeData.light().copyWith(
                colorScheme: ColorScheme.light(primary: Color(0xff1565c0)))),
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year - 100),
        lastDate: DateTime.now());

    if (setDate != null) {
      // // 選擇小時、分鐘
      // setTime = await showTimePicker(
      //     // 更改顏色
      //     builder: (conetxt, child) => Theme(
      //         child: child!,
      //         data: ThemeData.light().copyWith(
      //             colorScheme: ColorScheme.light(primary: Color(0xff1565c0)))),
      //     context: context,
      //     initialTime: TimeOfDay.now());
      // if (setTime != null) {
      setState(() {
        // 儲存日期
        // dateTime = DateTime(setDate!.year, setDate!.month, setDate!.day,
        //     setTime!.hour, setTime!.minute);
        //
        // print("DateTime:${dateTime.toString()}");
        // 日期轉成字串格式
        dateTimeString = DateFormat("yyyy-MM-dd").format(setDate!);
      });
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    snackBar(Color color, String text) {
      return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: color,
          content:
              Text(text, style: TextStyle(fontSize: 16, color: Colors.white)),
          duration: Duration(seconds: 1)));
    }

    // double fontSize = screenWidth * 0.06;
    return Scaffold(
        drawer: menu(context),
        appBar: appBar("每日追蹤", menuButton()),
        body: Center(
            child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              Row(children: [
                // 選擇量測日期button
                traceStyle("  量測日期："),
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.blue[800])),
                    onPressed: () {
                      setState(() {
                        setDateTime();
                      });
                    },
                    child: traceStyle(dateTimeString))
              ]),
              Row(
                children: [
                  traceStyle("  血糖："),
                  SizedBox(width: screenWidth * 0.35, child: bsField()),
                  riceButton()
                ],
              ),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.blue[800])),
                  onPressed: () {
                    FocusScopeNode focus = FocusScope.of(context);
                    // 把TextField的focus移掉
                    if (!focus.hasPrimaryFocus) {
                      focus.unfocus();
                    }
                    if (setDate == null || bsCon.text == "") {
                      snackBar(Color(0xffc62828), "請填寫完再按送出！");
                    } else if (boolVal[0] == true) {
                      collection
                          .doc(phNum)
                          .collection("before")
                          .doc(dateTimeString)
                          .set({"bloodSugar": bsCon.text});
                      snackBar(Color(0xff4caf50), "已成功送出！");
                    } else {
                      collection
                          .doc(phNum)
                          .collection("after")
                          .doc(dateTimeString)
                          .set({"bloodSugar": bsCon.text});
                      snackBar(Color(0xff4caf50), "已成功送出！");
                    }
                  },
                  child: traceStyle("提交")),
              SizedBox(height: screenHeight * 0.3, child: pieChart()),
              Divider(color: Colors.grey, thickness: 2),
              SizedBox(height: screenHeight * 0.4, child: lineChart()),
            ],
          ),
        )));
  }
}
