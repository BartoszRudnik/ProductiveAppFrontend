import 'package:flutter/cupertino.dart';
import 'package:productive_app/model/task.dart';
import 'package:productive_app/utils/dialogs.dart';

class TaskValidate {
  static Future<bool> validateTaskEdit(Task taskToEdit, Task originalTask, BuildContext context) async {
    if (taskToEdit.startDate == null && taskToEdit.localization == "SCHEDULED") {
      await Dialogs.showWarningDialog(context, "Scheduled tasks have to specify start date");
      return false;
    }

    if (taskToEdit.startDate != null && taskToEdit.localization == "ANYTIME") {
      await Dialogs.showWarningDialog(context, "Tasks with start date should be scheduled");
      return false;
    }

    if (taskToEdit.localization == "COMPLETED" && !taskToEdit.done) {
      await Dialogs.showWarningDialog(context, "Completed tasks have to be marked as done");
      return false;
    }

    if (originalTask.localization != "INBOX" && taskToEdit.localization == "INBOX") {
      await Dialogs.showWarningDialog(context, "Task cannot return to inbox");
      return false;
    }

    if (taskToEdit.localization == 'DELEGATED' && (taskToEdit.delegatedEmail == null || taskToEdit.delegatedEmail.length <= 1)) {
      await Dialogs.showWarningDialog(context, "Delegated task must have delegated person");
      return false;
    }

    if (originalTask.localization == 'DELEGATED' && taskToEdit.localization != 'DELEGATED' && taskToEdit.delegatedEmail != null) {
      await Dialogs.showWarningDialog(context, "Task with specified delegated person must be on delegated list");
      return false;
    }

    if (originalTask.supervisorEmail != null && originalTask.supervisorEmail == taskToEdit.delegatedEmail) {
      await Dialogs.showWarningDialog(context, 'Cannot delegate task to principal');
      return false;
    }
    if (taskToEdit.endDate != null && taskToEdit.startDate != null && taskToEdit.endDate.isBefore(taskToEdit.startDate)) {
      await Dialogs.showWarningDialog(context, 'End date must be later than start date');
      return false;
    }

    return true;
  }

  static Future<bool> validateNewTask(DateTime startDate, DateTime endDate, String localization, bool isDone, String delegatedEmail, BuildContext context) async {
    if (startDate == null && localization == "SCHEDULED") {
      await Dialogs.showWarningDialog(context, "Scheduled tasks have to specify start date");
      return false;
    }

    if (startDate != null && localization == "ANYTIME") {
      await Dialogs.showWarningDialog(context, "Tasks with start date should be scheduled");
      return false;
    }

    if (localization == "COMPLETED" && !isDone) {
      await Dialogs.showWarningDialog(context, "Completed tasks have to be marked as done");
      return false;
    }

    if (localization == 'DELEGATED' && (delegatedEmail == null || delegatedEmail.length <= 1)) {
      await Dialogs.showWarningDialog(context, "Delegated task must have delegated person");
      return false;
    }

    if (endDate != null && startDate != null && endDate.isBefore(startDate)) {
      await Dialogs.showWarningDialog(context, 'End date must be later than start date');
      return false;
    }

    return true;
  }
}
