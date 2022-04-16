import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eternalac/model/eternal_user.dart';
import 'package:eternalac/screens/received_message/received_message_screen.dart';
import 'package:eternalac/screens/send_message/send_message_screen.dart';
import 'package:eternalac/widgets/main_button.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:images_picker/images_picker.dart';

class HomeScreen extends StatefulWidget {
  final EternalUser user;

  const HomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future showModal(BuildContext context) async {
    List<Media>? mediaData;
    await showModalBottomSheet(
        context: context,
        builder: (context) {
          return Theme(
            data: ThemeData(
                primarySwatch: widget.user.userType == UserType.a
                    ? Colors.red
                    : Colors.blue),
            child: Container(
              height: 200,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: const Radius.circular(40.0),
                  topLeft: const Radius.circular(40.0),
                ),
              ),
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Column(
                    children: [
                      MainButton(
                          onPressed: () async {
                            var media = await takePicture();
                            mediaData = media;
                            if (mediaData != null) {
                              Navigator.of(context).pop();
                              uploadMedia(mediaData!.first);
                            }
                          },
                          text: 'Take Picture'),
                      MainButton(
                          onPressed: () async {
                            var media = await takeVideo();
                            mediaData = media;
                            if (mediaData != null) {
                              Navigator.of(context).pop();
                              uploadMedia(mediaData!.first);
                            }
                          },
                          text: 'Take Video'),
                      MainButton(
                          onPressed: () async {
                            var media = await chooseFromGallery();
                            mediaData = media;
                            if (mediaData != null) {
                              Navigator.of(context).pop();
                              uploadMedia(mediaData!.first);
                            }
                          },
                          text: 'Choose From Gallery'),
                    ],
                  )),
            ),
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      var snapshot =
          await FirebaseFirestore.instance.collection('messages').get();
      if (snapshot.docs.isNotEmpty) {
        for (var snap in snapshot.docs) {
          if (snap.data()['userType'] != widget.user.userType.toString()) {
            Navigator.of(context)
                .push(MaterialPageRoute(
                    builder: (context) => ReceivedMessageScreen(
                        docId: snap.id,
                        message: snap.data(),
                        user: widget.user),
                    fullscreenDialog: true))
                .then((value) => FirebaseFirestore.instance
                    .collection('messages')
                    .doc(snap.id)
                    .delete());
          }
        }
      }
    });
    FirebaseFirestore.instance
        .collection('messages')
        .snapshots()
        .listen((event) {
      if (event.docs.first.data()['from'] != widget.user.user.uid) {
        Navigator.of(context)
            .push(MaterialPageRoute(
                builder: (context) => ReceivedMessageScreen(
                      message: event.docs.first.data(),
                      user: widget.user,
                      docId: event.docs.first.id,
                    ),
                fullscreenDialog: true))
            .then((value) => FirebaseFirestore.instance
                .collection('messages')
                .doc(event.docs.last.id)
                .delete());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
          primarySwatch:
              widget.user.userType == UserType.a ? Colors.red : Colors.blue),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(widget.user.userType == UserType.a
              ? 'Welcome, Anika'
              : 'Welcome, Chan'),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: Text(
                    '❤',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                MainButton(
                  onPressed: () {
                    showModal(context);
                  },
                  text: 'Send Image',
                ),
                SizedBox(
                  height: 50,
                ),
                MainButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SendMessageScreen(
                              user: widget.user,
                            ),
                        fullscreenDialog: true));
                  },
                  text: 'Send Message',
                ),
                SizedBox(
                  height: 50,
                ),
                Container(
                  child: Text(
                    '❤',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ]),
        ),
      ),
    );
  }

  Future<List<Media>?> takePicture() async {
    return ImagesPicker.openCamera(pickType: PickType.image);
  }

  Future<List<Media>?> takeVideo() {
    return ImagesPicker.openCamera(pickType: PickType.video);
  }

  Future<List<Media>?> chooseFromGallery() {
    return ImagesPicker.pick(pickType: PickType.all);
  }

  void uploadMedia(Media media) async {
    var task = await FirebaseStorage.instance
        .ref()
        .child(media.path)
        .putFile(File(media.path));
    var downloadUrl = await task.ref.getDownloadURL();
    await FirebaseFirestore.instance.collection('messages').add({
      'media': downloadUrl,
      'from': widget.user.user.uid,
      'fromType': widget.user.userType.toString()
    });
  }
}
