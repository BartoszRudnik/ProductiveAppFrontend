import 'package:flutter/material.dart';

class User with ChangeNotifier {
  String firstName;
  String lastName;
  String email;
  String userType;
  NetworkImage userImage;
  String photoUrl;
  bool removed = false;

  User({
    @required this.email,
    @required this.userType,
    this.firstName,
    this.lastName,
    this.photoUrl,
  });
}
