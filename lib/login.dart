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
  bool isPassword = true;
  String? errorPhone;
  String? errorPassword;

  void showErrorPhone() {
    if (phone.text.isEmpty || phone.text.trim() == "") {
      errorPhone = "不可空白！";
    } else if (!phone.text.contains(RegExp("\^09[0-9]{8}\$"), 0)) {
      errorPhone = "行動電話格式不正確！";
    } else {
      errorPhone = null;
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
  Padding loginPhone(TextEditingController textController, String label,
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
            SizedBox(height: MediaQuery.of(context).size.height * 0.25),
            loginPhone(phone, "行動電話", "例：0912345678", errorPhone),
            loginPassword(
              password,
              "密碼",
              errorPassword,
            ),
          ],
        ),
        SizedBox(height: 20),
        ElevatedButton(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.green)),
            onPressed: () {
              setState(() {
                // 傳遞錯誤訊息
                showErrorPhone();
                showErrorPassword();
              });
              if (errorPhone == null && errorPassword == null) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PerQuest()));
              }
            },
            child: Text("登入",
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.06))),
      ]))),
    );
  }
}
