import 'package:flutter/material.dart';
import 'package:productive_app/model/location.dart';

class TaskLocation {
  Location location;
  double notificationRadius;
  bool notificationOnEnter;
  bool notificationOnExit;

  TaskLocation({
    @required this.location,
    @required this.notificationOnEnter,
    @required this.notificationOnExit,
    @required this.notificationRadius,
  });
}
