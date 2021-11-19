import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/appBar.dart';
import 'package:risk/notification_api.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';

class Remind extends StatefulWidget {
  @override
  _RemindState createState() => _RemindState();
}

//設定提醒時間
DateTime df =
    new DateFormat("yyyy-MM-dd hh:mm:ss").parse("2021-11-16 14:45:00.000");

class _RemindState extends State<Remind> {
  TimeOfDay _time = TimeOfDay(hour: 11, minute: 0);
  void onTimeChanged(TimeOfDay time) {
    setState(() {
      _time = time;
      print("time:" + _time.hour.toString() + ":" + _time.minute.toString());
      NotificationApi.cancelAll();
      NotificationApi.scheduledNotification(
          title: 'Test Message',
          body: 'It is a message',
          payload: 'test_msg',
          scheduleDate: _time //DateTime.now().add(Duration(seconds: 5)),
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        "提醒時間",
        IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.blue[800]),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
          child: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Text(
            "設定提醒時間可以在每日提醒您測量血糖",
            style: TextStyle(fontSize: 30),
          ),
          SizedBox(
            height: 50,
          ),
          ElevatedButton(
            child: Text("設定時間"),
            onPressed: () {
              Navigator.of(context).push(
                showPicker(
                  value: _time,
                  onChange: onTimeChanged,
                  context: context,
                ),
              );
            },
          ),
        ],
      )),
    );
  }
}
