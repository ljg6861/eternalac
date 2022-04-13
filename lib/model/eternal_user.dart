import 'package:firebase_auth/firebase_auth.dart';

enum UserType { anika, clarice }

class EternalUser {
  final User user;
  final UserType userType;

  EternalUser(this.user, this.userType);
}
