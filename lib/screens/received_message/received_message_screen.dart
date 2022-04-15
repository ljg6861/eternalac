import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eternalac/model/eternal_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ReceivedMessageScreen extends StatefulWidget {
  final Map<String, dynamic> message;
  final String docId;
  final EternalUser user;

  const ReceivedMessageScreen(
      {Key? key,
      required this.message,
      required this.user,
      required this.docId})
      : super(key: key);

  @override
  State<ReceivedMessageScreen> createState() => _ReceivedMessageScreenState();
}

class _ReceivedMessageScreenState extends State<ReceivedMessageScreen> {
  late VideoPlayerController controller;

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('messages')
        .doc(widget.docId)
        .delete();
    if (widget.message['media'] != null) {
      controller = VideoPlayerController.network(widget.message['media'])
        ..initialize()
            .then((value) => setState(() {}))
            .onError((error, stackTrace) => null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.user.userType == UserType.a
            ? 'C Sent You Something...'
            : 'A Sent You Something...'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Container(
            child: Builder(
              builder: (context) {
                if (widget.message['content'] != null) {
                  //Text
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(widget.user.userType == UserType.a
                          ? 'C Wanted To Tell You:'
                          : 'A Wanted To Tell You:'),
                      SizedBox(
                        height: 15,
                      ),
                      Text(widget.message['content'])
                    ],
                  );
                } else {
                  return Image.network(widget.message['media'],
                      errorBuilder: (context, x, s) {
                    return Builder(builder: (context) {
                      if (controller.value.isInitialized) {
                        return AspectRatio(
                            aspectRatio: controller.value.aspectRatio,
                            child: VideoPlayer(controller));
                      } else {
                        return CircularProgressIndicator();
                      }
                    });
                  });
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
