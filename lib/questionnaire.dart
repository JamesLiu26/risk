import 'package:flutter/material.dart';
import 'package:risk/appBar.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Question(),
  ));
}

class Question extends StatelessWidget {
  Text textStyle(
    String text,
    context, [
    Color color = Colors.black,
  ]) {
    return Text(text,
        style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.06, color: color));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(
            "問卷填寫",
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios, color: Colors.blue[800]),
            )),
        body: Column(children: [
          Spacer(flex: 3),
          textStyle("請注意：", context),
          textStyle("此問卷除了生活習慣等問題外", context),
          textStyle("也會牽涉到健檢相關數據", context),
          textStyle("建議您先透過儀器量測", context),
          textStyle("或是做完健檢再填寫此問卷", context),
          Spacer(flex: 3),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.red)),
              child: textStyle("返回", context, Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.green)),
              child: textStyle("繼續", context, Colors.white),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FirstPage()));
              },
            )
          ]),
          Spacer(flex: 3),
        ]));
  }
}

//first page
class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
          "問卷填寫",
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios, color: Colors.blue[800]),
          )),
    );
  }
}
