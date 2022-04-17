import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eternalac/model/eternal_user.dart';
import 'package:eternalac/widgets/main_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SendMessageScreen extends StatelessWidget {
  final EternalUser user;
  final TextEditingController controller = TextEditingController();

  SendMessageScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
          primarySwatch:
              user.userType == UserType.a ? Colors.red : Colors.blue),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Send Message'),
        ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Enter your message to ' +
                    (user.userType == UserType.a ? 'Chan' : 'Anika'),
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 25,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  maxLines: null,
                  controller: controller,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    hintText: 'Enter your message',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2.0),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                child: MainButton(
                  onPressed: () {
                    sendMessage();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Send!',
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        width: 25,
                      ),
                      Icon(
                        Icons.send,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void sendMessage() async {
    var users = await FirebaseFirestore.instance
        .collection('users')
        .where('userType',
            isEqualTo: (user.userType == UserType.a
                ? UserType.c.toString()
                : UserType.a.toString()))
        .get();
    var sendList = <String>[];
    for (var user in users.docs) {
      sendList.add(user.data()['id']);
    }
    await FirebaseFirestore.instance.collection('messages').add({
      'from': user.user.uid,
      'to': sendList,
      'content': controller.text,
      'fromType': user.userType.toString()
    });
    controller.clear();
  }
}
