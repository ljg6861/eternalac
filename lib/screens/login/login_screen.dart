import 'package:eternalac/screens/login/login_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
                          onPressed: () {},
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
