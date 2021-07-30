import 'package:flutter/material.dart';

class CollaboratorTask {
  int id;
  String title;
  String description;
  DateTime startDate;
  DateTime endDate;
  DateTime lastUpdated;

  CollaboratorTask({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.startDate,
    @required this.endDate,
    @required this.lastUpdated,
  });
}
