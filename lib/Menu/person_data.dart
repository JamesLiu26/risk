import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../appBar.dart';

void main() {
  runApp(MaterialApp(
    home: PersonData(),
    debugShowCheckedModeBanner: false,
  ));
}

FirebaseAuth _auth = FirebaseAuth.instance;
CollectionReference _collection = FirebaseFirestore.instance.collection("user");

class PersonData extends StatefulWidget {
  @override
  _PersonDataState createState() => _PersonDataState();
}

class _PersonDataState extends State<PersonData> {
  String _phNum = _auth.currentUser!.phoneNumber!;
  String _name = "";
  String _gender = "";
  String _address = "";
  String _mail = "";
  String _emerName = "";
  String _emerRel = "";
  String _emerPh = "";

  Text textStyle(String text, [double rate = 0.045]) {
    return Text(text,
        style: TextStyle(fontSize: MediaQuery.of(context).size.width * rate));
  }

  Padding textLayout(String text1, String text2) {
    return Padding(
      padding: EdgeInsets.only(left: 14, top: 10, bottom: 10, right: 14),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [textStyle(text1), textStyle(text2)]),
    );
  }

  @override
  initState() {
    super.initState();
    _collection.doc(_phNum).get().onError((error, stackTrace) {
      throw "========${error.toString()}=============";
    }).then((snapshot) {
      setState(() {
        _name = snapshot.get("name");
        _gender = snapshot.get("gender");
        _address = snapshot.get("address");
        _mail = snapshot.get("email");
        _emerName = snapshot.get("emerName");
        _emerRel = snapshot.get("emerRelationship");
        _emerPh = snapshot.get("emerPhone");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(
          "個人資料",
          IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.blue[800]),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(children: [textStyle("  基本資料", 0.05)]),
                textLayout("姓名", _name),
                textLayout("性別", _gender),
                textLayout("行動電話", _phNum),
                Divider(
                  color: Colors.grey,
                ),
                Row(children: [textStyle("  聯絡方式", 0.05)]),
                textLayout("通訊地址", _address),
                textLayout("電子郵件", _mail),
                Divider(
                  color: Colors.grey,
                ),
                Row(children: [textStyle("  緊急聯絡人資料", 0.05)]),
                textLayout("姓名", _emerName),
                textLayout("關係", _emerRel),
                textLayout("行動電話", _emerPh),
              ]),
        ));
  }
}
