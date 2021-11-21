import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/notification_api.dart';
import '/appBar.dart';
import 'Setting/contact.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'Setting/feedback.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MaterialApp(
      home: Setting(),
      debugShowCheckedModeBanner: false,
    ));

class Setting extends StatefulWidget {
  _SettingState createState() => _SettingState();
}

FirebaseFirestore storeNotify = FirebaseFirestore.instance;
FirebaseAuth _auth = FirebaseAuth.instance;
TimeOfDay _time = TimeOfDay(hour: 11, minute: 0);
String _phNum = _auth.currentUser!.phoneNumber!;
String _title = "量測血糖";
String _body = "該量血糖了~~~";

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        "設定",
        IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.blue[800]),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Spacer(flex: 1),
          settingPages(context, "提醒時間"),
          Divider(color: Colors.grey),
          settingPages(context, "醫院聯絡方式"),
          Divider(color: Colors.grey),
          settingPages(context, "意見回饋"),
          Divider(color: Colors.grey),
          Spacer(flex: 10)
        ],
      ),
    );
  }
}

GestureDetector settingPages(BuildContext context, String text) {
  String mail = "fkproject123@gmail.com";
  Future<void> toMail() async {
    if (await canLaunch("mailto:$mail")) {
      launch("mailto:$mail");
    } else {
      throw "Error!";
    }
  }

  void onTimeChanged(TimeOfDay time) {
    _time = time;
    DateTime now = DateTime.now();
    String setTime = "";
    print("time:" + _time.hour.toString() + ":" + _time.minute.toString());
    NotificationApi.cancelAll();
    //if(DateFormat("HH:mm").format(DateTime.now())==DateFormat("HH:mm").format(DateTime(now.year,now.month,now.day,_time.hour,_time.minute))){
    setTime = DateFormat("yyyy-MM-dd HH:mm:ss").format(
        DateTime(now.year, now.month, now.day, _time.hour, _time.minute));
    NotificationApi.scheduledNotification(
        title: _title,
        body: _body,
        payload: 'test_msg',
        scheduleDate: _time //DateTime.now().add(Duration(seconds: 5)),
        );
    storeNotify
        .collection("Notification")
        .doc(_phNum)
        .collection("news")
        .doc(setTime)
        .set({
      'title': _title,
      'body': _body,
    });
    //}
    // print(time);
    // print(DateFormat("HH:mm").format(DateTime.now()));
  }

  return GestureDetector(
    onTap: () {
      if (text == "提醒時間") {
        Navigator.of(context).push(
          showPicker(
              value: _time,
              onChange: onTimeChanged,
              context: context,
              cancelText: "取消",
              okText: "確定"),
        );
      } else if (text == "醫院聯絡方式") {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Contact()));
      } else if (text == "意見回饋") {
        toMail();
      }
    },
    child: Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "  $text",
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.06,
                  height: 1.5),
            ),
          ],
        )),
  );
}
