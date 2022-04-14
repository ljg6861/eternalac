import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eternalac/model/eternal_user.dart';
import 'package:eternalac/screens/home/home_screen.dart';
import 'package:eternalac/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
        title: const Text('Eternal A&C'),
      ),
      body: isLoading == false
          ? Column(
              children: [
                const Text(
                  'Thank you for signing in\nWho are you?',
                  textAlign: TextAlign.center,
                ),
                TextButton(
                    onPressed: () {
                      createUser(UserType.a);
                    },
                    child: const Text('A')),
                TextButton(
                    onPressed: () {
                      createUser(UserType.c);
                    },
                    child: const Text('C')),
              ],
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
