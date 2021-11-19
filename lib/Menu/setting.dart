import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:flutter/material.dart';
import '/notification_api.dart';
import '/appBar.dart';
import 'Setting/contact.dart';
// import 'Setting/feedback.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MaterialApp(
      home: Setting(),
      debugShowCheckedModeBanner: false,
    ));

class Setting extends StatefulWidget {
  _SettingState createState() => _SettingState();
}

TimeOfDay _time = TimeOfDay(hour: 11, minute: 0);

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
    print("time:" + _time.hour.toString() + ":" + _time.minute.toString());
    NotificationApi.cancelAll();
    NotificationApi.scheduledNotification(
        title: '量測提醒',
        body: '該量血糖囉~~~',
        payload: 'test_msg',
        scheduleDate: _time //DateTime.now().add(Duration(seconds: 5)),
        );
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
