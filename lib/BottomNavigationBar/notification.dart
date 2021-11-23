import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../menu.dart';
import '../appBar.dart';

void main() {
  return runApp(MaterialApp(
    home: Notify(),
    title: "通知",
    debugShowCheckedModeBanner: false,
  ));
}

FirebaseAuth _auth = FirebaseAuth.instance;
String _phNum = _auth.currentUser!.phoneNumber!;
CollectionReference _collection =
    FirebaseFirestore.instance.collection("Notification");

class Notify extends StatefulWidget {
  @override
  _NotifyState createState() => _NotifyState();
}

class _NotifyState extends State<Notify> {
  Color color = Colors.red;
  IconData icon = Icons.mark_email_unread;

  @override
  Widget build(BuildContext context) {
    double titleSize = MediaQuery.of(context).size.width * 0.06;
    double subtitleSize = MediaQuery.of(context).size.width * 0.05;
    Text textStyle(String text, double fontSize,
        [FontWeight fontWeight = FontWeight.normal]) {
      return Text(text,
          style: TextStyle(
              fontSize: fontSize, color: Colors.black, fontWeight: fontWeight));
    }

    return Scaffold(
        // backgroundColor: Colors.grey,
        drawer: menu(context),
        appBar: appBar("通知", menuButton()),
        body: FutureBuilder(
            future: _collection.doc(_phNum).collection("news").get(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.done) {
                var data = snapshot.data!.docs;

                return data.length != 0
                    ? ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          QueryDocumentSnapshot doc = data[index];
                          String dateTime = DateFormat("yyyy年MM月dd日 HH點mm分")
                              .format(DateTime.parse(doc.id));
                          return Dismissible(
                              background: Container(color: Colors.red),
                              onDismissed: (_) {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                            title: Text("請問是否要刪除？"),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    setState(() {});
                                                  },
                                                  child: Text("取消",
                                                      style: TextStyle(
                                                          color: Colors.red))),
                                              TextButton(
                                                  onPressed: () {
                                                    print(doc.id);
                                                    setState(() {
                                                      _collection
                                                          .doc(_phNum)
                                                          .collection("news")
                                                          .doc(doc.id)
                                                          .delete();
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text("確定"))
                                            ]));
                              },
                              key: UniqueKey(),
                              child: Column(children: [
                                Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                    ),
                                    child: Column(children: [
                                      textStyle(dateTime, subtitleSize),
                                      ListTile(
                                          onTap: () {
                                            setState(() {
                                              print(index);
                                              _collection
                                                  .doc(_phNum)
                                                  .collection("news")
                                                  .doc(doc.id)
                                                  .update({"read": true});
                                            });
                                          },
                                          title: Row(
                                            children: [
                                              Icon(icon,
                                                  size: 50,
                                                  color: doc["read"]
                                                      ? Colors.grey
                                                      : Colors.blue),
                                              textStyle(doc["title"], titleSize,
                                                  FontWeight.bold),
                                            ],
                                          ),
                                          subtitle: textStyle(
                                              "  ${doc["body"]}",
                                              subtitleSize)),
                                    ])),
                                Divider(thickness: 2, color: Colors.grey)
                              ]));

                          // return
                        })
                    : Center(child: textStyle("目前尚無通知", titleSize));
              } else {
                return Row();
              }
            }));
  }
}
