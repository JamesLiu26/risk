import 'package:flutter/material.dart';
import './main.dart';
import './login.dart';
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
  bool isPassword = true;
  String? errorName;
  String? errorPhone;
  String? errorPassword;

  void showErrorName(String nameText) {
    if (nameText.isEmpty || nameText.trim() == "") {
      errorName = "不可空白！";
    } else {
      errorName = null;
    }
  }

  void showErrorPhone(String phoneText) {
    if (phoneText.isEmpty || phoneText.trim() == "") {
      errorPhone = "不可空白！";
    } else if (!phoneText.contains(RegExp("\^09[0-9]{8}\$"), 0)) {
      errorPhone = "行動電話格式不正確！";
    } else {
      errorPhone = null;
    }
  }

  // 姓名&行動電話輸入框
  Padding signUpNameAndPhone(TextEditingController textController, String label,
      String? hint, String? error, Function(String text) showError) {
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
          onChanged: (String str) {
            setState(() {
              showError(str);
            });
          },
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

  void showErrorPassword(String passwordText) {
    if (passwordText.isEmpty || passwordText.trim() == "") {
      errorPassword = "不可空白！";
    } else if (passwordText.length < 6) {
      errorPassword = "密碼不可小於6個字！";
    } else {
      errorPassword = null;
    }
  }

  Padding signUpPassword(TextEditingController textController, String label,
      String? error, Function(String text) showError) {
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
          onChanged: (String str) {
            setState(() {
              showError(str);
            });
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(
            "註冊",
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
                  SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                  signUpNameAndPhone(
                      name, "姓名", "例：XXX", errorName, showErrorName),
                  signUpNameAndPhone(phone, "行動電話", "例：09XXXXXXXX", errorPhone,
                      showErrorPhone),
                  signUpPassword(
                      password, "密碼", errorPassword, showErrorPassword)
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.green)),
                  onPressed: () {
                    setState(() {
                      showErrorName(name.text);
                      showErrorPhone(phone.text);
                      showErrorPassword(password.text);
                    });
                    if (errorName == null &&
                        errorPhone == null &&
                        errorPassword == null) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Login()));
                    }
                  },
                  child: Text("註冊",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.06))),
            ]))));
  }
}
