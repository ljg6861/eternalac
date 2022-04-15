import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eternalac/model/eternal_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SendMessageScreen extends StatelessWidget {
  final EternalUser user;
  final TextEditingController controller = TextEditingController();

  SendMessageScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Text('Enter your message to ' +
                (user.userType == UserType.a ? 'C' : 'A')),
            const SizedBox(
              height: 15,
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
              width: 100,
              child: TextButton(
                onPressed: () {
                  sendMessage();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('Send!'),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(Icons.send)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void sendMessage() async {
    await FirebaseFirestore.instance.collection('messages').add({
      'from': user.user.uid,
      'content': controller.text,
      'fromType': user.userType.toString()
    });
    controller.clear();
  }
}
