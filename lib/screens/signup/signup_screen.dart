import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eternalac/model/eternal_user.dart';
import 'package:eternalac/screens/home/home_screen.dart';
import 'package:eternalac/utils/constants.dart';
import 'package:eternalac/widgets/main_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  final User user;

  const SignupScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool isLoading = true;

  @override
  void initState() {
    doPreProcessing();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('ETERNAL A&Cā¤šš'),
      ),
      body: isLoading == false
          ? Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Thank you for signing in!\nWho are you?',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  MainButton(
                      onPressed: () {
                        createUser(UserType.a);
                      },
                      text: 'Anika'),
                  MainButton(
                      onPressed: () {
                        createUser(UserType.c);
                      },
                      text: 'Chan'),
                ],
              ),
            )
          : Column(
              children: const [
                Expanded(
                    child: Center(
                  child: CircularProgressIndicator(),
                )),
              ],
            ),
    );
  }

  void createUser(UserType type) async {
    setState(() {
      isLoading = true;
    });
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user.uid)
        .set({'id': widget.user.uid, userType: type.toString()}).onError(
            (error, stackTrace) {
      setState(() {
        isLoading = false;
        return;
      });
    });
    var token = await FirebaseMessaging.instance.getToken();
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user.uid)
        .update({'token': token});
    setState(() {
      isLoading = false;
    });
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            HomeScreen(user: EternalUser(widget.user, type.toString()))));
  }

  void doPreProcessing() async {
    var userDataSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user.uid)
        .get();
    if (userDataSnapshot.exists) {
      var token = await FirebaseMessaging.instance.getToken();
      if (userDataSnapshot.data()!['token'] != token) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(widget.user.uid)
            .update({'token': token});
      }
      var user = EternalUser(widget.user, userDataSnapshot.data()![userType]);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen(user: user)));
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }
}
