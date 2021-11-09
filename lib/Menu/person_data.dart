import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../appBar.dart';

// void main() {
//   runApp(MaterialApp(
//     home: PersonData(),
//     debugShowCheckedModeBanner: false,
//   ));
// }

FirebaseAuth _auth = FirebaseAuth.instance;
CollectionReference _collection = FirebaseFirestore.instance.collection("user");
String _phNum = _auth.currentUser!.phoneNumber!;

class PersonData extends StatefulWidget {
  @override
  _PersonDataState createState() => _PersonDataState();
}

class _PersonDataState extends State<PersonData> {
  String name = "";
  String gender = "";
  String address = "";
  String mail = "";
  String emerName = "";
  String emerRel = "";
  String emerPh = "";
  bool normal = false;
  bool contact = false;
  bool emerContact = false;
  Text textStyle(String text, [double rate = 0.052]) {
    return Text(text,
        style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * rate, height: 1.5));
  }

  Container textLayout(String text1, String text2) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(children: [
        Row(children: [textStyle(text1)]),
        Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [textStyle(text2)])
      ]),
    );
  }

  @override
  initState() {
    super.initState();
    _collection.doc(_phNum).get().onError((error, stackTrace) {
      throw "========${error.toString()}=============";
    }).then((snapshot) {
      setState(() {
        name = snapshot.get("name");
        gender = snapshot.get("gender");
        address = snapshot.get("address");
        mail = snapshot.get("email");
        emerName = snapshot.get("emerName");
        emerRel = snapshot.get("emerRelationship");
        emerPh = snapshot.get("emerPhone");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double iconSize = MediaQuery.of(context).size.width * 0.08;
    return Scaffold(
        appBar: AppBar(
          title: Text("個人資料", style: TextStyle(color: Colors.black)),
          backgroundColor: Color.fromARGB(255, 225, 230, 255),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.blue[800]),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            Row(
              children: [
                IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.edit_outlined,
                        size: iconSize, color: Colors.blue[800])),
              ],
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        textStyle(" 基本資料", 0.06),
                      ]),
                  Column(children: [
                    textLayout("姓名", name),
                    textLayout("性別", gender),
                    textLayout("行動電話", _phNum),
                  ]),
                  Divider(
                    color: Colors.grey,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [textStyle(" 聯絡方式", 0.06)]),
                  textLayout("通訊地址", address),
                  textLayout("電子郵件", mail),
                  Divider(
                    color: Colors.grey,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [textStyle(" 緊急聯絡人資料", 0.06)]),
                  textLayout("姓名", emerName),
                  textLayout("關係", emerRel),
                  textLayout("行動電話", emerPh),
                ]),
          ),
        ));
  }
}
