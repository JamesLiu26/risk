import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import './login.dart';
import './appBar.dart';

// void main() {
//   return runApp(MaterialApp(
//     home: PerQuest(),
//     debugShowCheckedModeBanner: false,
//   ));
// }

class PerQuest extends StatefulWidget {
  @override
  _PerQuestState createState() => _PerQuestState();
}

List<String> gender = ["男", "女"];
List<String> bloodType = ["O", "A", "B", "AB"];

class _PerQuestState extends State<PerQuest> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference _collection =
      FirebaseFirestore.instance.collection("user");
  //
  Future<void> addData() async {
    if (_auth.currentUser != null) {
      print("Write data!!!");
      // 取user集合的文件(用電話號碼)
      DocumentReference doc = _collection.doc(_auth.currentUser!.phoneNumber);
      doc.set({
        "gender": selectGender,
        "pregnant": selectGender == "女" ? double.parse(pregnant.text) : 0.0,
        "bloodType": selectBloodType,
        "birthday": birthday,
        "age": age,
        "history": selectHistory,
        "diabetesPedigreeFunction": dpf,
        "address": contactAddress.text,
        "email": contactMail.text,
        "emerName": emerName.text,
        "emerRelationship": emerRelationship.text,
        "emerPhone": emerPhone
      }, SetOptions(merge: true)).whenComplete(() {
        _auth.signOut();
      });
    }
  }

  // 性別核選框，預設為男
  String selectGender = gender[0];

  // 懷孕次數
  final pregnant = TextEditingController();

  // 血型核選框，預設為O型
  String selectBloodType = bloodType[0];

  //生日
  String birthday = "點選此處選擇生日";
  double age = 0;
  // 當下時間
  DateTime currentDate = DateTime.now();

  // 家族/過往病史
  static List<String> diabeteHistory = ["無", "有"];
  String selectHistory = diabeteHistory[0];
  double dpf = 0;

  // 聯絡資訊
  final contactAddress = TextEditingController();
  final contactMail = TextEditingController();
  String? errorAddress;

  // 緊急連絡人
  final emerName = TextEditingController();
  final emerRelationship = TextEditingController();
  String emerPhone = "";

  String? errorNa;
  String? errorRe;
  String? errorPh;

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
  RadioListTile genderRadio(String value) {
    return RadioListTile(
        title: textStyle(value),
        // value是取List裡的值
        value: value,
        groupValue: selectGender,
        onChanged: (currentValue) {
          setState(() {
            selectGender = currentValue;
          });
        });
  }

  // 血型radio buttons
  RadioListTile bloodRadio(String value) {
    return RadioListTile(
        title: textStyle(value),
        value: value,
        groupValue: selectBloodType,
        onChanged: (currentValue) {
          setState(() {
            selectBloodType = currentValue;
          });
        });
  }

  // 日期選擇(生日)
  Future<DateTime?> chooseBirthday() {
    return showDatePicker(
      builder: (conetxt, child) => Theme(
          child: child!,
          data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light(primary: Color(0xff1565c0)))),
      // 一開始先選年
      initialDatePickerMode: DatePickerMode.year,
      // 只能透過日曆選日期
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(currentDate.year - 100),
      lastDate: currentDate,
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

  // 病史
  RadioListTile historyRadio(String value) {
    return RadioListTile(
        title: textStyle(value),
        value: value,
        groupValue: selectHistory,
        onChanged: (currentValue) {
          setState(() {
            selectHistory = currentValue;
            if (selectHistory == diabeteHistory[1])
              dpf = 1;
            else
              dpf = 0;
          });
        });
  }

  // 其他判斷
  String? errorData(String text) {
    String? error;
    if (text.trim() == "" || text.isEmpty) {
      error = "不可空白!";
    } else {
      error = null;
    }

    return error;
  }

  // 電話判斷
  void errorEmerPhone() {
    if (emerPhone.isEmpty || emerPhone.trim() == "") {
      errorPh = "不可空白！";
    } else if (!emerPhone.contains(RegExp("\^\\+8869[0-9]{8}\$"), 0)) {
      errorPh = "行動電話格式不正確！";
    } else {
      errorPh = null;
    }
  }

  Padding contactEmerPhone() {
    return Padding(
        padding: EdgeInsets.all(8),
        child: InternationalPhoneNumberInput(
            selectorConfig: SelectorConfig(
                showFlags: false, setSelectorButtonAsPrefixIcon: true),
            countries: ["TW"],
            keyboardType: TextInputType.phone,
            inputDecoration: InputDecoration(
                labelText: "行動電話",
                floatingLabelBehavior: FloatingLabelBehavior.never,
                errorText: errorPh,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)))),
            onInputChanged: (phNum) {
              emerPhone = phNum.toString();
            }));
  }

  // 其他文字輸入框
  Padding dataField(TextEditingController controller, String label, String hint,
      String? error) {
    return Padding(
        padding: EdgeInsets.all(8.0),
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

  // 問題資料區塊
  Container questionArea(Widget child) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.9,
        margin: EdgeInsets.only(top: 15, bottom: 15),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: child);
  }

// ---

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
                      selectGender == "女"
                          ? questionArea(Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                textStyle("\n  是否有懷孕過"),
                                dataField(pregnant, "懷孕次數", "沒有請填0", null)
                              ],
                            ))
                          : Row(),
                      // ---
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
                                  padding: EdgeInsets.all(10),
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
                            textStyle("\n  是否有糖尿病家族/過往病史"),
                            historyRadio(diabeteHistory[0]),
                            historyRadio(diabeteHistory[1])
                          ])),

                      // ----
                      questionArea(Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            textStyle("\n  聯絡資訊"),
                            dataField(contactMail, "Mail(沒有可不必填寫)",
                                "例：XXX@gmail.com", null),
                            dataField(contactAddress, "通訊地址", "例：XX市XX區...",
                                errorAddress),
                          ])),

                      questionArea(Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          textStyle("\n  緊急聯絡人"),
                          dataField(emerName, "姓名", "", errorNa),
                          dataField(emerRelationship, "關係", "", errorRe),
                          contactEmerPhone()
                        ],
                      )),

                      // ----

                      OutlinedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.green)),
                          onPressed: () async {
                            FocusScopeNode focus = FocusScope.of(context);
                            // 把TextField的focus移掉
                            if (!focus.hasPrimaryFocus) {
                              focus.unfocus();
                            }

                            setState(() {
                              // 傳遞錯誤訊息
                              errorAddress = errorData(contactAddress.text);
                              errorNa = errorData(emerName.text);
                              errorRe = errorData(emerRelationship.text);
                              errorEmerPhone();
                            });
                            if (birthday != "點選此處選擇生日" &&
                                errorAddress == null &&
                                errorNa == null &&
                                errorRe == null &&
                                errorPh == null) {
                              await addData();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Login()));
                            }
                          },
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.2,
                              child: Center(
                                  child: textStyle("儲存", Colors.white)))),
                    ])))));
  }
}
