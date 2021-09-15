import 'package:flutter/material.dart';
import '/appBar.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Question(),
  ));
}

/*
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
    //                        BMI 譜系功能 年齡
    input = [
      [0.0, 0.0, 0.0, 0.0, 0.0, bmi, dpf, age]
    ];
    print("$bmi  $dpf  $age");
    // 讓model去跑input
    interpreter.run(input, output);
    print(output);
  }

  @override
  void initState() {
    super.initState();
    loadModel();
  }
 */
class Question extends StatefulWidget {
  @override
  _QuestionState createState() => _QuestionState();
}

class _QuestionState extends State<Question> {
  Text textStyle(
    text,
    double size, [
    color = Colors.black,
  ]) {
    return Text(text,
        style: TextStyle(fontSize: size, color: color),
        textAlign: TextAlign.center);
  }

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
        body: Column(children: [
          Spacer(flex: 3),
          textStyle("請注意：\n建議您先透過儀器量測\n或是做完健檢再填寫此問卷", fontSize),
          Spacer(flex: 3),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            OutlinedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.red)),
              child: textStyle("返回", fontSize, Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            OutlinedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.green)),
              child: textStyle("繼續", fontSize, Colors.white),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FirstPage()));
              },
            )
          ]),
          Spacer(flex: 3),
        ]));
  }
}

//first page
class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(
            "問卷填寫",
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios, color: Colors.blue[800]),
            )),
        body: Column());
  }
}

/*
*/