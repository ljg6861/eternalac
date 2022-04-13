import 'package:eternalac/screens/login/login_bloc.dart';
import 'package:eternalac/screens/signup/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final bloc = LoginBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Eternal A&C',
          style: TextStyle(fontSize: 24),
        ),
      ),
      body: Center(
        child: StreamBuilder<Object>(
            stream: bloc.userIsLoggedIn,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data == false) {
                  return Column(
                    children: [
                      TextButton(
                          onPressed: () async {
                            var result = await signInWithGoogle();
                            if (result != null) {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => SignupScreen()));
                            }
                          },
                          child: Container(
                            child: const Text('Log in with Google'),
                          )),
                    ],
                  );
                } else {
                  ///TODO navigate user to home screen
                  return Container();
                }
              } else {
                return const CircularProgressIndicator();
              }
            }),
      ),
    );
  }
}

Future<User?> signInWithGoogle() async {
  var googleSignInAccount = await GoogleSignIn.standard().signIn();
  var googleSignInAuthentication = await googleSignInAccount?.authentication;
  if (googleSignInAccount == null) {
    return null;
  }
  AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleSignInAuthentication!.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );
  var signIn = await FirebaseAuth.instance.signInWithCredential(credential);
  return signIn.user;
}
