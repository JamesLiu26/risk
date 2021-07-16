import 'package:flutter/material.dart';
import './home.dart';
import './trace.dart';
import './notification.dart';

void main() {
  return runApp(MaterialApp(
    home: Change(),
    debugShowCheckedModeBanner: false,
  ));
}

class Change extends StatefulWidget {
  @override
  _ChangeState createState() => _ChangeState();
}

class _ChangeState extends State<Change> {
  int currentIndex = 0;
  List<Widget> page = [Home(), Trace(), Notify()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: page[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: ImageIcon(AssetImage("images/首頁.png")), label: "首頁"),
          BottomNavigationBarItem(
              icon: ImageIcon(AssetImage("images/病情追蹤.png")), label: "每日追蹤"),
          BottomNavigationBarItem(
              icon: ImageIcon(AssetImage("images/通知.png")), label: "通知")
        ],
        currentIndex: currentIndex,
        onTap: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}
