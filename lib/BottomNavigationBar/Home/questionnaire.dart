import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/appBar.dart';
import '/change.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Question(),
  ));
}

class Question extends StatefulWidget {
  @override
  _QuestionState createState() => _QuestionState();
}

Text textStyle(text, double size) {
  return Text(text,
      style: TextStyle(fontSize: size, color: Colors.black, height: 1.5),
      textAlign: TextAlign.center);
}

class _QuestionState extends State<Question> {
  @override
  Widget build(BuildContext context) {
    double fontSize = MediaQuery.of(context).size.width * 0.06;
    return Scaffold(
        appBar: appBar(
            "問卷填寫",
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios, color: Colors.blue[800]),
            )),
        body: Center(
            child: Column(children: [
          Spacer(flex: 2),
          textStyle("請注意：\n建議您先透過儀器量測\n或是做完健檢再填寫此問卷", fontSize),
          Spacer(flex: 1),
          OutlinedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.green)),
              child: Text("繼續",
                  style: TextStyle(fontSize: fontSize, color: Colors.white)),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SecondPage()));
              }),
          Spacer(flex: 3),
        ])));
  }
}

//Second page-------------------
class SecondPage extends StatefulWidget {
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  late Interpreter interpreter;
  late List<List<double>> input;
  List<List<double>> output = [
    [0.0]
  ];
  // 下載模型並取得模型大小
  loadModel() async {
    interpreter = await Interpreter.fromAsset("model.tflite");
    print("Successfully!");
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
        0.0,
        0.0,
        17.3,
        1.0,
        21.0
      ]
    ];

    // 讓model去跑input
    interpreter.run(input, output);
    print(output[0][0]);
  }

  final pregnant = TextEditingController();
  final glu = TextEditingController();
  final bloodPressure = TextEditingController();
  late List data = [pregnant, glu, bloodPressure];
  List<bool> yesOrNo = [true, false];
  //

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

  bool result() {
    bool fullData = true;
    for (TextEditingController value in data) {
      if (!value.text.contains(RegExp("^[0-9]+\$"), 0)) {
        print(value);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red[800],
            content: Text("請確認問卷填寫無誤再按送出！",
                style: TextStyle(fontSize: 16, color: Colors.white)),
            duration: Duration(seconds: 1)));
        fullData = false;
        break;
      }
    }
    return fullData;
  }

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

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: appBar(
            "回上頁",
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios, color: Colors.blue[800]),
            )),
        body: SingleChildScrollView(
            child: Column(children: [
          // if (性別=='女')
          SizedBox(height: 50),
          Row(
            children: [
              textStyle("請問您是否有懷孕過：", size.width * 0.055),
              yesNoButtons(),
            ],
          ),
          yesOrNo[1] == true
              ? Row(
                  children: [
                    textStyle("請輸入：", size.width * 0.055),
                    SizedBox(
                      width: size.width * 0.2,
                      child: question(pregnant),
                    ),
                    textStyle(" 次", size.width * 0.055),
                  ],
                )
              : Row(),
          SizedBox(height: 50),
          Row(
            children: [
              textStyle("請輸入血糖：", size.width * 0.055),
              SizedBox(
                width: size.width * 0.25,
                child: question(glu),
              ),
              textStyle(" mg/dL", size.width * 0.055)
            ],
          ),
          SizedBox(height: 50),
          Row(
            children: [
              textStyle("請輸入舒張壓：", size.width * 0.055),
              SizedBox(
                width: size.width * 0.25,
                child: question(bloodPressure),
              ),
              textStyle(" mmHg", size.width * 0.055)
            ],
          ),
          SizedBox(height: 100),
          OutlinedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.green)),
              child: Text("送出",
                  style: TextStyle(
                      fontSize: size.width * 0.06, color: Colors.white)),
              onPressed: () {
                FocusScopeNode focus = FocusScope.of(context);
                // 把TextField的focus移掉
                if (!focus.hasPrimaryFocus) {
                  focus.unfocus();
                }
                if (result() == true) {
                  predict();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Result()));
                }
              }),
        ])));
  }
}

class Result extends StatefulWidget {
  @override
  _ResultState createState() => _ResultState();
}

class _ResultState extends State<Result> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(
            "回到首頁",
            IconButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Change()));
              },
              icon: Icon(Icons.arrow_back_ios, color: Colors.blue[800]),
            )),
        body: Column());
  }
}
