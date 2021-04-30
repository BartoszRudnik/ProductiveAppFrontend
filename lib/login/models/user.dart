import 'package:flutter/foundation.dart';

class User with ChangeNotifier {
  String firstName;
  String lastName;
  String email;

  User({
    @required this.email,
    this.firstName,
    this.lastName,
  });
}
