import 'package:flutter/material.dart';

class User with ChangeNotifier {
  String firstName;
  String lastName;
  String email;
  NetworkImage userImage;
  bool removed = false;

  User({
    @required this.email,
    this.firstName,
    this.lastName,
  });
}
