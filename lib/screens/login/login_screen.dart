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
          'Eternal A&C',
          style: TextStyle(fontSize: 34),
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
                                  builder: (context) => SignupScreen(
                                        user: result,
                                      )));
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.grey,
                                ),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(20))),
                            child: Container(
                              margin: const EdgeInsets.only(
                                left: 45,
                                right: 45,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    height: 20.0,
                                    width: 20.0,
                                    decoration: const BoxDecoration(shape: BoxShape.circle),
                                        child:Image.asset(
                                            'assets/New-Google-Logo.jpg',
                                            fit: BoxFit.fill),
                                        ),
                                  const Text(
                                    'Log in with Google',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        color: Colors.black87,
                                        fontSize: 26),
                                  ),
                                ],
                              ),
                            ),
                          )),
                    ],
                  );
                } else {
                  Future.delayed(Duration(milliseconds: 500), () {
                    Navigator.of(context).push(MaterialPageRoute(
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
