import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:io';

class Appointment extends StatefulWidget {
  @override
  _AppointmentState createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> {
  late WebViewController webViewController;
  double progressValue = 0;
  String line1 = "var d=document.getElementsByTagName('div');";
  String line2 = "if (d[d.length-1]!=null) d[d.length-1].style.display='none';";

  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  AppBar backAndRefresh() {
    return AppBar(
      title: Text("預約看診", style: TextStyle(color: Colors.black)),
      backgroundColor: Color.fromARGB(255, 225, 230, 255),
      // back
      leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.blue[800]),
          onPressed: () {
            Navigator.pop(context);
          }),
      // refresh
      actions: [
        IconButton(
            icon: Icon(Icons.loop, color: Colors.blue[800], size: 30),
            onPressed: () {
              webViewController.reload();
            })
      ],
    );
  }

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
          appBar: backAndRefresh(),
          body: Column(
            children: [
              progressValue != 1
                  // 還在載入時，顯示進度條
                  ? LinearProgressIndicator(
                      value: progressValue, backgroundColor: Colors.white)
                  // 跑完進度條自動消失
                  : Row(),
              Expanded(
                  child: WebView(
                      javascriptMode: JavascriptMode.unrestricted,
                      initialUrl:
                          "https://hos.femh.org.tw/newfemh/mobile/wregs.aspx",
                      onWebViewCreated: (controller) {
                        // 獲取WebViewController實例(初始化)
                        webViewController = controller;
                      },
                      onProgress: (progress) {
                        setState(() {
                          // 進度條的範圍是0.0~1.0，所以除以100
                          progressValue = progress / 100;
                        });
                        webViewController.evaluateJavascript(line1 + line2);
                      })),
            ],
          ),
        ));
  }
}
