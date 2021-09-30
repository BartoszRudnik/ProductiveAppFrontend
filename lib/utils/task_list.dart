import 'package:productive_app/model/task.dart';

class TaskList {
  static Task chooseTaskList(Task task) {
    if (task.taskState == null) {
      task.taskState = 'COLLECT';
      task.localization = 'INBOX';
    } else {
      if (task.done || task.taskState == 'COMPLETED') {
        task.taskState = "COMPLETED";
        task.localization = "COMPLETED";
      } else if (task.taskState == 'COLLECT') {
        task.localization = 'INBOX';
      } else if (task.taskState == "PLAN&DO") {
        if (task.delegatedEmail != null) {
          task.localization = 'DELEGATED';
        } else if (task.startDate != null) {
          task.localization = 'SCHEDULED';
        } else {
          task.localization = 'ANYTIME';
        }
      }
    }

    return task;
  }
}
