import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

// inappwebview
class Appointment extends StatefulWidget {
  @override
  _AppointmentState createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> {
  late InAppWebViewController webViewController;
  double progressValue = 0;
  // 把id為footer__main的div移掉
  String footerMain = "var footerMain=document.getElementById('footer__main');";
  String footerMainRemove =
      "if (footerMain!=null) footerMain.style.display='none';";
  //
  // 新陳代謝科掛號網址
  String initialURL = "https://www.femh.org.tw/webregs/RegSec1?ID=0203";
  //
  // 把起始頁'初診'(span)的margin移掉，避免'複診'兩個字掉到下面去
  String spanMargin =
      "var spanMargin=document.getElementById('MainContent_labms1');";
  String spanMarginRemove = "if (spanMargin!=null) spanMargin.style.margin=0;";

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
                  child: InAppWebView(
                      initialUrlRequest: URLRequest(url: Uri.parse(initialURL)),
                      onWebViewCreated: (controller) {
                        // 獲取WebViewController實例(初始化)
                        webViewController = controller;
                      },
                      onProgressChanged: (_, progress) {
                        setState(() {
                          // 進度條的範圍是0.0~1.0，所以除以100
                          progressValue = progress / 100;
                        });
                        webViewController.evaluateJavascript(
                            source: footerMain + footerMainRemove);
                        webViewController.evaluateJavascript(
                            source: spanMargin + spanMarginRemove);
                      })),
            ],
          ),
        ));
  }
}
