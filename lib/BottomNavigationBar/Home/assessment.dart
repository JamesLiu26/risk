import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '/change.dart';
import '/appBar.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

// void main() {
//   runApp(MaterialApp(
//     debugShowCheckedModeBanner: false,
//     home: Assessment(),
//   ));
// }

//First page-------------------
class Assessment extends StatefulWidget {
  @override
  _AssessmentState createState() => _AssessmentState();
}

FirebaseAuth _auth = FirebaseAuth.instance;
CollectionReference _collection = FirebaseFirestore.instance.collection("user");

class _AssessmentState extends State<Assessment> {
  late Interpreter interpreter;
  late List<List<double>> input;
  List<List<double>> output = [
    [0.0]
  ];

  // 載入模型並取得模型大小
  loadModel() async {
    interpreter = await Interpreter.fromAsset("model.tflite");
    interpreter.allocateTensors();
    print(interpreter.getInputTensors());
    print(interpreter.getOutputTensors());
  }

  // 預測結果
  void predict() {
    double pregnant = 0;
    double dpf = 0;
    double age = 0;
    if (_auth.currentUser != null) {
      String phoNum = _auth.currentUser!.phoneNumber!;
      _collection.doc(phoNum).get().then((snapshot) {
        pregnant = snapshot.get("pregnant") * 1.0;
        dpf = snapshot.get("diabetesPedigreeFunction") * 1.0;
        age = snapshot.get("age") * 1.0;
      }).whenComplete(() {
        print("懷孕次數: $pregnant");
        print("血糖：${glu.text}");
        print("血壓：${bloodPressure.text}");
        print("0");
        print("0");
        print("BMI:$bmi");
        print("譜系功能：$dpf");
        print("年齡：$age");
      });
    }
    input = [
      [
        pregnant,
        double.parse(glu.text),
        double.parse(bloodPressure.text),
        0, //SkinThickness
        0, //Insulin
        bmi,
        dpf,
        age
      ]
    ];

    // 讓model去跑input
    interpreter.run(input, output);
    print((output[0][0]));
  }

  final glu = TextEditingController();
  //
  double bmi = 0;
  final height = TextEditingController();
  final weight = TextEditingController();
  String status = "";
  //
  final bloodPressure = TextEditingController();
  late List fillData = [height, weight, glu, bloodPressure];

  //------------

  TextField question(TextEditingController controller, String labelText) {
    double fontSize = MediaQuery.of(context).size.width * 0.055;
    return TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        style: TextStyle(fontSize: fontSize, color: Colors.black),
        inputFormatters: [LengthLimitingTextInputFormatter(5)],
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            labelStyle: TextStyle(color: Colors.grey),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        onChanged: (_) {
          if (controller == height || controller == weight) {
            setState(() {
              bmiCalculator();
            });
          }
        });
  }

  void bmiCalculator() {
    // 判斷是否為數字
    if (height.text.contains(RegExp("[0-9]\+")) &&
        weight.text.contains(RegExp("[0-9]\+"))) {
      double h = double.parse(height.text);
      double w = double.parse(weight.text);
      //
      if ((h > 0 && w > 0)) {
        bmi = w / pow(h / 100, 2);
        if (bmi < 18.5) {
          status = "過輕";
        } else if (bmi < 24) {
          status = "正常";
        } else if (bmi < 27) {
          status = "過重";
        } else if (bmi < 30) {
          status = "輕度肥胖";
        } else if (bmi < 35) {
          status = "中度肥胖";
        } else {
          status = "重度肥胖";
        }
        // 取到小數第1位
        bmi = double.parse(bmi.toStringAsFixed(1));
      }
    } else {
      bmi = 0;
      status = "";
    }
  }

  // 確認每個值是否有輸入
  bool result() {
    bool hasFullData = true;
    for (TextEditingController value in fillData) {
      if (!value.text.contains(RegExp("^[0-9\.]+\$"), 0)) {
        //
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red[800],
            content: Text("請確認填寫無誤再按送出！",
                style: TextStyle(fontSize: 16, color: Colors.white)),
            duration: Duration(seconds: 1)));
        //
        hasFullData = false;
        break;
      }
    }
    return hasFullData;
  }

  Text textStyle1(text, [Color color = Colors.white]) {
    double fontSize = MediaQuery.of(context).size.width * 0.055;
    return Text(text,
        style: TextStyle(fontSize: fontSize, color: color, height: 1.5),
        textAlign: TextAlign.center);
  }

  Container marginPadding(Widget child, [Color color = Colors.blue]) {
    return Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: color),
        child: child);
  }
  // ----------------------------

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.orange[100],
        appBar: appBar(
            "風險評估",
            IconButton(
              onPressed: () {
                FocusScopeNode focus = FocusScope.of(context);
                // 把TextField的focus移掉
                if (!focus.hasPrimaryFocus) {
                  focus.unfocus();
                }
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios, color: Colors.blue[800]),
            )),
        body: SingleChildScrollView(
            child: Center(
          child: Column(children: [
            SizedBox(height: 20),
            textStyle1("建議您先透過\n儀器量測再填寫\n", Colors.black),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                marginPadding(Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      textStyle1("身高"),
                      Container(
                          margin: EdgeInsets.all(10),
                          width: screenWidth * 0.3,
                          child: question(height, "cm"))
                    ])),
                //
                marginPadding(Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      textStyle1("體重"),
                      Container(
                          margin: EdgeInsets.all(10),
                          width: screenWidth * 0.3,
                          child: question(weight, "kg"))
                    ])),
              ],
            ),

            marginPadding(SizedBox(
                width: screenWidth * 0.5,
                child: textStyle1("BMI  ${bmi.toString()}\n狀態  $status"))),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                marginPadding(Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      textStyle1("血糖"),
                      Container(
                          margin: EdgeInsets.all(10),
                          width: screenWidth * 0.3,
                          child: question(glu, "mg/dL"))
                    ])),
                //
                marginPadding(Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      textStyle1("舒張壓"),
                      Container(
                        margin: EdgeInsets.all(10),
                        width: screenWidth * 0.3,
                        child: question(bloodPressure, "mmHg"),
                      )
                    ])),
              ],
            ),
            //
            SizedBox(height: 30),
            ElevatedButton(
                style: ButtonStyle(
                    shadowColor: MaterialStateProperty.all(Colors.white),
                    backgroundColor:
                        MaterialStateProperty.all(Colors.orange[800])),
                child: Text("送出",
                    style: TextStyle(
                        fontSize: screenWidth * 0.06, color: Colors.white)),
                onPressed: () {
                  FocusScopeNode focus = FocusScope.of(context);
                  // 把TextField的focus移掉
                  if (!focus.hasPrimaryFocus) {
                    focus.unfocus();
                  }
                  if (result() == true) {
                    predict();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            // 把預測結果傳到下一頁
                            builder: (context) => Final(output[0][0])));
                  }
                }),
            SizedBox(height: 20)
          ]),
        )));
  }
}

// 結果
class Final extends StatefulWidget {
  final double predictionResult;
  Final(this.predictionResult);

  @override
  _FinalState createState() => _FinalState();
}

class _FinalState extends State<Final> {
  String level = "";
  Color finalProgressColor() {
    Color progress;
    if (widget.predictionResult < 0.3) {
      progress = Colors.green;
      level = "低風險";
    } else if (widget.predictionResult < 0.6) {
      progress = Colors.yellow;
      level = "中風險";
    } else {
      progress = Colors.red;
      level = "高風險";
    }
    return progress;
  }

  TextStyle textStyle2(double screenWidth) {
    return TextStyle(fontSize: screenWidth * 0.075, color: Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double screenWidth = size.width;
    double screenHeight = size.height;
    String percentText =
        "${(widget.predictionResult * 100).toStringAsFixed(1)}%";
    //
    CircularPercentIndicator percentIndicator() => CircularPercentIndicator(
          lineWidth: 20,
          radius: screenWidth * 0.6,
          progressColor: finalProgressColor(),
          percent: widget.predictionResult,
          animation: true,
          animationDuration: 1500,
          center: Text(percentText, style: textStyle2(screenWidth)),
        );
    //
    return Scaffold(
        body: Container(
            color: Colors.black,
            width: screenWidth,
            height: screenHeight,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("預測結果為", style: textStyle2(screenWidth)),
                  percentIndicator(),
                  Text(level, style: textStyle2(screenWidth)),
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blue[800])),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => Change()),
                            (Route route) => false);
                      },
                      child: Text("返回首頁", style: textStyle2(screenWidth))),
                ],
              ),
            )));
  }
}
