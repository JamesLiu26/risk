import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import './signup.dart';
import './login.dart';
import './change.dart';
//
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // 螢幕直向
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  return runApp(MaterialApp(
    // 用在showDatePicker，顯示中文
    localizationsDelegates: [GlobalMaterialLocalizations.delegate],
    supportedLocales: [Locale("zh", "TW")],
    home: FirebaseAuth.instance.currentUser != null
        ? Change()
        : Risk(), /////////////
    debugShowCheckedModeBanner: false,
  ));
}

class Risk extends StatefulWidget {
  @override
  _RiskState createState() => _RiskState();
}

class _RiskState extends State<Risk> {
  // final _notify = FlutterLocalNotificationsPlugin();
  // 點選通知terminal端會顯示訊息
  // Future selectNotify(String? _) async {
  //   Navigator.push(context, MaterialPageRoute(builder: (context) => Trace()));
  // }

  // int year = DateTime.now().year;
  // int month = DateTime.now().month;
  // int day = DateTime.now().day;

  // @override
  // // void initState() {
  // //   super.initState();
  // //   // 時區初始化
  // //   tz.initializeTimeZones();

  // //   // android設定初始化
  // //   // final _androidInit = AndroidInitializationSettings("@mipmap/ic_launcher");
  // //   // final _initializeSetting = InitializationSettings(android: _androidInit);
  // //   // _notify.initialize(_initializeSetting, onSelectNotification: selectNotify);
  // //   // Timer.periodic(Duration(seconds: 1), (_) {
  // //   //   setState(() {
  // //   //     // 即時更新時間
  // //   //     year = DateTime.now().year;
  // //   //     month = DateTime.now().month;
  // //   //     day = DateTime.now().day;
  // //   //   });
  // //   // });
  // //   // show();
  // // }

  // Future show() async {
  //   final _android = AndroidNotificationDetails(
  //       "channel Id", "channel Name", "channel Description",
  //       priority: Priority.max, importance: Importance.max);
  //   final _platform = NotificationDetails(android: _android);

  //   // 設定提醒時間(有lag)
  //   var dt = DateTime(year, month, day, 11, 25, 0);
  //   schedule(dt, _platform);
  // }

  // Future schedule(DateTime dateTime, NotificationDetails nD) async {
  //   // 要顯示的訊息
  //   await _notify.zonedSchedule(
  //       0, "爛專題", "量血糖囉", tz.TZDateTime.from(dateTime, tz.local), nD,
  //       uiLocalNotificationDateInterpretation:
  //           UILocalNotificationDateInterpretation.wallClockTime,
  //       androidAllowWhileIdle: false);
  // }

  /*
    註冊登入button
    text為button的文字
    route為按下button所要跳轉的page
  */
  ElevatedButton signButton(text, Widget route) {
    return ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.green)),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => route));
        },
        child: Text(text,
            style:
                TextStyle(fontSize: MediaQuery.of(context).size.width * 0.06)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(gradient: linearGradient()),
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("糖尿病\n健康管理",
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.1,
                        color: Colors.white,
                        height: 1.5),
                    textAlign: TextAlign.center),
                Column(
                  children: [
                    signButton("註冊", SignUp()),
                    SizedBox(height: 50),
//-------------------------
                    signButton("登入", Login())
                  ],
                ),
              ],
            ))));
  }
}

// background 顏色
LinearGradient linearGradient() {
  return LinearGradient(
      colors: [
        Color(0xFF00A09A),
        Colors.white,
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: [0.3, 1]);
}
