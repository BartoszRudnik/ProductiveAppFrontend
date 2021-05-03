import 'package:flutter/foundation.dart';
import 'package:productive_app/task_page/models/tag.dart';

class Task with ChangeNotifier {
  int id;
  double position;
  String title;
  String description;
  String priority;
  String localization;
  String delegatedEmail;
  String taskStatus;
  DateTime startDate;
  DateTime endDate;
  List<Tag> tags = [];
  bool done;
  bool isDelegated;
  bool isCanceled;

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
    this.delegatedEmail,
    this.isDelegated,
    this.taskStatus,
    this.isCanceled,
  });
}
