import 'package:flutter/material.dart';
import './appBar.dart';

void main() {
  return runApp(MaterialApp(
    home: SignUp(),
    debugShowCheckedModeBanner: false,
  ));
}

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final phone = TextEditingController();
  final name = TextEditingController();
  final password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(
            "註冊",
            IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.blue[800]),
              onPressed: () {
                Navigator.pop(context);
              },
            )),
        body: SingleChildScrollView(
            child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
              Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                  textInputSignUp(name, "姓名", context),
                  //---------------------------------------------------------
                  textInputSignUp(phone, "行動電話", context),
                  //---------------------------------------------------------
                  textInputSignUp(password, "密碼", context, true),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.green)),
                  onPressed: () {},
                  child: Text("註冊",
                      style: TextStyle(
                          fontSize:
                              MediaQuery.of(context).size.height * 0.03))),
            ]))));
  }
}

Padding textInputSignUp(
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
