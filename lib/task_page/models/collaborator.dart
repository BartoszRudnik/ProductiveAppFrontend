import 'package:flutter/material.dart';

class Collaborator {
  String email;
  bool isSelected;

  Collaborator({
    @required this.email,
    this.isSelected,
  });
}
