import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

import './change.dart';
import './appBar.dart';

void main() {
  return runApp(MaterialApp(
    home: PerQuest(),
    debugShowCheckedModeBanner: false,
  ));
}

class PerQuest extends StatefulWidget {
  @override
  _PerQuestState createState() => _PerQuestState();
}

List<String> gender = ["男", "女"];
List<String> bloodType = ["O", "A", "B", "AB"];

class _PerQuestState extends State<PerQuest> {
  // tflite解譯器
  late Interpreter interpreter;
  // 丟資料(input)經模型run過會得到output
  var input;
  // output預設為0
  var output = [
    [0.0]
  ];

  // 性別核選框，預設為男
  String selectGender = gender[0];

  // 血型核選框，預設為O型
  String selectBloodType = bloodType[0];

  //生日
  String birthday = "點選此處選擇生日";
  double age = 0;
  // 當下時間
  DateTime currentDate = DateTime.now();

  //bmi
  double bmi = 0;
  final height = TextEditingController();
  final weight = TextEditingController();
  String? errorHeight;
  String? errorWeight;
  String status = "";

  // 家族/過往病史
  static List<String> diabeteHistory = ["無", "有"];
  String selectHistory = diabeteHistory[0];
  double dpf = 0;

  // 聯絡資訊
  final contactAddress = TextEditingController();
  final contactEmail = TextEditingController();
  String? errorAddress;

  // 緊急聯絡人
  final emerName = TextEditingController();
  final emerRelationship = TextEditingController();
  final emerPhone = TextEditingController();
  String? errorNa;
  String? errorRe;
  String? errorPh;

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

  // 文字樣式----
  Text textStyle(String text, [color = Colors.black]) {
    return Text(text,
        style: TextStyle(
          color: color,
          fontSize: MediaQuery.of(context).size.width * 0.04,
          letterSpacing: 1,
        ));
  }

  // 性別radio buttons
  RadioListTile<String> genderRadio(String value) {
    return RadioListTile(
        title: textStyle(value),
        // value是取List裡的值
        value: value,
        groupValue: selectGender,
        onChanged: (currentValue) {
          setState(() {
            selectGender = currentValue.toString();
          });
        });
  }

  // 血型radio buttons
  RadioListTile<String> bloodRadio(String value) {
    return RadioListTile(
        title: textStyle(value),
        value: value,
        groupValue: selectBloodType,
        onChanged: (currentValue) {
          setState(() {
            selectBloodType = currentValue.toString();
          });
        });
  }

  // 日期選擇(生日)
  Future<DateTime?> chooseBirthday() {
    return showDatePicker(
      // 一開始先選年
      initialDatePickerMode: DatePickerMode.year,
      // 只能透過日曆選日期
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      context: context,
      // 一開始預設的日期為目前日期
      initialDate: currentDate,
      // 最早可選到100年前
      firstDate: DateTime(currentDate.year - 100),
      // 最後一天為目前日期
      lastDate: currentDate,
      // 右下角的文字
      cancelText: "取消",
      confirmText: "確定",
    ).then((selectDate) {
      setState(() {
        if (selectDate != null) {
          // 利用split取年
          birthday = selectDate.toString().split(" ")[0];
          age = (currentDate.year - selectDate.year) * 1.0;
          if ((selectDate.month == currentDate.month &&
                  selectDate.day > currentDate.day) ||
              selectDate.month > currentDate.month) {
            age--;
          }
        }
      });
    });
  }

  // bmi計算
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

  // 身高體重輸入框
  Padding inputCmKg(
      TextEditingController controller, String label, String? error) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          maxLength: 5,
          decoration: InputDecoration(
              counterText: "",
              labelText: label,
              errorText: error,
              floatingLabelBehavior: FloatingLabelBehavior.never,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
          onChanged: (String value) {
            setState(() {
              controller.text = value;
              bmiCalculator();
            });
          },
        ));
  }

  // 身高體重&聯絡資訊&緊急聯絡人判斷
  String? errorBmiContact(String text) {
    String? error;
    if (text.trim() == "" || text.isEmpty) {
      error = "不可空白!";
    } else {
      error = null;
    }

    return error;
  }

  // 病史
  RadioListTile historyRadio(String value) {
    return RadioListTile(
        title: textStyle(value),
        value: value,
        groupValue: selectHistory,
        onChanged: (currentValue) {
          setState(() {
            selectHistory = currentValue;
            print(selectHistory);
          });
        });
  }

  void dpfOrNot() {
    if (selectHistory == diabeteHistory[1]) dpf = 1.0;
  }

  // 緊急連絡電話判斷
  String? errorEmerPhone(String text) {
    String? error;
    if (text.isEmpty || text.trim() == "") {
      error = "不可空白！";
    } else if (!text.contains(RegExp("\^09[0-9]{8}\$"), 0)) {
      error = "行動電話格式不正確！";
    } else {
      error = null;
    }
    return error;
  }

  // 聯絡資訊&緊急聯絡人輸入框
  Padding inputContact(TextEditingController controller, String label,
      String hint, String? error) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
              labelText: label,
              hintText: hint,
              errorText: error,
              // float字的動畫取消
              floatingLabelBehavior: FloatingLabelBehavior.never,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        ));
  }

  // 資料區塊
  Container questionArea(Widget child) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.9,
        margin: EdgeInsets.only(top: 15, bottom: 15),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: child);
  }

// ----
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFF5DEB3),
        appBar: appBar("基本資料填寫", Icon(Icons.quiz, color: Colors.blue[800])),
        body: SingleChildScrollView(
            child: Center(
                child: Theme(
                    // 更改radio顏色
                    data: ThemeData(
                        accentColor: Color(0xFF1565C0),
                        unselectedWidgetColor: Colors.lightBlue),
                    child: Column(children: [
                      questionArea(Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            textStyle("\n  性別"),
                            genderRadio(gender[0]),
                            genderRadio(gender[1]),
                          ])),

                      // ----

                      questionArea(Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            textStyle("\n  血型"),
                            bloodRadio(bloodType[0]),
                            bloodRadio(bloodType[1]),
                            bloodRadio(bloodType[2]),
                            bloodRadio(bloodType[3]),
                          ])),

                      // ----

                      questionArea(
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              textStyle("\n  年齡：${age.toStringAsFixed(0)}歲"),
                              Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: OutlinedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Color(0xFF1565C0))),
                                      onPressed: () async {
                                        await chooseBirthday();
                                      },
                                      child: textStyle(
                                          birthday, Color(0xffffffff))))
                            ]),
                      ),

                      // ----

                      questionArea(Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          textStyle("\n  身高&體重"),
                          textStyle(
                              "  BMI=" + bmi.toString() + "  狀態：" + status),
                          inputCmKg(height, "身高", errorHeight),
                          inputCmKg(weight, "體重", errorWeight),
                        ],
                      )),

                      // ----

                      questionArea(Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            textStyle("\n  是否有糖尿病家族/過往病史"),
                            historyRadio(diabeteHistory[0]),
                            historyRadio(diabeteHistory[1])
                          ])),

                      // ----

                      questionArea(Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          textStyle("\n  聯絡資訊"),
                          inputContact(contactAddress, "通訊地址", "例：XX市XX區...",
                              errorAddress),
                          inputContact(contactEmail, "電子郵件(非必填)",
                              "Google, Yahoo, OneDrive...", null),
                        ],
                      )),

                      // ----

                      questionArea(Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            textStyle("\n  緊急聯絡人"),
                            inputContact(emerName, "姓名", "", errorNa),
                            inputContact(emerRelationship, "關係", "", errorRe),
                            inputContact(
                                emerPhone, "聯絡電話", "例：0912345678", errorPh),
                          ])),

                      // ----

                      OutlinedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white)),
                          onPressed: () {
                            FocusScopeNode focus = FocusScope.of(context);
                            // 把TextField的focus移掉
                            if (!focus.hasPrimaryFocus) {
                              focus.unfocus();
                            }

                            setState(() {
                              // 判斷家族有無得過糖尿病
                              dpfOrNot();
                              // 傳遞錯誤訊息
                              errorHeight = errorBmiContact(height.text);
                              errorWeight = errorBmiContact(weight.text);
                              errorAddress =
                                  errorBmiContact(contactAddress.text);
                              errorNa = errorBmiContact(emerName.text);
                              errorRe = errorBmiContact(emerRelationship.text);
                              errorPh = errorEmerPhone(emerPhone.text);
                            });

                            if (bmi != 0 &&
                                birthday != "點選此處選擇生日" &&
                                errorAddress == null &&
                                errorNa == null &&
                                errorRe == null &&
                                errorPh == null) {
                              predict();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Change()));
                            }
                          },
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.2,
                              child: Center(
                                  child: textStyle("儲存", Colors.green)))),
                    ])))));
  }
}
