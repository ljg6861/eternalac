import 'package:eternalac/screens/login/login_bloc.dart';
import 'package:eternalac/screens/signup/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../widgets/main_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late LoginBloc bloc;

  @override
  void didChangeDependencies() {
    bloc = LoginBloc(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'ETERNAL A&C❤😍😘',
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
                    mainAxisAlignment: MainAxisAlignment.center,
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
                        onPressed: () async {
                          var result = await signInWithGoogle();
                          if (result != null) {
                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                                    builder: (context) => SignupScreen(
                                          user: result,
                                        )));
                          }
                        },
                        text: 'Log in with Google',
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
                    ],
                  );
                } else {
                  Future.delayed(Duration(milliseconds: 500), () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) =>
                            SignupScreen(user: snapshot.data as User)));
                  });
                  return CircularProgressIndicator();
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
