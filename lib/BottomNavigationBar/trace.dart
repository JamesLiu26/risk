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

String _phNum = FirebaseAuth.instance.currentUser!.phoneNumber!;
CollectionReference _collection = FirebaseFirestore.instance.collection("user");

class _TraceState extends State<Trace> {
  @override
  void initState() {
    super.initState();
    dateTimeString = DateFormat("yyyy-MM-dd HH:mm").format(DateTime.now());
  }

  //
  final bsCon = TextEditingController();
  DateTime? setDate;
  TimeOfDay? setTime;
  DateTime? dateTime;
  String? dateTimeString;

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
          // 日期轉成字串格式
          dateTimeString = DateFormat("yyyy-MM-dd HH:mm").format(dateTime!);
        });
      }
    }
  }

  TextField bsTextField() {
    double fontSize = MediaQuery.of(context).size.width * 0.06;
    return TextField(
      style: TextStyle(fontSize: fontSize),
      inputFormatters: [LengthLimitingTextInputFormatter(6)],
      controller: bsCon,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          labelText: "mg/dL",
          floatingLabelBehavior: FloatingLabelBehavior.never,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );
  }

  List riceType = ["飯前", "飯後"];
  List<bool> boolVal = [true, false];
  ToggleButtons typeButton() {
    double screenWidth = MediaQuery.of(context).size.width;
    return ToggleButtons(
      textStyle: TextStyle(fontSize: screenWidth * 0.06),
      children: [Text(riceType[0]), Text(riceType[1])],
      constraints: BoxConstraints.expand(
          width: screenWidth * 0.2, height: screenWidth * 0.1),
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
          } else {
            boolVal[0] = false;
            boolVal[1] = true;
          }
        });
      },
    );
  }

  Text traceStyle(String text) {
    double fontSize = MediaQuery.of(context).size.width * 0.06;
    return Text(text, style: TextStyle(fontSize: fontSize));
  }

  snackBar(Color color, String text) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: color,
        content:
            Text(text, style: TextStyle(fontSize: 16, color: Colors.white)),
        duration: Duration(seconds: 1)));
  }

  void addData(String type) {
    _collection
        .doc(_phNum)
        .collection(type)
        .doc(dateTimeString)
        .set({"bloodSugar": bsCon.text});
    snackBar(Color(0xff4caf50), "已成功送出！");
    bsCon.clear();
  }

  boxMargin(Widget child1, child2) {
    return Padding(
        padding: EdgeInsets.all(10),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [child1, child2]));
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    FocusScopeNode focus = FocusScope.of(context);

    return Scaffold(
      drawer: menu(context),
      appBar: appBar("每日追蹤", menuButton()),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            boxMargin(
                traceStyle("選擇日期"),
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.blue[800])),
                    onPressed: () {
                      // 把TextField的focus移掉
                      if (!focus.hasPrimaryFocus) {
                        focus.unfocus();
                      }
                      chooseDateTime();
                    },
                    child: traceStyle(dateTimeString!))),
            boxMargin(traceStyle("類型"), typeButton()),
            boxMargin(traceStyle("血糖"),
                SizedBox(width: screenWidth * 0.35, child: bsTextField())),
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.blue[800])),
                onPressed: () {
                  // 把TextField的focus移掉
                  if (!focus.hasPrimaryFocus) {
                    focus.unfocus();
                  }
                  if (bsCon.text == "") {
                    snackBar(Color(0xffc62828), "請填寫完再按送出！");
                  } else if (boolVal[0] == true) {
                    addData("before");
                  } else {
                    addData("after");
                  }
                },
                child: traceStyle("提交")),
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Divider(thickness: 1, color: Colors.black),
            ),
            traceStyle("血糖正常範圍"),
            boxMargin(traceStyle("飯前血糖"), traceStyle("70~99mg/dL")),
            boxMargin(traceStyle("飯後血糖"), traceStyle("80~139mg/dL")),
            ElevatedButton(
              child: traceStyle("顯示圖表"),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue[800])),
              onPressed: () {
                if (!focus.hasPrimaryFocus) {
                  focus.unfocus();
                }
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Chart()));
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ----------------

class Chart extends StatefulWidget {
  @override
  ChartState createState() => ChartState();
}

class ChartState extends State<Chart> {
  @override
  void initState() {
    super.initState();
    pieList = [
      BloodSugarPie("低", low, Colors.blue),
      BloodSugarPie("正常", normal, Colors.green),
      BloodSugarPie("高", high, Colors.red)
    ];
    getPieLineData("before");
    startDate =
        DateTime.now().subtract(Duration(days: 6)).toString().split(" ")[0];
    endDate = DateTime.now().toString().split(" ")[0];
  }

  int low = 0, normal = 0, high = 0;

  late List<BloodSugarPie> pieList;
  List<BloodSugarLine> lineList = [];
  DateTimeRange? range;
  late String startDate, endDate;
  late String showRange = "$startDate ~ $endDate";
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
    _collection.doc(_phNum).collection(type).get().then((snapshot) {
      for (var query in snapshot.docs) {
        // 將document的id轉成日期格式
        DateTime time = DateTime.parse(query.id);

        // 日期落在區間內就加進資料裡
        /*
        startDate = 2021-10-27, subtracted 1 second from startDate  = 2021-10-26:23:59:59
        endDate = 2021-10-31, endDate add 1 day = 2021-11-01

        before after 的日期不包含在內
        */
        if (time.isAfter(
                DateTime.parse(startDate).subtract(Duration(seconds: 1))) &&
            time.isBefore(DateTime.parse(endDate).add(Duration(days: 1)))) {
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
          // 判斷血糖落於何處
          if (val < lowBS)
            low += 1;
          else if (val < highBS)
            normal += 1;
          else
            high += 1;
        }
      }
      setState(() {
        pieList = [
          BloodSugarPie("過低", low, Colors.blue),
          BloodSugarPie("正常", normal, Color(0xff43a047)),
          BloodSugarPie("過高", high, Colors.red)
        ];
      });
    });
  }

  List riceBS = ["飯前血糖", "飯後血糖"];
  List<bool> boolVal2 = [true, false];
  ToggleButtons switchButton() {
    double screenWidth = MediaQuery.of(context).size.width;
    return ToggleButtons(
      textStyle: TextStyle(fontSize: screenWidth * 0.06),
      children: [Text(riceBS[0]), Text(riceBS[1])],
      constraints: BoxConstraints.expand(
          width: screenWidth * 0.35, height: screenWidth * 0.1),
      isSelected: boolVal2,
      fillColor: Colors.blue[800],
      selectedColor: Colors.white,
      borderRadius: BorderRadius.circular(10),
      borderColor: Colors.black,
      selectedBorderColor: Colors.black,
      onPressed: (selIndex) {
        if (selIndex == 0) {
          boolVal2[0] = true;
          boolVal2[1] = false;
          getPieLineData("before");
        } else {
          boolVal2[0] = false;
          boolVal2[1] = true;
          getPieLineData("after");
        }
      },
    );
  }

  pieChart() {
    double screenWidth = MediaQuery.of(context).size.width;
    return SfCircularChart(
        title: ChartTitle(
            text: "分布程度(次數)",
            textStyle: TextStyle(fontSize: screenWidth * 0.06),
            alignment: ChartAlignment.near),
        legend: Legend(
            textStyle: TextStyle(fontSize: screenWidth * 0.06),
            position: LegendPosition.left,
            isVisible: true),
        series: [
          PieSeries<BloodSugarPie, String>(
            dataSource: pieList,
            dataLabelSettings: DataLabelSettings(
                isVisible: low == 0 && normal == 0 && high == 0 ? false : true,
                textStyle: TextStyle(fontSize: screenWidth * 0.08)),
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
            textStyle: TextStyle(fontSize: screenWidth * 0.06),
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

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: appBar(
            "顯示圖表",
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios, color: Colors.blue[800]))),
        body: SingleChildScrollView(
          child: Center(
            child: Column(children: [
              SizedBox(height: 20),
              Text("區間選擇", style: TextStyle(fontSize: screenWidth * 0.06)),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.blue[800])),
                  onPressed: () async {
                    range = await showDateRangePicker(
                        initialEntryMode: DatePickerEntryMode.calendarOnly,
                        builder: (context, child) => Theme(
                            child: child!,
                            data: ThemeData.light().copyWith(
                                colorScheme: ColorScheme.light(
                                    primary: Color(0xff1565c0)))),
                        context: context,
                        firstDate: DateTime(DateTime.now().year - 100),
                        lastDate: DateTime.now());
                    if (range != null) {
                      List<String> rangeString = range.toString().split(" - ");
                      startDate = rangeString[0].split(" ")[0];
                      endDate = rangeString[1].split(" ")[0];

                      setState(() {
                        showRange = "$startDate ~ $endDate";
                        if (boolVal2[0] == true)
                          getPieLineData("before");
                        else
                          getPieLineData("after");
                      });
                    }
                  },
                  child: Text(showRange,
                      style: TextStyle(fontSize: screenWidth * 0.06))),
              SizedBox(height: 20),
              switchButton(),
              Container(
                  margin: EdgeInsets.only(top: 20, bottom: 20),
                  decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10)),
                  width: screenWidth * 0.95,
                  child: pieChart()),
              Container(
                  margin: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10)),
                  width: screenWidth * 0.95,
                  child: lineChart()),
            ]),
          ),
        ));
  }
}
