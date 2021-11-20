import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import './signup.dart';
import './login.dart';
import './change.dart';
import './notification_api.dart';
import 'BottomNavigationBar/notification.dart';
//
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;

// import 'package:timezone/timezone.dart' as tz;
const AndroidNotificationChannel channel = const AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBgHandler); //程式背景執行
  tz.initializeTimeZones();
  await FlutterLocalNotificationsPlugin()
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
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
  void initState() {
    super.initState();

    NotificationApi.init(initScheduled: true);
    listenNotifications();
  }

  void listenNotifications() =>
      NotificationApi.onNotifications.stream.listen(onClickNotification);
  void onClickNotification(String? payload) {
    if (mounted) {
      setState(() {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Notify()));
        print("123hello");
      });
      print("456hello");
    }
  }

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

  getToken() async {
    final gettoken = await FirebaseMessaging.instance.getToken();
    String token = "The token is " + gettoken.toString();
    print(token);
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
