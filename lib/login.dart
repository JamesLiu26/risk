import 'package:flutter/material.dart';
import './personal_questionnaire.dart';
import './appBar.dart';
import './main.dart';

void main() {
  return runApp(MaterialApp(
    home: Login(),
    debugShowCheckedModeBanner: false,
  ));
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final phone = TextEditingController();
  final password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
          "登入",
          IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.blue[800]),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Risk()));
            },
          )),
      body: SingleChildScrollView(
          child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
            Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.25),
                textInputLogin(phone, "行動電話", context),
                //---------------------------------------------------------
                textInputLogin(password, "密碼", context, true)
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.green)),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => PerQuest()));
                },
                child: Text("登入",
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.03))),
          ]))),
    );
  }
}

Padding textInputLogin(
    TextEditingController data, String labelText, BuildContext context,
    [bool isPassword = false]) {
  return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
      child: TextField(
        controller: data,
        style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.03),
        decoration: InputDecoration(
            labelText: labelText,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)))),
        obscureText: isPassword,
        obscuringCharacter: "*",
      ));
}
