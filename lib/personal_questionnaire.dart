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

class _PerQuestState extends State<PerQuest> {
  // 性別核選框
  static List<String> gender = ["男", "女"];
  String selectGender = gender[0];
  // 血型核選框
  static List<String> bloodType = ["O", "A", "B", "AB"];
  String selectBloodType = bloodType[0];
  //生日
  String birthday = "點選此處選擇生日";
  int age = 0;
  DateTime currentDate = DateTime.now();
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
  Map familyPast = {
    "心臟病": false,
    "高血壓": false,
    "高血脂": false,
    "糖尿病": false,
    "失智症": false,
  };
  List familyPastKey = [];
  //不良習慣
  Map badHabit = {
    "喝酒": false,
    "抽菸": false,
    "熬夜": false,
    "不運動": false,
  };
  List badHabitKey = [];

  RadioListTile<String> genderRadio(String text, String value) {
    return RadioListTile(
        title: textStyle(text),
        value: value,
        groupValue: selectGender,
        onChanged: (currentValue) {
          setState(() {
            selectGender = currentValue.toString();
            print(selectGender);
          });
        });
  }

  RadioListTile<String> bloodRadio(String text, String value) {
    return RadioListTile(
        title: textStyle(text),
        value: value,
        groupValue: selectBloodType,
        onChanged: (currentValue) {
          setState(() {
            selectBloodType = currentValue.toString();
            print(selectBloodType);
          });
        });
  }

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
        }
      });
    });
  }

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

  Padding inputCmKg(TextEditingController controller, String label) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          maxLength: 5,
          keyboardType: TextInputType.number,
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

  Padding inputContact(TextEditingController controller, String label,
      TextInputType keyboardStyle) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: controller,
          keyboardType: keyboardStyle,
          decoration: InputDecoration(
              labelText: label,
              floatingLabelBehavior: FloatingLabelBehavior.never,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
          onChanged: (_) {
            setState(() {});
          },
        ));
  }

// ----
  Text textStyle(String text, [color = Colors.black]) {
    return Text(text,
        style: TextStyle(
            color: color, fontSize: MediaQuery.of(context).size.width * 0.04));
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
                color: Colors.black,
                blurRadius: 3,
                offset: Offset(2, 1),
              )
            ]),
        child: child);
  }

// ----
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff94baf7),
        appBar: appBar("基本資料填寫", Icon(Icons.quiz, color: Colors.blue[800])),
        body: SingleChildScrollView(
            child: Center(
                child: Column(children: [
          questionArea(
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            textStyle("\n  性別"),
            genderRadio("男", gender[0]),
            genderRadio("女", gender[1]),
          ])),
          // ----
          questionArea(
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            textStyle("\n  血型"),
            bloodRadio("O", bloodType[0]),
            bloodRadio("A", bloodType[1]),
            bloodRadio("B", bloodType[2]),
            bloodRadio("AB", bloodType[3]),
          ])),
          // ----
          questionArea(
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              textStyle("\n  年齡：$age歲"),
              Padding(
                padding: const EdgeInsets.all(10),
                child: OutlinedButton(
                    style: ButtonStyle(
                        side: MaterialStateProperty.all<BorderSide>(
                            BorderSide(color: Colors.grey))),
                    onPressed: () async {
                      await chooseBirthday();
                    },
                    child: textStyle(birthday)),
              )
            ]),
          ),
          // ----
          questionArea(Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textStyle("\n  身高&體重"),
              textStyle("  BMI=" + bmi.toString() + "  狀態：" + status),
              inputCmKg(height, "身高"),
              inputCmKg(weight, "體重"),
            ],
          )),
          // ----
          questionArea(Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textStyle("\n  聯絡資訊"),
              inputContact(contactAddress, "通訊地址", TextInputType.text),
              inputContact(contactEmail, "電子郵件", TextInputType.emailAddress),
            ],
          )),
          // ----
          questionArea(
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            textStyle("\n  緊急連絡人"),
            inputContact(emerName, "姓名", TextInputType.text),
            inputContact(emerRelationship, "關係", TextInputType.text),
            inputContact(emerPhone, "聯絡電話", TextInputType.phone),
          ])),
          // ----
          questionArea(Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textStyle("\n  是否有家族/過往病史(若沒有不必勾選)"),
              Row(
                children: [
                  textStyle("  心臟病"),
                  Checkbox(
                      value: familyPast["心臟病"],
                      onChanged: (bool? value) {
                        setState(() {
                          familyPast["心臟病"] = value;
                        });
                      }),
                ],
              ),
              Row(
                children: [
                  textStyle("  高血壓"),
                  Checkbox(
                      value: familyPast["高血壓"],
                      onChanged: (bool? value) {
                        setState(() {
                          familyPast["高血壓"] = value;
                        });
                      }),
                ],
              ),
              Row(
                children: [
                  textStyle("  高血脂"),
                  Checkbox(
                      value: familyPast["高血脂"],
                      onChanged: (bool? value) {
                        setState(() {
                          familyPast["高血脂"] = value;
                        });
                      }),
                ],
              ),
              Row(
                children: [
                  textStyle("  糖尿病"),
                  Checkbox(
                      value: familyPast["糖尿病"],
                      onChanged: (bool? value) {
                        setState(() {
                          familyPast["糖尿病"] = value;
                        });
                      }),
                ],
              ),
              Row(
                children: [
                  textStyle("  失智症"),
                  Checkbox(
                      value: familyPast["失智症"],
                      onChanged: (bool? value) {
                        setState(() {
                          familyPast["失智症"] = value;
                        });
                      }),
                ],
              ),
            ],
          )),
          // ----
          questionArea(Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textStyle("\n  是否有以下不良習慣(若沒有不必勾選)"),
              Row(
                children: [
                  textStyle("  喝酒"),
                  Checkbox(
                      value: badHabit["喝酒"],
                      onChanged: (bool? value) {
                        setState(() {
                          badHabit["喝酒"] = value;
                        });
                      }),
                ],
              ),
              Row(
                children: [
                  textStyle("  抽菸"),
                  Checkbox(
                      value: badHabit["抽菸"],
                      onChanged: (bool? value) {
                        setState(() {
                          badHabit["抽菸"] = value;
                        });
                      }),
                ],
              ),
              Row(
                children: [
                  textStyle("  熬夜"),
                  Checkbox(
                      value: badHabit["熬夜"],
                      onChanged: (bool? value) {
                        setState(() {
                          badHabit["熬夜"] = value;
                        });
                      }),
                ],
              ),
              Row(
                children: [
                  textStyle("  不運動"),
                  Checkbox(
                      value: badHabit["不運動"],
                      onChanged: (bool? value) {
                        setState(() {
                          badHabit["不運動"] = value;
                        });
                      }),
                ],
              ),
            ],
          )),
          // ----
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white)),
                  onPressed: () {
                    findKey(familyPast, familyPastKey);
                    findKey(badHabit, badHabitKey);
                    bmiCalculator();

                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Change()));
                  },
                  child: Center(child: textStyle("儲存", Colors.green)))),
          // ----
        ]))));
  }
}

void findKey(Map map, List a) {
  a.clear();
  map.forEach((key, value) {
    if (value) {
      a.add(key);
    }
  });
  print(a);
}
