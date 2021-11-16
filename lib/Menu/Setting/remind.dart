import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/appBar.dart';
import 'package:risk/notification_api.dart';

class Remind extends StatefulWidget {
  @override
  _RemindState createState() => _RemindState();
}

//設定提醒時間
DateTime df =
    new DateFormat("yyyy-MM-dd hh:mm:ss").parse("2021-11-16 14:45:00.000");

class _RemindState extends State<Remind> {
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
        child: ElevatedButton(
          child: Text("data"),
          onPressed: () {
            NotificationApi.scheduledNotification(
                title: 'Test Message',
                body: 'It is a message',
                payload: 'test_msg',
                scheduleDate: df //DateTime.now().add(Duration(seconds: 5)),
                );
          },
        ),
      ),
    );
  }
}
