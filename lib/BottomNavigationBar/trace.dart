import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../menu.dart';
import '../appBar.dart';
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
    double fontSize = MediaQuery.of(context).size.width * 0.05;
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: color,
        content: Text(text,
            style: TextStyle(fontSize: fontSize, color: Colors.white)),
        duration: Duration(seconds: 1)));
  }

  void addData(String type) {
    _collection
        .doc(_phNum)
        .collection(type)
        .doc(dateTimeString)
        .set({"bloodSugar": bsCon.text});
    snackBar(Color(0xff4caa50), "已成功送出！ 詳細資訊請看統計圖表");
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
          ],
        ),
      ),
    );
  }
}
