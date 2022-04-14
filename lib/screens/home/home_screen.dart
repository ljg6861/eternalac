import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eternalac/model/eternal_user.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:images_picker/images_picker.dart';

class HomeScreen extends StatelessWidget {
  final EternalUser user;

  const HomeScreen({Key? key, required this.user}) : super(key: key);

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(user.userType == UserType.a ? 'Welcome A' : 'Welcome C'),
      ),
      body: Column(children: [
        TextButton(
          onPressed: () {
            showModal(context);
          },
          child: const Text('Send Image'),
        ),
        TextButton(
          onPressed: () {},
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
    await FirebaseFirestore.instance
        .collection('messages')
        .add({'media': downloadUrl, 'from': user.user.uid});
  }
}
