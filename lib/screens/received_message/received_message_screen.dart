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

    if (widget.message['media'] != null) {
      controller = VideoPlayerController.network(widget.message['media'])
        ..initialize()
            .then((value) => setState(() {}))
            .onError((error, stackTrace) => null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
          primarySwatch:
              widget.user.userType == UserType.a ? Colors.red : Colors.blue),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.user.userType == UserType.a
              ? 'Chan Sent You Something...'
              : 'Anika Sent You Something...'),
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
                        Text(
                          widget.user.userType == UserType.a
                              ? 'Chan Wanted To Tell You:'
                              : 'Anika Wanted To Tell You:',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Text(
                          widget.message['content'],
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        )
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
      ),
    );
  }
}
