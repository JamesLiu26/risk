import 'package:flutter/material.dart';
import './signup.dart';
import './login.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // 螢幕直向
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  return runApp(MaterialApp(
    // 用在showDatePicker，顯示中文
    localizationsDelegates: [GlobalMaterialLocalizations.delegate],
    supportedLocales: [Locale("zh", "TW")],
    home: Risk(),
    debugShowCheckedModeBanner: false,
  ));
}

class Risk extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: Center(
                child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text("疾病風險評估",
            style:
                TextStyle(fontSize: MediaQuery.of(context).size.height * 0.05)),
        Column(
          children: [
            signButton("註冊", SignUp(), context),
            SizedBox(height: 50),
//-------------------------
            signButton("登入", Login(), context)
          ],
        ),
      ],
    ))));
  }
}

ElevatedButton signButton(text, Widget route, BuildContext context) {
  return ElevatedButton(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.green)),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => route));
      },
      child: Text(text,
          style:
              TextStyle(fontSize: MediaQuery.of(context).size.height * 0.03)));
}
