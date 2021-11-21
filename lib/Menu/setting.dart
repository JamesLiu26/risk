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

FirebaseFirestore _storeNotify = FirebaseFirestore.instance;
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
    time.format(context);
    String timeString = time.hour.toString() + ":" + time.minute.toString();
    _storeNotify
        .collection("Notification")
        .doc(_phNum)
        .set({"time": timeString});

    DateTime now = DateTime.now();
    String setTime = "";

    NotificationApi.cancelAll();

    setTime = DateFormat("yyyy-MM-dd HH:mm:ss").format(
        DateTime(now.year, now.month, now.day, _time.hour, _time.minute));
    NotificationApi.scheduledNotification(
        title: _title,
        body: _body,
        payload: 'test_msg',
        scheduleDate: _time //DateTime.now().add(Duration(seconds: 5)),
        );
    _storeNotify
        .collection("Notification")
        .doc(_phNum)
        .collection("news")
        .doc(setTime)
        .set({'title': _title, 'body': _body, 'read': false});

    // print(DateFormat("HH:mm").format(DateTime.now()));
  }

  return GestureDetector(
    onTap: () {
      if (text == "提醒時間") {
        _storeNotify
            .collection("Notification")
            .doc(_phNum)
            .get()
            .then((snapshot) {
          TimeOfDay timeOfDay;
          if (!snapshot.data()!.containsKey("time")) {
            timeOfDay = _time;
          } else {
            List<String> timeStr = snapshot.get("time").toString().split(":");
            timeOfDay = TimeOfDay(
                hour: int.parse(timeStr[0]), minute: int.parse(timeStr[1]));
          }

          Navigator.of(context).push(
            showPicker(
                value: timeOfDay,
                onChange: onTimeChanged,
                context: context,
                cancelText: "取消",
                okText: "確定"),
          );
        });
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
