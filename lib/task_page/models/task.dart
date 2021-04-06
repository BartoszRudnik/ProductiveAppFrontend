import 'package:flutter/foundation.dart';

class Task with ChangeNotifier {
  int id;
  String title;
  String description;
  String priority;
  DateTime startDate;
  DateTime endDate;
  List<String> tags = [];
  bool done;

  Task({
    @required this.id,
    @required this.title,
    this.priority,
    this.description,
    this.startDate,
    this.endDate,
    this.tags,
    this.done,
  });
}
