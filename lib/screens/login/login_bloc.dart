import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc {
  Stream<Object> userIsLoggedIn;

  LoginBloc._({required this.userIsLoggedIn});

  factory LoginBloc() {
    var userIsLoggedInController = BehaviorSubject<Object>();

    var user = FirebaseAuth.instance.currentUser;
    userIsLoggedInController.add(user ?? false);

    return LoginBloc._(userIsLoggedIn: userIsLoggedInController);
  }
}
