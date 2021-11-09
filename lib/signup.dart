import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import './personal_questionnaire.dart';
import './appBar.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

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

String _verifyId = "";
FirebaseAuth _auth = FirebaseAuth.instance;
DocumentReference? _doc;

class _SignUpState extends State<SignUp> {
  // TextField的控制項&錯誤訊息

  final name = TextEditingController();
  String phone = "";
  final password = TextEditingController();

  bool isPassword = true;
  String? errorName;
  String? errorPhone;
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

  void showErrorPhone() {
    if (phone.isEmpty || phone.trim() == "") {
      errorPhone = "不可空白！";
    } else if (!phone.contains(RegExp("\^\\+8869[0-9]{8}\$"), 0)) {
      errorPhone = "行動電話格式不正確！";
    } else {
      errorPhone = null;
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

  Padding signUpName() {
    return Padding(
        padding: EdgeInsets.all(16),
        child: TextField(
          controller: name,
          style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.06),
          decoration: InputDecoration(
              labelText: "姓名",
              hintText: "請輸入本名",
              errorText: errorName,
              errorStyle: TextStyle(fontSize: 14),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)))),
        ));
  }

  Padding signUpPhone() {
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
                hintText: "例：912345678",
                floatingLabelBehavior: FloatingLabelBehavior.never,
                errorText: errorPhone,
                errorStyle: TextStyle(fontSize: 14),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)))),
            onInputChanged: (phNum) {
              phone = phNum.toString();
            }));
  }

  Padding signUpPassword() {
    return Padding(
        padding: EdgeInsets.all(16),
        child: TextField(
          controller: password,
          style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.06),
          decoration: InputDecoration(
              labelText: "密碼",
              hintText: "至少6個字元",
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
              signUpName(),
              signUpPhone(),
              signUpPassword()
            ],
          ),
          SizedBox(height: 10),
          ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green)),
              onPressed: () {
                FocusScopeNode focus = FocusScope.of(context);
                // 把TextField的focus移掉
                if (!focus.hasPrimaryFocus) {
                  focus.unfocus();
                }
                setState(() {
                  // 執行錯誤訊息function
                  showErrorName();
                  showErrorPhone();
                  showErrorPassword();
                });
                // 若無任何錯誤訊息，導向輸入OTP頁面
                if (errorName == null &&
                    errorPhone == null &&
                    errorPassword == null) {
                  verifyPhone(phone);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              OTP(name.text, phone, password.text)));
                }
              },
              child: Text("註冊", style: TextStyle(fontSize: size.width * 0.06))),
        ]))));
  }
}

class OTP extends StatefulWidget {
  final String name;
  final String phone;
  final String password;

  OTP(this.name, this.phone, this.password);
  @override
  _OTPState createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  final otp = TextEditingController();

  // 新增使用者姓名&電話號碼
  Future<void> addDoc(String name, String password) async {
    _doc = FirebaseFirestore.instance.collection("user").doc(widget.phone);
    await _doc!.set({"name": name, "password": password});
  }

  Padding enterOTP() {
    return Padding(
        padding: EdgeInsets.all(16),
        child: TextField(
          controller: otp,
          keyboardType: TextInputType.number,
          style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.06),
          maxLength: 6,
          decoration: InputDecoration(
              labelText: "驗證碼",
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
            addDoc(widget.name, widget.password);
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => PerQuest()));
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
    double iconSize = MediaQuery.of(context).size.width * 0.3;
    double fontSize = MediaQuery.of(context).size.width * 0.06;
    return Scaffold(
        appBar: appBar(
            "",
            IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.blue[800]),
              onPressed: () {
                Navigator.pop(context);
              },
            )),
        body: SingleChildScrollView(
            child: Center(
                child: Column(children: [
          SizedBox(height: 20),
          Text("電話號碼驗證", style: TextStyle(fontSize: fontSize, height: 1.5)),
          SizedBox(height: 20),
          Icon(Icons.sms, size: iconSize, color: Colors.blue[800]),
          Text("稍後您將收到一組驗證碼\n請輸入至下方",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: fontSize, height: 1.5)),
          SizedBox(height: 20),
          enterOTP(),
          SizedBox(height: 20),
          otpButton()
        ]))));
  }
}
