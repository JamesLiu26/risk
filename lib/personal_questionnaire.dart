import 'dart:math';

import 'package:flutter/material.dart';

import './change.dart';
import './appBar.dart';

/* 
selectGender+
selectBloodType+
birthday+
age.toString()+
height.text+
weight.text+
status+
bmi.toStringAsFixed(1)
*/
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
  // 性別核選框
  String selectGender = gender[0];
  // 血型核選框
  String selectBloodType = bloodType[0];
  //生日
  String birthday = "點選此處選擇生日";
  int age = 0;
  DateTime currentDate = DateTime.now();
  MaterialStateProperty<Color> birthButtonColor =
      MaterialStateProperty.all<Color>(Colors.lightBlue);
  //bmi
  double bmi = 0;
  final height = TextEditingController();
  final weight = TextEditingController();
  String status = "";
  // 聯絡資訊
  final contactAddress = TextEditingController();
  final contactEmail = TextEditingController();
  // 緊急聯絡人
  final emerName = TextEditingController();
  final emerRelationship = TextEditingController();
  final emerPhone = TextEditingController();
  // 家族/過往病史
  static List<String> diabeteHistory = ["有", "無"];
  String selectHistory = diabeteHistory[1];
  //不良習慣或情形發生

  // "喝酒"
  // "抽菸"
  // "熬夜"
  // "頻尿"
  // "視力退化"

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
        value: value,
        groupValue: selectGender,
        onChanged: (currentValue) {
          setState(() {
            selectGender = currentValue.toString();
            print(selectGender);
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
            print(selectBloodType);
          });
        });
  }

  // 日期選擇(生日)
  Future<DateTime?> chooseBirthday() {
    return showDatePicker(
      initialDatePickerMode: DatePickerMode.year,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(1921),
      lastDate: currentDate,
      cancelText: "取消",
      confirmText: "確定",
    ).then((selectDate) {
      setState(() {
        if (selectDate != null) {
          birthday = selectDate.toString().split(" ")[0];
          age = currentDate.year - selectDate.year;
          if ((selectDate.month == currentDate.month &&
                  selectDate.day > currentDate.day) ||
              selectDate.month > currentDate.month) {
            age--;
          }
          birthButtonColor =
              MaterialStateProperty.all<Color>(Color(0xFF1565C0));
        }
      });
    });
  }

  // bmi計算
  void bmiCalculator() {
    if ((height.text != "" && weight.text != "")) {
      bmi = double.parse(weight.text) / pow(double.parse(height.text) / 100, 2);

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
    } else {
      bmi = 0;
      status = "";
    }
    // 取到小數第1位
    bmi = double.parse(bmi.toStringAsFixed(1));
  }

  // 身高體重輸入框
  Padding inputCmKg(TextEditingController controller, String label) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          maxLength: 5,
          decoration: InputDecoration(
              counterText: "",
              labelText: label,
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

  // 聯絡輸入框
  Padding inputContact(
      TextEditingController controller, String label, String? hint) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
              labelText: label,
              hintText: hint,
              // float字的動畫取消
              floatingLabelBehavior: FloatingLabelBehavior.never,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
          onChanged: (_) {
            setState(() {});
          },
        ));
  }

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

  Container questionArea(Widget child) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.9,
        margin: EdgeInsets.only(top: 10, bottom: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Color(0x5F000000),
                blurRadius: 4,
                offset: Offset(3, 10),
              )
            ]),
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
                      // ----
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
                      // ----
                      // ----

                      questionArea(
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              textStyle("\n  年齡：$age歲"),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor: birthButtonColor),
                                    onPressed: () async {
                                      await chooseBirthday();
                                    },
                                    child:
                                        textStyle(birthday, Color(0xffffffff))),
                              )
                            ]),
                      ),

                      // ----
                      // ----
                      // ----

                      questionArea(Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          textStyle("\n  身高&體重"),
                          textStyle(
                              "  BMI=" + bmi.toString() + "  狀態：" + status),
                          inputCmKg(height, "身高"),
                          inputCmKg(weight, "體重"),
                        ],
                      )),

                      // ----
                      // ----
                      // ----

                      questionArea(Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          textStyle("\n  聯絡資訊"),
                          inputContact(contactAddress, "通訊地址", "例：XX市XX路..."),
                          inputContact(contactEmail, "電子郵件",
                              "Google, Yahoo, OneDrive..."),
                        ],
                      )),

                      // ----
                      // ----
                      // ----

                      questionArea(Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            textStyle("\n  緊急聯絡人"),
                            inputContact(emerName, "姓名", null),
                            inputContact(emerRelationship, "關係", null),
                            inputContact(emerPhone, "聯絡電話", "例：09XXXXXXXX"),
                          ])),

                      // ----
                      // ----
                      // ----

                      questionArea(Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            textStyle("\n  是否有糖尿病家族/過往病史"),
                            historyRadio(diabeteHistory[0]),
                            historyRadio(diabeteHistory[1])
                          ])),

                      // ----
                      // ----
                      // ----

                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white)),
                              onPressed: () {
                                bmiCalculator();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Change()));
                              },
                              child: Center(
                                  child: textStyle("儲存", Colors.green)))),
                      // ----
                    ])))));
  }
}
