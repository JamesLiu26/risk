import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;
import '/appBar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
FirebaseStorage _storage = FirebaseStorage.instance;
String _phNum = _auth.currentUser!.phoneNumber!;
ScrollController _controller = ScrollController();

class _ChatscreenState extends State<Chatscreen> {
  @override
  initState() {
    super.initState();
    jumpTobuttom();
  }

  @override
  dispose() {
    super.dispose();
  }

  TextEditingController msg = TextEditingController();
  final ImagePicker picker = ImagePicker();
  XFile? chooseCamera;
  XFile? chooseImage;
  late String image;
  late String camera;
  String filename = "";
  String _url = "";

  void jumpTobuttom() async {
    await Future.delayed(Duration(milliseconds: 800), () {
      _controller.jumpTo(
        _controller.position.maxScrollExtent,
      );
    });
  }

  Future pickImageFromGallery() async {
    chooseImage = await picker.pickImage(source: ImageSource.gallery);
    if (chooseImage != null) {
      image = chooseImage!.path;
      print(chooseImage!.path);
      filename = chooseImage!.path.split('/').last;
      _storage.ref("$_phNum/$filename").putFile(File(image));
      Future.delayed(Duration(seconds: 2), () async {
        _url = await _storage.ref("$_phNum/$filename").getDownloadURL();
        print("********" + _url);
        storeMessage
            .collection("Messages")
            .doc("+886906765979")
            .collection(_phNum)
            .doc(DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()))
            .set({
          "message": _url,
          "user": _phNum,
        });
        setState(() {});
      });
    }
  }

  Future takeAPhoto() async {
    chooseCamera = await picker.pickImage(source: ImageSource.camera);
    if (chooseCamera != null) {
      print(chooseCamera!.path);
      camera = chooseCamera!.path;
      filename = chooseImage!.path.split('/').last;
      _storage.ref("$_phNum/$filename").putFile(File(camera));
      storeMessage
          .collection("Messages")
          .doc("+886906765979")
          .collection(_phNum)
          .doc(DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()))
          .set({
        "message": filename,
        "user": _phNum,
      });
      //  Image.file(camera, height: 100, width: 100);
    }
  }

  IconButton sendButton() {
    return IconButton(
        onPressed: () {
          FocusScopeNode focus = FocusScope.of(context);
          // 把TextField的focus移掉
          if (!focus.hasPrimaryFocus) {
            focus.unfocus();
          }
          if (msg.text.isNotEmpty) {
            storeMessage
                .collection("Messages")
                .doc("+886906765979")
                .collection(_phNum)
                .doc(DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()))
                .set({
              "message": msg.text.trim(),
              "user": _phNum,
            });
            jumpTobuttom();
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
          height: MediaQuery.of(context).size.height * 0.1,
          child: Row(
            children: [
              IconButton(
                  onPressed: () {
                    takeAPhoto();
                  },
                  icon: Icon(Icons.add_a_photo,
                      size: 30, color: Colors.blue[800])),
              IconButton(
                  onPressed: () {
                    pickImageFromGallery();
                  },
                  icon: Icon(Icons.photo_library,
                      size: 30, color: Colors.blue[800])),
              Expanded(
                child: TextField(
                  onTap: () {
                    print("123");
                    jumpTobuttom();
                  },
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
            _phNum,
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
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                  //controller: _controller,
                  child: ListBody(children: [
                SizedBox(
                    height: MediaQuery.of(context).size.height * 0.75,
                    child: ShowMessages()),
                Container(child: messageField()),
              ])),
            ),
          ],
        ));
  }
}

class ShowMessages extends StatefulWidget {
  @override
  _ShowMessagesState createState() => _ShowMessagesState();
}

class _ShowMessagesState extends State<ShowMessages> {
  String path = "";
  Text chatStyle(String text) {
    double fontSize = MediaQuery.of(context).size.width * 0.052;
    return Text(
      text,
      style: TextStyle(fontSize: fontSize),
    );
  }

  Text timeStyle(String text) {
    double fontSize = MediaQuery.of(context).size.width * 0.04;
    return Text(
      text,
      style: TextStyle(fontSize: fontSize),
    );
  }

  Future<String> showImage(String imageName) async {
    String imgFile = await _storage.ref("$_phNum/$imageName").getDownloadURL();
    // print("======" + imgFile);
    return imgFile;
  }

  String imageMessage(String imageName) {
    showImage(imageName).then((value) {
      path = value;
      // storeMessage
      //     .collection("Messages")
      //     .doc("+886906765979")
      //     .collection(_phNum)
      //     .doc(DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()))
      //     .set({"url":});
      print(path);
    });

    return path;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection("Messages")
            .doc("+886906765979")
            .collection(_phNum)
            .get(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            // print(snapshot.error);
          }
          if (snapshot.connectionState == ConnectionState.done) {
            var chat = snapshot.data!.docs;

            return ListView.builder(
                itemCount: chat.length,
                //shrinkWrap: true,
                controller: _controller,
                //physics: NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  var doc = chat[index];
                  return ListTile(
                      title: Row(
                    textDirection: _auth.currentUser!.phoneNumber == doc["user"]
                        ? ui.TextDirection.rtl
                        : ui.TextDirection.ltr,
                    children: [
                      //Spacer(flex: 1),

                      Flexible(
                          child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              decoration: BoxDecoration(
                                  color: _phNum == doc["user"]
                                      ? Colors.blue.withOpacity(0.2)
                                      : Colors.green.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10)),
                              child: doc['message'].toString().contains("http")
                                  ? Image.network(doc['message'].toString(),
                                      height: 100, width: 100)
                                  : chatStyle(doc['message'].toString()))),
                      timeStyle("\n" +
                          "  " +
                          DateFormat("HH:mm").format(DateTime.parse(doc.id)) +
                          "  "),
                    ],
                  ));
                });
          } else {
            return Row();
          }
        });
  }
}
