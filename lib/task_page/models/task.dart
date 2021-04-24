import 'package:flutter/foundation.dart';
import 'package:productive_app/task_page/models/tag.dart';

class Task with ChangeNotifier {
  int id;
  double position;
  String title;
  String description;
  String priority;
  String localization;
  DateTime startDate;
  DateTime endDate;
  List<Tag> tags = [];
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
    this.localization,
    this.position,
  });
}
