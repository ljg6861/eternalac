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
                          child: Container(decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.grey,
                              ),
                              borderRadius: const BorderRadius.all( Radius.circular(20))
                          ),
                            child: Container(
                              margin: const EdgeInsets.only(
                                left:45,
                                right:45,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    height: 20.0,
                                    width: 20.0,
                                    decoration: const BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage('https://1000logos.net/wp-content/uploads/2016/11/New-Google-Logo.jpg'),
                                            fit: BoxFit.fill
                                        ),
                                        shape: BoxShape.circle
                                    ),
                                  ),
                                  const Text('Log in with Google',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        color: Colors.black87,
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
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
