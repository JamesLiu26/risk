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

class BloodSugarPie {
  final String level;
  int times;
  final Color color;
  BloodSugarPie(this.level, this.times, this.color);
}

class BloodSugarLine {
  final DateTime day;
  final double bsValue;
  BloodSugarLine(this.day, this.bsValue);
}

class _TraceState extends State<Trace> {
  @override
  void initState() {
    super.initState();
    pieList = [
      BloodSugarPie("低", low, Colors.blue),
      BloodSugarPie("正常", normal, Colors.green),
      BloodSugarPie("高", high, Colors.red)
    ];
    // 一開始顯示飯前
    getPieLineData("before");
  }

  String phNum = FirebaseAuth.instance.currentUser!.phoneNumber!;
  CollectionReference collection =
      FirebaseFirestore.instance.collection("user");
  //
  final bsCon = TextEditingController();
  DateTime? setDate;
  TimeOfDay? setTime;
  DateTime? dateTime;
  String dateTimeString = "選擇";
  int low = 0, normal = 0, high = 0;

  late List<BloodSugarPie> pieList;
  List<BloodSugarLine> lineList = [];

  void getPieLineData(String type) {
    // 每次執行清空lineList的值(因為list.add會一直新增)
    lineList.clear();
    //
    // 計算血糖程度低、正常、高各幾次
    low = 0;
    normal = 0;
    high = 0;
    int lowBS = 0;
    int highBS = 0;
    //
    collection.doc(phNum).collection(type).get().then((snapshot) {
      for (var query in snapshot.docs) {
        // 將document的id轉成日期格式
        DateTime time = DateTime.parse(query.id);
        double val = double.parse(query.get("bloodSugar"));
        // 新增資料到lineList裡(用於折線圖)
        lineList.add(BloodSugarLine(time, val));

        // 判斷是飯前or飯後，界定標準值
        if (type == "before") {
          lowBS = 70;
          highBS = 99;
        } else {
          lowBS = 80;
          highBS = 139;
        }
        // 判斷血糖介於何處
        if (val < lowBS)
          low += 1;
        else if (val < highBS)
          normal += 1;
        else
          high += 1;
      }
      setState(() {
        pieList = [
          BloodSugarPie("低", low, Colors.blue),
          BloodSugarPie("正常", normal, Color(0xff43a047)),
          BloodSugarPie("高", high, Colors.red)
        ];
      });
    });
  }

  Future<void> chooseDateTime() async {
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
      // 選擇小時、分鐘
      setTime = await showTimePicker(
          // 更改顏色
          builder: (conetxt, child) => Theme(
              child: child!,
              data: ThemeData.light().copyWith(
                  colorScheme: ColorScheme.light(primary: Color(0xff1565c0)))),
          context: context,
          initialTime: TimeOfDay.now());
      if (setTime != null) {
        setState(() {
          // 儲存日期
          dateTime = DateTime(setDate!.year, setDate!.month, setDate!.day,
              setTime!.hour, setTime!.minute);

          // print("DateTime:${dateTime.toString()}");
          // 日期轉成字串格式
          dateTimeString = DateFormat("yyyy-MM-dd HH:mm").format(dateTime!);
        });
      }
    }
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
        if (selIndex == 0) {
          boolVal[0] = true;
          boolVal[1] = false;
          getPieLineData("before");
        } else {
          boolVal[0] = false;
          boolVal[1] = true;
          getPieLineData("after");
        }
      },
    );
  }

  Text traceStyle(String text) {
    double fontSize = MediaQuery.of(context).size.width * 0.055;
    return Text(text, style: TextStyle(fontSize: fontSize));
  }

  pieChart() {
    double fontSize = MediaQuery.of(context).size.width * 0.05;
    return SfCircularChart(
        title: ChartTitle(
            text: "分布程度",
            textStyle: TextStyle(fontSize: fontSize),
            alignment: ChartAlignment.near),
        legend: Legend(
            textStyle: TextStyle(fontSize: fontSize),
            position: LegendPosition.left,
            isVisible: true),
        series: [
          PieSeries<BloodSugarPie, String>(
            animationDuration: 0,
            dataSource: pieList,
            dataLabelSettings: DataLabelSettings(
                isVisible: true, textStyle: TextStyle(fontSize: fontSize)),
            xValueMapper: (data, _) => data.level,
            yValueMapper: (data, _) => data.times,
            pointColorMapper: (data, _) => data.color,
          )
        ]);
  }

  lineChart() {
    double screenWidth = MediaQuery.of(context).size.width;
    return SfCartesianChart(
        margin: EdgeInsets.fromLTRB(10, 10, 20, 20),
        title: ChartTitle(
            text: "記錄\n",
            textStyle: TextStyle(fontSize: screenWidth * 0.05),
            alignment: ChartAlignment.near),
        primaryXAxis: DateTimeAxis(dateFormat: DateFormat.Md()),
        series: [
          LineSeries<BloodSugarLine, DateTime>(
            animationDuration: 0,
            dataSource: lineList,
            dataLabelSettings: DataLabelSettings(
                isVisible: true,
                textStyle: TextStyle(fontSize: screenWidth * 0.04)),
            xValueMapper: (data, _) => data.day,
            yValueMapper: (data, _) => data.bsValue,
          )
        ]);
  }

  snackBar(Color color, String text) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: color,
        content:
            Text(text, style: TextStyle(fontSize: 16, color: Colors.white)),
        duration: Duration(seconds: 1)));
  }

  void addData(String type) {
    collection
        .doc(phNum)
        .collection(type)
        .doc(dateTimeString)
        .set({"bloodSugar": bsCon.text});
    snackBar(Color(0xff4caf50), "已成功送出！");
    bsCon.clear();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    boxPadding(Widget child) =>
        Padding(padding: EdgeInsets.fromLTRB(30, 10, 0, 10), child: child);
    return Scaffold(
        drawer: menu(context),
        appBar: appBar("每日追蹤", menuButton()),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                //
                boxPadding(Row(children: [
                  traceStyle("量測日期："),
                  // 選擇量測日期button
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
                        chooseDateTime();
                      },
                      child: traceStyle(dateTimeString))
                ])),
                //
                boxPadding(Row(children: [
                  traceStyle("類型："),
                  // 選擇飯前飯後button
                  riceButton(),
                ])),
                //
                boxPadding(Row(children: [
                  traceStyle("血糖："),
                  // 輸入血糖值
                  SizedBox(width: screenWidth * 0.35, child: bsField()),
                ])),
                traceStyle("\n飯前血糖：70~99mg/dL\n飯後血糖：80~139mg/dL\n"),
                //
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
                        addData("before");
                      } else {
                        addData("after");
                      }
                    },
                    child: traceStyle("提交")),
                Container(
                    margin: EdgeInsets.only(top: 10, bottom: 20),
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10)),
                    width: screenWidth * 0.95,
                    child: pieChart()),
                Container(
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10)),
                    width: screenWidth * 0.95,
                    child: lineChart()),
              ],
            ),
          ),
        ));
  }
}
