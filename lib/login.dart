import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
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

FirebaseAuth _auth = FirebaseAuth.instance;
String _verifyId = "";
CollectionReference _collection = FirebaseFirestore.instance.collection("user");

class _LoginState extends State<Login> {
  verifyPhone(String phNumber) async {
    await _auth.verifyPhoneNumber(
        phoneNumber: phNumber,
        verificationCompleted: (_) async {
          print("Successful");
        },
        verificationFailed: (FirebaseAuthException e) {
          print("====" + e.message.toString() + "====");
        },
        codeSent: (String id, int? token) async {
          print("OTP is sent!");
          _verifyId = id;
        },
        codeAutoRetrievalTimeout: (String id) {
          print("Resend");
          _verifyId = id;
        },
        timeout: Duration(seconds: 120));
  }

  toOTP() async {
    if (phone != "") {
      _collection.doc(phone).get().onError((error, stackTrace) {
        throw "========${error.toString()}=============";
      }).then((docSnapShot) {
        if (docSnapShot.exists) {
          Map<String, dynamic> data =
              docSnapShot.data()! as Map<String, dynamic>;
          if (data["password"] == password.text) {
            verifyPhone(phone);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => LoginOTP(phone)));
          } else {
            errorPassword = "密碼錯誤！";
          }
        } else {
          errorPhone = "此電話號碼未註冊過！";
        }
      });
    } else {
      errorPhone = "不可空白！";
    }
  }

  //
  String phone = "";
  final password = TextEditingController();
  bool isPassword = true;
  String? errorPhone;
  String? errorPassword;

  // 行動電話輸入框
  Padding loginPhone() {
    double fontSize = MediaQuery.of(context).size.width * 0.06;
    TextStyle style = TextStyle(fontSize: fontSize);
    return Padding(
        padding: EdgeInsets.all(16),
        child: InternationalPhoneNumberInput(
            selectorConfig: SelectorConfig(
                showFlags: false, setSelectorButtonAsPrefixIcon: true),
            countries: ["TW"],
            keyboardType: TextInputType.phone,
            selectorTextStyle: style,
            textStyle: style,
            inputDecoration: InputDecoration(
                labelText: "行動電話",
                floatingLabelBehavior: FloatingLabelBehavior.never,
                errorText: errorPhone,
                errorStyle: TextStyle(fontSize: 14),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)))),
            onInputChanged: (phNum) {
              phone = phNum.toString();
            }));
  }

  Padding loginPassword() {
    return Padding(
        padding: EdgeInsets.all(16),
        child: TextField(
          controller: password,
          style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.06),
          decoration: InputDecoration(
              labelText: "密碼",
              errorText: errorPassword,
              errorStyle: TextStyle(fontSize: 14),
              floatingLabelBehavior: FloatingLabelBehavior.never,
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
            loginPhone(),
            loginPassword(),
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
                toOTP();
              });
            },
            child: Text("登入", style: TextStyle(fontSize: size.width * 0.06))),
      ]))),
    );
  }
}

class LoginOTP extends StatefulWidget {
  final String phone;

  LoginOTP(this.phone);
  @override
  _LoginOTPOTPState createState() => _LoginOTPOTPState();
}

class _LoginOTPOTPState extends State<LoginOTP> {
  final otp = TextEditingController();
  Padding enterOTP() {
    return Padding(
        padding: EdgeInsets.all(16),
        child: TextField(
          controller: otp,
          keyboardType: TextInputType.number,
          style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.06),
          maxLength: 6,
          decoration: InputDecoration(
              labelText: "請輸入驗證碼",
              floatingLabelBehavior: FloatingLabelBehavior.never,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)))),
        ));
  }

  ElevatedButton otpButton() {
    double fontSize = MediaQuery.of(context).size.width * 0.06;

    return ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.green)),
        onPressed: () async {
          FocusScopeNode focus = FocusScope.of(context);
          // 把TextField的focus移掉
          if (!focus.hasPrimaryFocus) {
            focus.unfocus();
          }
          //電話號碼登入
          PhoneAuthCredential credential = PhoneAuthProvider.credential(
              verificationId: _verifyId, smsCode: otp.text);
          await _auth.signInWithCredential(credential);

          if (_auth.currentUser != null) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Change()),
                (Route route) => false);
          }
        },
        child: Text("驗證", style: TextStyle(fontSize: fontSize)));
  }

  @override
  void initState() {
    super.initState();
    _auth.setLanguageCode("zh_tw");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(
            "電話號碼驗證",
            IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.blue[800]),
              onPressed: () {
                Navigator.pop(context);
              },
            )),
        body: SingleChildScrollView(
            child: Center(
                child: Column(children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.12),
          enterOTP(),
          SizedBox(height: 20),
          otpButton()
        ]))));
  }
}
