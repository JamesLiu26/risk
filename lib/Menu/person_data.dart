import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

// void main() {
//   runApp(MaterialApp(
//     home: PersonData(),
//     debugShowCheckedModeBanner: false,
//   ));
// }

FirebaseAuth _auth = FirebaseAuth.instance;
CollectionReference _collection = FirebaseFirestore.instance.collection("user");
String _phNum = _auth.currentUser!.phoneNumber!;
DocumentReference _doc = _collection.doc(_phNum);
// String _verifyId = "";

class PersonData extends StatefulWidget {
  @override
  _PersonDataState createState() => _PersonDataState();
}

class _PersonDataState extends State<PersonData> {
  //
  bool canEdit = false;
  bool isPassword = true;
  //
  String name = "";
  String originalGender = "";
  String selectGender = "男";
  String password = "";
  var pwdController = TextEditingController();
  String? errorPassword;
  //
  String userPhone = _phNum;
  String? errorUserPhone;
  var otpController = TextEditingController();
  String address = "";
  String email = "";
  //
  String emerName = "";
  String emerRelationship = "";
  String emerPhone = "";
  String afterEmerPhone = "";
  String? errorEmerPhone;
  //
  //
  late Map<String, TextEditingController> inputGroup = {
    "name": TextEditingController(),
    "address": TextEditingController(),
    "email": TextEditingController(),
    "emerName": TextEditingController(),
    "emerRelationship": TextEditingController()
  };

  Padding editField(TextEditingController controller, String hintText) {
    double fontSize = MediaQuery.of(context).size.width * 0.052;
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: TextField(
          controller: controller,
          style: TextStyle(fontSize: fontSize),
          decoration: InputDecoration(
              hintText: hintText,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)))),
    );
  }

  Padding editPassword() {
    double fontSize = MediaQuery.of(context).size.width * 0.052;
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: TextField(
          controller: pwdController,
          style: TextStyle(fontSize: fontSize),
          obscuringCharacter: "*",
          obscureText: isPassword,
          decoration: InputDecoration(
              hintText: "至少6個字元",
              errorText: errorPassword,
              suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      if (isPassword) {
                        // 顯示密碼
                        isPassword = false;
                      } else {
                        isPassword = true;
                      }
                    });
                  },
                  icon: Icon(Icons.visibility)),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)))),
    );
  }

  //
  void updateUserPhone(PhoneNumber phone) {
    userPhone = phone.toString();
  }

  void updateEmerPhone(PhoneNumber phone) {
    afterEmerPhone = phone.toString();
  }

  Padding editPhone(
      String phone, String? errorText, Function(PhoneNumber ph) changePhone) {
    double fontSize = MediaQuery.of(context).size.width * 0.052;
    TextStyle style = TextStyle(fontSize: fontSize);
    return Padding(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: InternationalPhoneNumberInput(
            selectorConfig: SelectorConfig(
                showFlags: false, setSelectorButtonAsPrefixIcon: true),
            countries: ["TW"],
            keyboardType: TextInputType.phone,
            selectorTextStyle: style,
            textStyle: style,
            inputDecoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.never,
                hintText: phone != "" ? phone.substring(4) : "",
                errorText: errorText,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)))),
            onInputChanged: changePhone));
  }

  //
  // verifyPhone(String phNumber) async {
  //   await _auth.verifyPhoneNumber(
  //       phoneNumber: phNumber,
  //       verificationCompleted: (_) async {
  //         print("Successful");
  //       },
  //       verificationFailed: (FirebaseAuthException e) {
  //         print("====" + e.message.toString() + "====");
  //       },
  //       codeSent: (String id, int? token) async {
  //         print("OTP is sent!");
  //         _verifyId = id;
  //       },
  //       codeAutoRetrievalTimeout: (String id) {
  //         print("Resend");
  //         _verifyId = id;
  //       },
  //       timeout: Duration(seconds: 120));
  // }

  Padding otpField() {
    double fontSize = MediaQuery.of(context).size.width * 0.052;
    return Padding(
        padding: EdgeInsets.only(top: 10),
        child: TextField(
            controller: otpController,
            style: TextStyle(fontSize: fontSize),
            keyboardType: TextInputType.number,
            maxLength: 6,
            decoration: InputDecoration(
                hintText: "輸入驗證碼",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)))));
  }

  Column phoneVerify() {
    // double fontSize = MediaQuery.of(context).size.width * 0.052;
    // var color = MaterialStateProperty.all(Colors.blue[800]);
    return Column(children: [
      editPhone(_phNum, errorUserPhone, updateUserPhone),
      // ElevatedButton(
      //     style: ButtonStyle(backgroundColor: color),
      //     onPressed: () {},
      //     child: Text("傳送驗證碼", style: TextStyle(fontSize: fontSize))),
      // otpField()
    ]);
  }

  Text textStyle(String text, [double rate = 0.052]) {
    return Text(text,
        style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * rate, height: 2));
  }

  Padding genderRadio(String val) {
    return Padding(
        padding: EdgeInsets.only(top: 15),
        child: Radio(
            value: val,
            groupValue: selectGender,
            onChanged: (selVal) {
              setState(() {
                selectGender = selVal.toString();
              });
            }));
  }

  Container layout(String text, Widget beforeWidget, Widget afterWidget) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(children: [
        Align(alignment: Alignment.centerLeft, child: textStyle(text)),
        Align(
            alignment: Alignment.centerRight,
            child: canEdit ? afterWidget : beforeWidget)
      ]),
    );
  }

  void getData() {
    _doc.get().onError((error, stackTrace) {
      throw "========${error.toString()}=============";
    }).then((snapshot) {
      setState(() {
        name = snapshot.get("name");
        password = snapshot.get("password");
        originalGender = snapshot.get("gender");
        address = snapshot.get("address");
        email = snapshot.get("email");
        emerName = snapshot.get("emerName");
        emerRelationship = snapshot.get("emerRelationship");
        emerPhone = snapshot.get("emerPhone");
      });
    });
  }

  void updateData() {
    int updateVal = 0;
    inputGroup.forEach((key, value) {
      if (value.text != "") {
        _doc.update({key: value.text});
        value.clear();
        updateVal++;
      }
    });
    if (originalGender != selectGender) {
      _doc.update({"gender": selectGender});
      updateVal++;
    }
    if (userPhone != "" && userPhone != "+886") {
      if (!userPhone.contains(RegExp("\^\\+8869[0-9]{8}\$"), 0)) {
        errorUserPhone = "行動電話格式不正確";
      } else {
        _collection.get().then((snapshot) {
          var listDocs = snapshot.docs;
          setState(() {
            for (var doc in listDocs) {
              if (userPhone == doc.id && _phNum != doc.id) {
                errorUserPhone = "此電話號碼已註冊過！";
                break;
              } else {
                errorUserPhone = null;
                updateVal++;
              }
            }
          });
        });
        // print(userPhone);
        // _doc.update({"emerPhone": userPhone});

      }
    } else {
      errorUserPhone = null;
    }

    if (afterEmerPhone != "" && afterEmerPhone != "+886") {
      if (!afterEmerPhone.contains(RegExp("\^\\+8869[0-9]{8}\$"), 0)) {
        errorEmerPhone = "行動電話格式不正確";
      } else {
        errorEmerPhone = null;
        _doc.update({"emerPhone": afterEmerPhone});
        updateVal++;
      }
    } else {
      errorEmerPhone = null;
    }
    if (pwdController.text != "") {
      if (pwdController.text.length < 6) {
        errorPassword = "密碼不可小於6個字！";
      } else {
        errorPassword = null;
        _doc.update({"password": pwdController.text});
        updateVal++;
        pwdController.clear();
      }
    } else {
      errorPassword = null;
    }
    if (updateVal >= 1) {
      // 有更新才抓資料
      getData();
      updateVal = 0;
    }
  }

  @override
  initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("個人資料", style: TextStyle(color: Colors.black)),
          backgroundColor: Color.fromARGB(255, 225, 230, 255),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.blue[800]),
            onPressed: () {
              FocusScopeNode focus = FocusScope.of(context);
              if (!focus.hasPrimaryFocus) focus.unfocus();
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
                onPressed: () {
                  if (canEdit) {
                    updateData();
                    Future.delayed(Duration(seconds: 2), () {
                      if (errorEmerPhone == null &&
                          errorPassword == null &&
                          errorUserPhone == null) {
                        setState(() {
                          canEdit = false;
                        });
                      }
                    });
                  } else {
                    setState(() {
                      canEdit = true;
                    });
                  }
                },
                icon: Icon(canEdit ? Icons.check : Icons.edit_outlined,
                    size: 30, color: Colors.blue[800]))
          ]),
      body: SingleChildScrollView(
        child: Column(children: [
          Row(children: [textStyle(" 基本資料", 0.06)]),
          layout("姓名", textStyle(name), editField(inputGroup["name"]!, name)),
          layout(
              "性別",
              textStyle(originalGender),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                Row(children: [textStyle("男"), genderRadio("男")]),
                Row(children: [textStyle("女"), genderRadio("女")])
              ])),
          layout("密碼", textStyle("******"), editPassword()),
          Divider(color: Colors.blue[200], thickness: 2),
          //
          Row(children: [textStyle(" 聯絡方式", 0.06)]),
          layout("行動電話", textStyle(_phNum), phoneVerify()),
          layout("通訊地址", textStyle(address),
              editField(inputGroup["address"]!, address)),
          layout(
              "電子郵件", textStyle(email), editField(inputGroup["email"]!, email)),
          Divider(color: Colors.blue[200], thickness: 2),
          //
          Row(children: [textStyle(" 緊急聯絡人資料", 0.06)]),
          layout("姓名", textStyle(emerName),
              editField(inputGroup["emerName"]!, emerName)),
          layout("關係", textStyle(emerRelationship),
              editField(inputGroup["emerRelationship"]!, emerRelationship)),
          layout("行動電話", textStyle(emerPhone),
              editPhone(emerPhone, errorEmerPhone, updateEmerPhone)),
        ]),
      ),
    );
  }
}
