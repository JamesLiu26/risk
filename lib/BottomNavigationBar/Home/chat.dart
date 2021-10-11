import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

FirebaseAuth _auth = FirebaseAuth.instance;

class _ChatscreenState extends State<Chatscreen> {
  TextEditingController msg = TextEditingController();
  final storeMessage = FirebaseFirestore.instance;
  IconButton sendButton() {
    return IconButton(
        onPressed: () {
          if (msg.text.isNotEmpty) {
            storeMessage.collection("Messages").doc().set({
              "messages": msg.text.trim(),
              "user": _auth.currentUser!.phoneNumber,
              "time": DateTime.now(),
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
          child: TextField(
            controller: msg,
            decoration: InputDecoration(hintText: "Enter Messages..."),
          ),
        ),
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
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios, color: Colors.blue[800]))),
        body: SingleChildScrollView(
            child: Column(children: [
          Container(
              height: MediaQuery.of(context).size.height * 0.8,
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
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection("Messages")
            .doc("eai5QZxG4fUkAvE5TR8Q")
            .get(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) {
            print(snapshot.error);
          }
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> chat =
                snapshot.data!.data() as Map<String, dynamic>;
            return ListView.builder(
                reverse: true,
                itemCount: chat.length,
                shrinkWrap: true,
                primary: true,
                physics: ScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  String key = chat.keys.elementAt(index);

                  return ListTile(
                      title: Column(
                          crossAxisAlignment:
                              _auth.currentUser!.phoneNumber == chat['user']
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                          children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          color: _auth.currentUser!.phoneNumber == chat['user']
                              ? Colors.blue.withOpacity(0.2)
                              : Colors.blue.withOpacity(0.1),
                          child: Text(chat[key].toString()),
                        )
                      ]));
                });
          } else {
            return Text("Error");
          }
        });
  }
}
