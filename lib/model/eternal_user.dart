import 'package:firebase_auth/firebase_auth.dart';

enum UserType { a, c }

class EternalUser {
  final User user;
  final UserType userType;

  EternalUser(this.user, this.userType);
}
