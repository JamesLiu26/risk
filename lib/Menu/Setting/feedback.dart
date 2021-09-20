import 'package:flutter/material.dart';
import '/appBar.dart';

class FeedBack extends StatefulWidget {
  @override
  _FeedBackState createState() => _FeedBackState();
}

class _FeedBackState extends State<FeedBack> {
  String? error;
  TextField feedbackField(TextEditingController controller) {
    return TextField(
      controller: controller,
      maxLines: 10,
      maxLength: 100,
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          hintText: "字數上限為100字",
          errorText: error,
          counterStyle: TextStyle(color: Colors.black, fontSize: 14)),
    );
  }

  Text headerText(double size) {
    return Text("對於此APP有想要建議或是需要修改的地方，您都可以在下方提出，這將有助於我們了解問題並改善服務：",
        style: TextStyle(fontSize: size));
  }

  final fbText = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: appBar(
            "意見回饋",
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios, color: Colors.blue[800]))),
        body: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: headerText(size.width * 0.05),
              ),
              Padding(
                  padding: EdgeInsets.all(20.0), child: feedbackField(fbText)),
              OutlinedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.green)),
                  onPressed: () {
                    setState(() {
                      FocusScopeNode focus = FocusScope.of(context);
                      // 把TextField的focus移掉
                      if (!focus.hasPrimaryFocus) {
                        focus.unfocus();
                      }
                      error = null;
                      if (fbText.text != "" && fbText.text.trim() != "") {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          duration: Duration(seconds: 2),
                          content: Text("已成功送出！"),
                        ));
                      } else {
                        error = "不可為空白！";
                      }
                    });
                  },
                  child: Text("送出",
                      style: TextStyle(
                          color: Colors.white, fontSize: size.width * 0.05)))
            ])));
  }
}
