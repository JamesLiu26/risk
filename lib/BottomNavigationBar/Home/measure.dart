import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/appBar.dart';
import './result.dart';

class Measure extends StatefulWidget {
  @override
  _MeasureState createState() => _MeasureState();
}

class _MeasureState extends State<Measure> {
  User? _user = FirebaseAuth.instance.currentUser;
  String phNum = "";
  String gen = "";
  CollectionReference _collection =
      FirebaseFirestore.instance.collection("user");
  int total = 0,
      score01 = 0,
      score02 = 0,
      score03 = 0,
      score04 = 0,
      score05 = 0,
      score06 = 0;
  late List<int> scorelist = [
    score01,
    score02,
    score03,
    score04,
    score05,
    score06
  ];

  @override
  void initState() {
    super.initState();
    phNum = _user!.phoneNumber!;
    _collection.doc(phNum).get().then((snapshot) {
      setState(() {
        gen = snapshot.get("gender");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    tbcenter(String text,
        [fontSize, color = Colors.black, fontWeight = FontWeight.normal]) {
      return Text(
        text,
        style:
            TextStyle(color: color, fontSize: fontSize, fontWeight: fontWeight
                //letterSpacing: 1,
                ),
        //textAlign: TextAlign.center,
      );
    }

//container 背景白
    Container conbkwhite(Column content) {
      return Container(
        child: content,
        padding: EdgeInsets.all(8.0),
        margin: EdgeInsets.all(8.0),
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
      );
    }

//方框順序row
    Row conRow(String queue, String category) {
      return Row(
        children: [
          Container(
              alignment: Alignment.topLeft,
              width: MediaQuery.of(context).size.width * 0.1,
              height: MediaQuery.of(context).size.width * 0.1,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.blue),
              child: Center(
                  child: tbcenter(
                      queue,
                      MediaQuery.of(context).size.width * 0.049,
                      Colors.white,
                      FontWeight.bold))),
          SizedBox(
            width: 20,
          ),
          tbcenter(category, MediaQuery.of(context).size.width * 0.049,
              Colors.black, FontWeight.bold),
        ],
      );
    }

    //年齡radio
    RadioListTile ageRadio(int value, String detail) {
      return RadioListTile(
          title: tbcenter(detail),
          // value是取List裡的值
          value: value,
          groupValue: score01,
          onChanged: (currentValue) {
            setState(() {
              score01 = currentValue;
            });
          });
    }

    //腰圍radio
    RadioListTile waiRadio(int value, String detail) {
      return RadioListTile(
          title: tbcenter(detail),
          // value是取List裡的值
          value: value,
          groupValue: score02,
          onChanged: (currentValue) {
            setState(() {
              score02 = currentValue;
            });
          });
    }

    //家族遺傳radio
    RadioListTile genRadio(int value, String detail) {
      return RadioListTile(
          title: tbcenter(detail),
          // value是取List裡的值
          value: value,
          groupValue: score03,
          onChanged: (currentValue) {
            setState(() {
              score03 = currentValue;
            });
          });
    }

    //運動習慣radio
    RadioListTile sportRadio(int value, String detail) {
      return RadioListTile(
          title: tbcenter(detail),
          // value是取List裡的值
          value: value,
          groupValue: score04,
          onChanged: (currentValue) {
            setState(() {
              score04 = currentValue;
            });
          });
    }

    //藥物控制radio
    RadioListTile drugRadio(int value, String detail) {
      return RadioListTile(
          title: tbcenter(detail),
          // value是取List裡的值
          value: value,
          groupValue: score05,
          onChanged: (currentValue) {
            setState(() {
              score05 = currentValue;
            });
          });
    }

    //吸菸或喝酒習慣radio
    RadioListTile habitRadio(int value, String detail) {
      return RadioListTile(
          title: tbcenter(detail),
          // value是取List裡的值
          value: value,
          groupValue: score06,
          onChanged: (currentValue) {
            setState(() {
              score06 = currentValue;
            });
          });
    }

    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: appBar(
          "前期量表",
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios, color: Colors.blue[800]))),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              conbkwhite(Column(
                children: [
                  conRow("01", "年齡"),
                  Column(
                    children: [
                      ageRadio(0, "未滿40歲"),
                      ageRadio(2, "40~64歲"),
                      ageRadio(4, "65歲以上"),
                    ],
                  ),
                ],
              )),
              //
              gen == "男"
                  ? conbkwhite(Column(
                      children: [
                        conRow("02", "腰圍"),
                        Column(
                          children: [
                            waiRadio(0, "未滿90公分"),
                            waiRadio(3, "90~100公分"),
                            waiRadio(5, "100公分以上"),
                          ],
                        ),
                      ],
                    ))
                  : conbkwhite(Column(
                      children: [
                        conRow("02", "腰圍"),
                        Column(
                          children: [
                            waiRadio(0, "未滿80公分"),
                            waiRadio(3, "80~90公分"),
                            waiRadio(5, "90公分以上"),
                          ],
                        ),
                      ],
                    )),
              //
              conbkwhite(Column(
                children: [
                  conRow("03", "家族遺傳"),
                  Column(
                    children: [
                      genRadio(0, "無"),
                      genRadio(3, "旁系血親：堂表兄弟姊妹、叔叔、姑姑"),
                      genRadio(5, "直系血親：父母、兄弟姊妹、兒女"),
                    ],
                  ),
                ],
              )),
              conbkwhite(Column(
                children: [
                  conRow("04", "運動習慣 "),
                  Column(
                    children: [
                      sportRadio(0, "經常運動，每周三~五天，至少150分鐘"),
                      sportRadio(2, "偶爾運動或是甚至沒有"),
                    ],
                  ),
                ],
              )),
              conbkwhite(Column(
                children: [
                  conRow("05", "藥物控制"),
                  Column(
                    children: [
                      drugRadio(0, "無使用任何降血壓或血糖的藥"),
                      drugRadio(2, "現在或是曾經服用過降血壓或血糖的藥"),
                    ],
                  ),
                ],
              )),
              conbkwhite(Column(
                children: [
                  conRow("06", "吸菸或喝酒習慣"),
                  Column(
                    children: [
                      habitRadio(0, "無任何吸菸或喝酒的習慣"),
                      habitRadio(2, "現在有吸菸或喝酒其中一項的習慣"),
                      habitRadio(4, "以前到現在都有吸菸或喝酒的習慣")
                    ],
                  ),
                ],
              )),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.blue)),
                      child: Text("送出",
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.06,
                              color: Colors.white)),
                      onPressed: () {
                        total = 0;
                        scorelist.forEach((int val) {
                          total += val;
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Result(total)));
                      }))
            ],
          ),
        ),
      ),
    );
  }
}
