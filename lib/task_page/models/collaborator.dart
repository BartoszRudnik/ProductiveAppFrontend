import 'package:flutter/material.dart';

class Collaborator {
  int id;
  String email;
  String relationState;
  bool alreadyAsked;
  bool isAskingForPermission;
  bool sentPermission;
  bool receivedPermission;
  bool received = false;
  bool isSelected = false;

  Collaborator({
    this.id,
    this.sentPermission,
    this.receivedPermission,
    @required this.email,
    @required this.relationState,
    this.isSelected,
    this.received,
    this.isAskingForPermission,
    this.alreadyAsked,
  });
}
