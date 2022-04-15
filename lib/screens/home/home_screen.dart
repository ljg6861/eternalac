import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eternalac/model/eternal_user.dart';
import 'package:eternalac/screens/received_message/received_message_screen.dart';
import 'package:eternalac/screens/send_message/send_message_screen.dart';
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
          return Container(
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
                    TextButton(
                        onPressed: () async {
                          var media = await takePicture();
                          mediaData = media;
                          if (mediaData != null) {
                            Navigator.of(context).pop();
                            uploadMedia(mediaData!.first);
                          }
                        },
                        child: const Text('Take Picture')),
                    TextButton(
                        onPressed: () async {
                          var media = await takeVideo();
                          mediaData = media;
                          if (mediaData != null) {
                            Navigator.of(context).pop();
                            uploadMedia(mediaData!.first);
                          }
                        },
                        child: const Text('Take Video')),
                    TextButton(
                        onPressed: () async {
                          var media = await chooseFromGallery();
                          mediaData = media;
                          if (mediaData != null) {
                            Navigator.of(context).pop();
                            uploadMedia(mediaData!.first);
                          }
                        },
                        child: const Text('Choose From Gallery')),
                  ],
                )),
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
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ReceivedMessageScreen(
                    docId: snap.id, message: snap.data(), user: widget.user),
                fullscreenDialog: true));
          }
        }
      }
    });
    FirebaseFirestore.instance
        .collection('messages')
        .snapshots()
        .listen((event) {
      if (event.docs.first.data()['from'] != widget.user.user.uid) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ReceivedMessageScreen(
                  message: event.docs.first.data(),
                  user: widget.user,
                  docId: event.docs.first.id,
                ),
            fullscreenDialog: true));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
            widget.user.userType == UserType.a ? 'Welcome A' : 'Welcome C'),
      ),
      body: Column(children: [
        TextButton(
          onPressed: () {
            showModal(context);
          },
          child: const Text('Send Image'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => SendMessageScreen(
                      user: widget.user,
                    ),
                fullscreenDialog: true));
          },
          child: const Text('Send Message'),
        ),
      ]),
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
