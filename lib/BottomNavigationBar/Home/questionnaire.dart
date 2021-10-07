import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '/change.dart';
import '/appBar.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Question(),
  ));
}

//First page-------------------
class Question extends StatefulWidget {
  @override
  _QuestionState createState() => _QuestionState();
}

class _QuestionState extends State<Question> {
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
    input = [
      [
        double.parse(pregnant.text),
        double.parse(glu.text),
        double.parse(bloodPressure.text),
        0, //SkinThickness
        0, //Insulin
        25, //BMI
        0, //DiabetesPedigreeFunction
        22 //Age
      ]
    ];

    // 讓model去跑input
    interpreter.run(input, output);
    print((output[0][0]));
  }

  var pregnant = TextEditingController();
  final glu = TextEditingController();
  final bloodPressure = TextEditingController();
  late List data = [pregnant, glu, bloodPressure];
  List<bool> yesOrNo = [true, false];

  //------------
  TextField question(TextEditingController controller) {
    double fontSize = MediaQuery.of(context).size.width * 0.055;
    return TextField(
        controller: controller,
        style: TextStyle(fontSize: fontSize),
        inputFormatters: [LengthLimitingTextInputFormatter(4)],
        decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))));
  }

  // 是否懷孕
  ToggleButtons yesNoButtons() {
    return ToggleButtons(
        borderRadius: BorderRadius.circular(20),
        fillColor: Colors.blue[800],
        selectedColor: Colors.white,
        borderColor: Colors.black,
        selectedBorderColor: Colors.black,
        children: [
          Text("否"),
          Text("是"),
        ],
        isSelected: yesOrNo,
        onPressed: (index) {
          setState(() {
            if (index == 0) {
              yesOrNo[0] = true;
              yesOrNo[1] = false;
              pregnant.text = "0";
            } else {
              yesOrNo[0] = false;
              yesOrNo[1] = true;
              pregnant.text = "";
            }
          });
        });
  }

  // 確認每個值是否有輸入
  bool result() {
    bool hasFullData = true;
    for (TextEditingController value in data) {
      if (!value.text.contains(RegExp("^[0-9]+\$"), 0)) {
        //
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red[800],
            content: Text("請確認問卷填寫無誤再按送出！",
                style: TextStyle(fontSize: 16, color: Colors.white)),
            duration: Duration(seconds: 1)));
        //
        hasFullData = false;
        break;
      }
    }
    return hasFullData;
  }

  Text textStyle1(text, double size) {
    return Text(text,
        style: TextStyle(fontSize: size, color: Colors.black, height: 1.5),
        textAlign: TextAlign.center);
  }
  // ----------------------------

  @override
  void initState() {
    super.initState();
    pregnant.text = "0";
    loadModel();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: appBar(
            "問卷評估",
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios, color: Colors.blue[800]),
            )),
        body: SingleChildScrollView(
            child: Column(children: [
          SizedBox(height: 20),
          textStyle1("建議您先透過儀器量測\n再填寫此問卷", screenWidth * 0.055),
          // if (性別=='女')
          SizedBox(height: 50),
          Row(
            children: [
              textStyle1("    請問您是否有懷孕過：", screenWidth * 0.055),
              yesNoButtons(),
            ],
          ),

          // 顯示懷孕輸入框
          yesOrNo[1] == true
              ? Row(
                  children: [
                    textStyle1("    請輸入：", screenWidth * 0.055),
                    SizedBox(
                      width: screenWidth * 0.25,
                      child: question(pregnant),
                    ),
                    textStyle1(" 次", screenWidth * 0.055),
                  ],
                )
              : Row(),
          SizedBox(height: 50),
          Row(
            children: [
              textStyle1("    請輸入血糖：", screenWidth * 0.055),
              SizedBox(
                width: screenWidth * 0.25,
                child: question(glu),
              ),
              textStyle1(" mg/dL", screenWidth * 0.055)
            ],
          ),
          SizedBox(height: 50),
          Row(
            children: [
              textStyle1("    請輸入舒張壓：", screenWidth * 0.055),
              SizedBox(
                width: screenWidth * 0.25,
                child: question(bloodPressure),
              ),
              textStyle1(" mmHg", screenWidth * 0.055)
            ],
          ),
          SizedBox(height: 50),
          OutlinedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.green)),
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
        ])));
  }
}

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

  TextStyle textStyle(double screenWidth) {
    return TextStyle(fontSize: screenWidth * 0.08, color: Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double screenWidth = size.width;
    double screenHeight = size.height;
    String percentText =
        "${(widget.predictionResult * 100).toStringAsFixed(1)}%";
    return Scaffold(
        body: Container(
            color: Colors.black,
            width: screenWidth,
            height: screenHeight,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("預測結果為", style: textStyle(screenWidth)),
                  //
                  CircularPercentIndicator(
                    lineWidth: 20,
                    radius: screenWidth * 0.6,
                    progressColor: finalProgressColor(),
                    percent: widget.predictionResult,
                    animation: true,
                    animationDuration: 1500,
                    center: Text(percentText, style: textStyle(screenWidth)),
                  ),
                  //
                  Text(level, style: textStyle(screenWidth)),
                  InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Change()));
                      },
                      child: Text("返回首頁", style: textStyle(screenWidth)))
                ],
              ),
            )));
  }
}
