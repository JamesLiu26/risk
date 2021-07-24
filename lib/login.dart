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

  void showErrorPhone(String phoneText) {
    if (phoneText.isEmpty || phoneText.trim() == "") {
      errorPhone = "不可空白！";
    } else if (!phoneText.contains(
        RegExp("\^09[0-9]{8}\$", multiLine: true), 0)) {
      errorPhone = "行動電話格式不正確！";
    } else {
      errorPhone = null;
    }
  }

  // 行動電話輸入框
  Padding loginPhone(TextEditingController data, String labelText,
      String? hintText, String? errorText, Function(String) showError) {
    return Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
        child: TextField(
          controller: data,
          onSubmitted: (String value) {
            setState(() {
              showError(value);
            });
          },
          style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.03),
          decoration: InputDecoration(
              hintText: hintText,
              errorText: errorText,
              errorStyle: TextStyle(fontSize: 14),
              labelText: labelText,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)))),
          keyboardType: TextInputType.number,
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

  Padding loginPassword(TextEditingController data, String labelText,
      String? errorText, Function(String) showError) {
    return Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
        child: TextField(
          controller: data,
          onSubmitted: (String value) {
            setState(() {
              showError(value);
            });
          },
          style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.03),
          decoration: InputDecoration(
              errorText: errorText,
              errorStyle: TextStyle(fontSize: 14),
              suffixIcon: showPasswordIconButton(),
              labelText: labelText,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)))),
          obscureText: isPassword,
          obscuringCharacter: "*",
        ));
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
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
            Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.25),
                loginPhone(
                    phone, "行動電話", "例：09XXXXXXXX", errorPhone, showErrorPhone),
                //---------------------------------------------------------
                loginPassword(password, "密碼", errorPassword, showErrorPassword)
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.green)),
                onPressed: () {
                  if (errorPhone == null && errorPassword == null) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => PerQuest()));
                  } else {
                    setState(() {
                      showErrorPhone(phone.text);
                      showErrorPassword(password.text);
                    });
                  }
                },
                child: Text("登入",
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.03))),
          ]))),
    );
  }
}
