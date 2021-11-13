import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

class PersonData extends StatefulWidget {
  @override
  _PersonDataState createState() => _PersonDataState();
}

class _PersonDataState extends State<PersonData> {
  //
  bool canEdit = false;
  //
  String name = "";
  String originalGender = "";
  String selectGender = "男";
  String address = "";
  String email = "";
  String emerName = "";
  String emerRelationship = "";
  String originalEmerPhone = "";
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

  //
  void updateEmerPhone(PhoneNumber phone) {
    afterEmerPhone = phone.toString();
  }

  Padding editPhone(
      String phone, String? errorText, Function(PhoneNumber ph) changePhone) {
    double fontSize = MediaQuery.of(context).size.width * 0.052;
    TextStyle style = TextStyle(fontSize: fontSize);
    return Padding(
        padding: EdgeInsets.only(top: 10),
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
        originalGender = snapshot.get("gender");
        address = snapshot.get("address");
        email = snapshot.get("email");
        emerName = snapshot.get("emerName");
        emerRelationship = snapshot.get("emerRelationship");
        originalEmerPhone = snapshot.get("emerPhone");
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
    if (afterEmerPhone != "") {
      if (!afterEmerPhone.contains(RegExp("\^\\+8869[0-9]{8}\$"), 0)) {
        errorEmerPhone = "行動電話格式不正確";
      } else {
        errorEmerPhone = null;
        _doc.update({"emerPhone": afterEmerPhone});
        updateVal++;
      }
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
                    if (errorEmerPhone == null) {
                      canEdit = false;
                    }
                  } else {
                    canEdit = true;
                  }
                  setState(() {});
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
          Divider(color: Colors.blue[200], thickness: 2),
          //
          Row(children: [textStyle(" 聯絡方式", 0.06)]),
          // layout("行動電話", textStyle(_phNum)),
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
          layout("行動電話", textStyle(originalEmerPhone),
              editPhone(originalEmerPhone, errorEmerPhone, updateEmerPhone)),
        ]),
      ),
    );
  }
}
