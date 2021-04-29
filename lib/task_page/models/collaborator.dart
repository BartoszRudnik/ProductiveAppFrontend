import 'package:flutter/material.dart';

class Collaborator {
  int id;
  String email;
  String relationState;
  bool received = false;
  bool isSelected = false;

  Collaborator({
    this.id,
    @required this.email,
    @required this.relationState,
    this.isSelected,
    this.received,
  });
}
