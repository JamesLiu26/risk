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
  static List<String> gender = ["男", "女"];
  String selectGender = gender[0];
  static List<String> bloodType = ["O", "A", "B", "AB"];
  String selectBloodType = bloodType[0];

  RadioListTile<String> genderRadio(String text, String value) {
    return RadioListTile(
        title: textStyle(text),
        value: value,
        groupValue: selectGender,
        onChanged: (currentValue) {
          setState(() {
            selectGender = currentValue.toString();
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
          });
        });
  }

  String birthday = "點選此處選擇出生日期";
  int age = 0;
  DateTime currentDate = DateTime.now();

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
          print(currentDate);
        }
      });
    });
  }

  double bmi = 0;
  final height = TextEditingController();
  final weight = TextEditingController();

  String status = "";

  void bmiCalculator() {
    if ((height.text != "" && weight.text != "")) {
      bmi = double.parse(weight.text) /
          ((double.parse(height.text) / 100) *
              (double.parse(height.text) / 100));
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
  }

  TextField cmKg(TextEditingController controller, String label) {
    return TextField(
      maxLength: 5,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          labelText: label,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
      onChanged: (String value) {
        setState(() {
          controller.text = value;
          bmiCalculator();
        });
      },
    );
  }

  bool? drunk = false;
  bool? smoking = false;
  bool? stayUp = false;

// ----
  Text textStyle(String text, [color = Colors.black]) {
    return Text(text,
        style: TextStyle(
            color: color, fontSize: MediaQuery.of(context).size.width * 0.045));
  }

  Container question(Widget child) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.9,
        margin: EdgeInsets.only(top: 10, bottom: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                blurRadius: 3,
              )
            ]),
        child: child);
  }

// ----
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar("基本資料填寫", Icon(Icons.quiz, color: Colors.blue[800])),
        body: SingleChildScrollView(
            child: Column(children: [
          question(
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            textStyle("  性別："),
            genderRadio("男", gender[0]),
            genderRadio("女", gender[1]),
          ])),
          // ----
          question(
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            textStyle("  血型："),
            bloodRadio("O", bloodType[0]),
            bloodRadio("A", bloodType[1]),
            bloodRadio("B", bloodType[2]),
            bloodRadio("AB", bloodType[3]),
          ])),
          question(
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              textStyle("  年齡：$age歲"),
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
          question(Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textStyle("  身高&體重："),
              textStyle("  BMI：${bmi.toStringAsFixed(1)}  狀態：$status"),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: cmKg(height, "身高"),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: cmKg(weight, "體重"),
              ),
            ],
          )),
          question(Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textStyle("  聯絡電話："), //textfield
              textStyle("  通訊地址："), //textfield
            ],
          )),
          // ----
          question(Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textStyle("  緊急連絡人："), //textfield
              textStyle("  緊急連絡人電話："), //textfield
              textStyle("  電子郵件："), //textfield
            ],
          )),
          // ----
          question(Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [textStyle("  家族病史")],
          )),
          question(Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [textStyle("  過往/現在病史")],
          )),
          // ----
          question(Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textStyle("  不良習慣："),
              Row(
                children: [
                  textStyle("  喝酒"),
                  Checkbox(
                      value: drunk,
                      onChanged: (bool? value) {
                        setState(() {
                          drunk = value;
                        });
                      }),
                ],
              ),
              Row(
                children: [
                  textStyle("  抽菸"),
                  Checkbox(
                      value: smoking,
                      onChanged: (bool? value) {
                        setState(() {
                          smoking = value;
                        });
                      }),
                ],
              ),
              Row(
                children: [
                  textStyle("  熬夜"),
                  Checkbox(
                      value: stayUp,
                      onChanged: (bool? value) {
                        setState(() {
                          stayUp = value;
                        });
                      }),
                ],
              ),
            ],
          )),
          // ----
          TextButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Change()));
              },
              child: Center(child: textStyle("儲存", Colors.green))),
          // ----
        ])));
  }
}

/*


            Text("家族病史"),
            Text("過往病史"),
            //
            Text("生活習慣"),
*/
