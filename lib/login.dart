import 'package:flutter/material.dart';
import './change.dart';
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
  final mail = TextEditingController();
  final password = TextEditingController();
  bool isPassword = true;
  String? errorMail;
  String? errorPassword;

  void showErrorMail() {
    if (mail.text.isEmpty || mail.text.trim() == "") {
      errorMail = "不可空白！";
      // } else if (!mail.text.contains(RegExp("\^09[0-9]{8}\$"), 0)) {
      //   errorMail = "行動電話格式不正確！";
    } else {
      errorMail = null;
    }
  }

  void showErrorPassword() {
    if (password.text.isEmpty || password.text.trim() == "") {
      errorPassword = "不可空白！";
      // 假定
    } else if (password.text.length < 6) {
      errorPassword = "密碼錯誤！";
    } else {
      errorPassword = null;
    }
  }

  // 行動電話輸入框
  Padding loginMail(TextEditingController textController, String label,
      String hint, String? error) {
    return Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
        child: TextField(
          controller: textController,
          style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.06),
          decoration: InputDecoration(
              labelText: label,
              hintText: hint,
              errorText: error,
              errorStyle: TextStyle(fontSize: 14),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)))),
        ));
  }

  Padding loginPassword(
      TextEditingController textController, String label, String? error) {
    return Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
        child: TextField(
          controller: textController,
          style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.06),
          decoration: InputDecoration(
              labelText: label,
              errorText: error,
              errorStyle: TextStyle(fontSize: 14),
              suffixIcon: showPasswordIconButton(),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)))),
          // 是否顯示密碼
          obscureText: isPassword,
          obscuringCharacter: "*",
        ));
  }

  // 顯示密碼
  IconButton showPasswordIconButton() {
    return IconButton(
        onPressed: () {
          setState(() {
            if (isPassword) {
              // 顯示密碼
              isPassword = false;
            } else {
              isPassword = true;
            }
          });
        },
        icon: Icon(Icons.visibility));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
              child: Column(children: [
        Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.2),
            loginMail(mail, "電子信箱", "例：XXX@gmail.com", errorMail),
            loginPassword(password, "密碼", errorPassword),
          ],
        ),
        SizedBox(height: 10),
        ElevatedButton(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.green)),
            onPressed: () {
              FocusScopeNode focus = FocusScope.of(context);
              // 把TextField的focus移掉
              if (!focus.hasPrimaryFocus) {
                focus.unfocus();
              }
              setState(() {
                // 傳遞錯誤訊息
                showErrorMail();
                showErrorPassword();
              });
              if (errorMail == null && errorPassword == null) {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Change()));
              }
            },
            child: Text("登入", style: TextStyle(fontSize: size.width * 0.06))),
      ]))),
    );
  }
}
