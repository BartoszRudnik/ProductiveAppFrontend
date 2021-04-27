import 'package:flutter/material.dart';

class Collaborator {
  String email;
  String relationState;
  bool isSelected = false;

  Collaborator({
    @required this.email,
    @required this.relationState,
    this.isSelected,
  });
}
