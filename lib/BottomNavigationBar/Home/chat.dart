import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
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

  Row messageField() {
    return Row(
      children: [
        Expanded(
            child: Padding(
          padding: EdgeInsets.only(left: 10),
          child: TextField(
            controller: msg,
            decoration: InputDecoration(
                hintText: "輸入訊息...",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10))),
          ),
        )),
        sendButton()
      ],
    );
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
          Container(
              height: MediaQuery.of(context).size.height * 0.75,
              child: ShowMessages()),
          messageField(),
        ])));
  }
}

class ShowMessages extends StatefulWidget {
  @override
  _ShowMessagesState createState() => _ShowMessagesState();
}

class _ShowMessagesState extends State<ShowMessages> {
  @override
  Widget build(BuildContext context) {
    Text chatStyle(String text) {
      double fontSize = MediaQuery.of(context).size.width * 0.052;
      return Text(text, style: TextStyle(fontSize: fontSize));
    }

    Text timeStyle(String text) {
      double fontSize = MediaQuery.of(context).size.width * 0.04;
      return Text(text, style: TextStyle(fontSize: fontSize));
    }

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
                      title: Column(
                          crossAxisAlignment:
                              _auth.currentUser!.phoneNumber == doc["user"]
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                          children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                              color:
                                  _auth.currentUser!.phoneNumber == doc["user"]
                                      ? Colors.blue.withOpacity(0.2)
                                      : Colors.green.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10)),
                          child: chatStyle(doc['message'].toString()),
                        ),
                        timeStyle(doc.id.split(" ")[1])
                      ]));
                });
          } else {
            return Row();
          }
        });
  }
}
