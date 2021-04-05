import 'package:flutter/foundation.dart';

class Task with ChangeNotifier {
  String id;
  String title;
  String description;
  DateTime startDate;
  DateTime endDate;
  List<String> tags = [];
  bool done;

  Task({
    @required this.id,
    @required this.title,
    this.description,
    this.startDate,
    this.endDate,
    this.tags,
    this.done,
  });

  void changeTaskStatus() {
    this.done = !this.done;

    notifyListeners();
  }
}
