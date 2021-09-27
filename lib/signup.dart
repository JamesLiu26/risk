import 'package:flutter/material.dart';
import './personal_questionnaire.dart';
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
  // TextField的控制項&錯誤訊息
  final mail = TextEditingController();
  final name = TextEditingController();
  final password = TextEditingController();
  bool isPassword = true;
  String? errorName;
  String? errorMail;
  String? errorPassword;

  /*
    判斷TextField裡的文字，顯示錯誤訊息
   */
  void showErrorName() {
    if (name.text.isEmpty || name.text.trim() == "") {
      errorName = "不可空白！";
    } else {
      errorName = null;
    }
  }

  void showErrorMail() {
    if (mail.text.isEmpty || mail.text.trim() == "") {
      errorMail = "不可空白！";
      //  else if (!mail.text.contains(RegExp("\^09[0-9]{8}\$"), 0)) {
      //   errorMail = "行動電話格式不正確！";
    } else {
      errorMail = null;
    }
  }

  void showErrorPassword() {
    if (password.text.isEmpty || password.text.trim() == "") {
      errorPassword = "不可空白！";
    } else if (password.text.length < 6) {
      errorPassword = "密碼不可小於6個字！";
    } else {
      errorPassword = null;
    }
  }

  // 姓名&行動電話輸入框
  /*
    textController TextField控制項
    label TextField左上文字
    hint 點擊時顯示的文字
    error 錯誤訊息
  */
  Padding signUpNameAndMail(TextEditingController textController, String label,
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

  Padding signUpPassword(TextEditingController textController, String label,
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
              suffixIcon: showPasswordIconButton(),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)))),
          /*
            obscureText:預設false
            true為顯示obscuringCharacter的符號
           */
          obscureText: isPassword,
          obscuringCharacter: "*",
        ));
  }

  IconButton showPasswordIconButton() {
    return IconButton(
        onPressed: () {
          setState(() {
            if (isPassword) {
              // 顯示使用者打的密碼
              isPassword = false;
            } else {
              // 顯示 * 字號
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
            "註冊",
            IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.blue[800]),
              onPressed: () {
                Navigator.pop(context);
              },
            )),
        body: SingleChildScrollView(
            child: Center(
                child: Column(children: [
          Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.12),
              signUpNameAndMail(name, "姓名", "請輸入本名", errorName),
              signUpNameAndMail(mail, "電子信箱", "例：XXX@gmail.com", errorMail),
              signUpPassword(password, "密碼", "請至少輸入6個字元", errorPassword)
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
                  // 執行錯誤訊息function
                  showErrorName();
                  showErrorMail();
                  showErrorPassword();
                });
                // 若無任何錯誤訊息，導向登入page
                if (errorName == null &&
                    errorMail == null &&
                    errorPassword == null) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => PerQuest()));
                }
              },
              child: Text("註冊", style: TextStyle(fontSize: size.width * 0.06))),
        ]))));
  }
}
