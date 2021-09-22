import 'package:flutter/material.dart';
import 'package:risk/appBar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Appointment extends StatefulWidget {
  @override
  _AppointmentState createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> {
  late WebViewController webViewController;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        // 控制手機back按鈕
        onWillPop: () async {
          if (await webViewController.canGoBack()) {
            webViewController.goBack();
            // 留在預約看診
            return false;
          }
          // 跳到首頁
          return true;
        },
        child: Scaffold(
          appBar: appBar(
              "預約看診",
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back_ios, color: Colors.blue[800]))),
          body: WebView(
              initialUrl: "https://hos.femh.org.tw/newfemh/mobile/wregs.aspx",
              // "https://www.aeust.edu.tw",
              // "https://www.facebook.com",
              // "https://hos.femh.org.tw/newfemh/mobile/wregs.aspx,"
              onWebViewCreated: (controller) {
                // 獲取WebViewController實例(初始化)
                webViewController = controller;
              },
              javascriptMode: JavascriptMode.unrestricted),
        ));
  }
}
