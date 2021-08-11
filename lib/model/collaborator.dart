import 'package:flutter/material.dart';

class Collaborator {
  int id;
  String email;
  String relationState;
  String collaboratorName;
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
    this.collaboratorName,
    @required this.email,
    @required this.relationState,
    this.isSelected,
    this.received,
    this.isAskingForPermission,
    this.alreadyAsked,
  });
}
