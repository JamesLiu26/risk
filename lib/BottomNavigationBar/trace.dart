import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  int time = 0;
  var setTime;
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
    double fontSize = MediaQuery.of(context).size.width * 0.06;
    return Text(text, style: TextStyle(fontSize: fontSize));
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // double fontSize = screenWidth * 0.06;
    return Scaffold(
        drawer: menu(context),
        appBar: appBar("每日追蹤", menuButton()),
        body: Center(
          child: Column(
            children: [
              Row(
                children: [
                  traceStyle("血糖："),
                  SizedBox(width: screenWidth * 0.35, child: bsField()),
                  riceButton()
                ],
              ),
              Row(children: [
                traceStyle("量測時間："),
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.blue[800])),
                    onPressed: () async {
                      setTime = await showTimePicker(
                          context: context, initialTime: TimeOfDay.now());
                      print(setTime);
                    },
                    child: traceStyle("選擇"))
              ]),
              time != 0
                  ? SizedBox(width: screenWidth * 0.7, child: pieChart())
                  : SizedBox(width: 10, height: 10),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.blue[800])),
                  onPressed: () {
                    // collection
                    //     .doc(phNum)
                    //     .collection("BloodSugar")
                    //     .doc(time.toString())
                    //     .set({"bloodSugar": bsCon.text});
                  },
                  child: traceStyle("提交"))
            ],
          ),
        ));
  }
}
