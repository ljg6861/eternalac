import 'package:firebase_auth/firebase_auth.dart';

enum UserType { a, c }

class EternalUser {
  final User user;
  final UserType userType;

  EternalUser._(this.user, this.userType);

  factory EternalUser(User user, String userType) {
    return EternalUser._(
        user, userType == UserType.a.toString() ? UserType.a : UserType.c);
  }
}
