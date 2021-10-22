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
  final double times;
  BS(this.level, this.times);
}

class _TraceState extends State<Trace> {
  String phNum = FirebaseAuth.instance.currentUser!.phoneNumber!;
  CollectionReference collection =
      FirebaseFirestore.instance.collection("user");
  //
  final bsCon = TextEditingController();
  DateTime? setDate;
  TimeOfDay? setTime;
  DateTime? dateTime;
  String dateTimeString = "選擇量測日期";
  // int time = 0;
  List<BS> bs = [BS("低", 0), BS("高", 0), BS("正常", 0)];

  SfCircularChart pieChart() {
    return SfCircularChart(legend: Legend(isVisible: true), series: [
      DoughnutSeries<BS, String>(
          dataSource: bs,
          dataLabelSettings: DataLabelSettings(
              isVisible: true, textStyle: TextStyle(fontSize: 14)),
          xValueMapper: (data, _) => data.level,
          yValueMapper: (data, _) => data.times,
          explode: true)
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
          } else {
            boolVal[0] = false;
            boolVal[1] = true;
          }
        });
      },
    );
  }

  Text traceStyle(String text) {
    double fontSize = MediaQuery.of(context).size.width * 0.055;
    return Text(text, style: TextStyle(fontSize: fontSize));
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    Future<void> setDateTime() async {
      // 選擇(年月日)
      setDate = await showDatePicker(
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(DateTime.now().year - 100),
          lastDate: DateTime.now());

      if (setDate != null) {
        // 選擇小時、分鐘
        setTime = await showTimePicker(
            context: context, initialTime: TimeOfDay.now());
        if (setTime != null) {
          setState(() {
            // 儲存日期
            dateTime = DateTime(setDate!.year, setDate!.month, setDate!.day,
                setTime!.hour, setTime!.minute);
            //
            print("DateTime:${dateTime.toString()}");
            // 顯示日期格式
            dateTimeString =
                DateFormat("yyyy-MM-dd HH:mm EEEE", "zh_tw").format(dateTime!);
          });
        }
      }
    }

    snackBar() {
      return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red[800],
          content: Text("請填寫完再按送出！",
              style: TextStyle(fontSize: 16, color: Colors.white)),
          duration: Duration(seconds: 1)));
    }

    // double fontSize = screenWidth * 0.06;
    return Scaffold(
        drawer: menu(context),
        appBar: appBar("每日追蹤", menuButton()),
        body: Center(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  traceStyle("血糖："),
                  SizedBox(width: screenWidth * 0.35, child: bsField()),
                  riceButton()
                ],
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
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

              // ? SizedBox(width: screenWidth * 0.7, child: pieChart()):
              SizedBox(width: 10, height: 10),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.blue[800])),
                  onPressed: () {
                    if (dateTime == null) {
                      snackBar();
                    } else if (boolVal[0] == true) {
                      print("before");
                      // collection
                      //     .doc(phNum)
                      //     .collection("before")
                      //     .doc(dateTime.toString())
                      //     .set({"bloodSugar": bsCon.text});
                    } else {
                      print("after");
                      // collection
                      //     .doc(phNum)
                      //     .collection("after")
                      //     .doc(dateTime.toString())
                      //     .set({"bloodSugar": bsCon.text});
                    }
                  },
                  child: traceStyle("提交"))
            ],
          ),
        ));
  }
}
