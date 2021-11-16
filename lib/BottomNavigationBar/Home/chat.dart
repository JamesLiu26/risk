import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;
import '/appBar.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   return runApp(MaterialApp(
//     home: Chatscreen(),
//     debugShowCheckedModeBanner: false,
//   ));
// }

class Chatscreen extends StatefulWidget {
  @override
  _ChatscreenState createState() => _ChatscreenState();
}

FirebaseFirestore storeMessage = FirebaseFirestore.instance;
FirebaseAuth _auth = FirebaseAuth.instance;

class _ChatscreenState extends State<Chatscreen> {
  TextEditingController msg = TextEditingController();
  IconButton sendButton() {
    return IconButton(
        onPressed: () {
          FocusScopeNode focus = FocusScope.of(context);
          // 把TextField的focus移掉
          if (!focus.hasPrimaryFocus) {
            focus.unfocus();
          }
          if (msg.text.isNotEmpty) {
            setState(() {});
            storeMessage
                .collection("Messages")
                .doc("+886906765979")
                .collection(_auth.currentUser!.phoneNumber!)
                .doc(DateFormat("yyyy-MM-dd HH:mm").format(DateTime.now()))
                .set({
              "message": msg.text.trim(),
              "user": _auth.currentUser!.phoneNumber,
            });
            msg.clear();
          }
        },
        icon: Icon(
          Icons.send,
          color: Colors.teal,
        ));
  }

  Column messageField() {
    return Column(children: [
      Container(
          color: Colors.blue,
          height: MediaQuery.of(context).size.height * 0.1,
          child: Row(
            children: [
              IconButton(
                  onPressed: () {}, icon: Icon(Icons.add_a_photo, size: 30)),
              IconButton(
                  onPressed: () {}, icon: Icon(Icons.photo_library, size: 30)),
              Expanded(
                child: TextField(
                  controller: msg,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 10),
                      hintText: "輸入訊息...",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
              sendButton()
            ],
          ))
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(
            _auth.currentUser!.phoneNumber!,
            IconButton(
                onPressed: () {
                  FocusScopeNode focus = FocusScope.of(context);
                  // 把TextField的focus移掉
                  if (!focus.hasPrimaryFocus) {
                    focus.unfocus();
                  }
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios, color: Colors.blue[800]))),
        body: SingleChildScrollView(
            child: Column(children: [
          SizedBox(
              height: MediaQuery.of(context).size.height * 0.83,
              child: ShowMessages()),
          Positioned(child: messageField()),
        ])));
  }
}

class ShowMessages extends StatefulWidget {
  @override
  _ShowMessagesState createState() => _ShowMessagesState();
}

class _ShowMessagesState extends State<ShowMessages> {
  Text chatStyle(String text) {
    double fontSize = MediaQuery.of(context).size.width * 0.052;
    return Text(text, style: TextStyle(fontSize: fontSize));
  }

  Text timeStyle(String text) {
    double fontSize = MediaQuery.of(context).size.width * 0.04;
    return Text(text, style: TextStyle(fontSize: fontSize));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection("Messages")
            .doc("+886906765979")
            .collection(_auth.currentUser!.phoneNumber!)
            .get(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            print(snapshot.error);
          }
          if (snapshot.connectionState == ConnectionState.done) {
            var chat = snapshot.data!.docs;

            return ListView.builder(
                itemCount: chat.length,
                physics: ScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  var doc = chat[index];
                  return ListTile(
                      title: Row(
                    textDirection: _auth.currentUser!.phoneNumber == doc["user"]
                        ? ui.TextDirection.ltr
                        : ui.TextDirection.rtl,
                    children: [
                      Spacer(flex: 1),
                      timeStyle("\n" + "  " + doc.id.split(" ")[1] + "  "),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                            color: _auth.currentUser!.phoneNumber == doc["user"]
                                ? Colors.blue.withOpacity(0.2)
                                : Colors.green.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10)),
                        child: chatStyle(doc['message'].toString()),
                      ),
                    ],
                  ));
                });
          } else {
            return Row();
          }
        });
  }
}
