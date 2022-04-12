import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc {
  Stream<User?> userIsLoggedIn;

  LoginBloc._({required this.userIsLoggedIn});

  factory LoginBloc() {
    var userIsLoggedInController = BehaviorSubject<User?>();

    var user = FirebaseAuth.instance.currentUser;
    userIsLoggedInController.add(user);

    return LoginBloc._(userIsLoggedIn: userIsLoggedInController);
  }
}
