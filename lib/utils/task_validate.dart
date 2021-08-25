import 'package:flutter/cupertino.dart';
import 'package:productive_app/model/task.dart';
import 'package:productive_app/utils/dialogs.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TaskValidate {
  static Future<bool> validateTaskEdit(Task taskToEdit, Task originalTask, BuildContext context) async {
    if (taskToEdit.startDate == null && taskToEdit.localization == "SCHEDULED") {
      await Dialogs.showWarningDialog(context, AppLocalizations.of(context).scheduledTask);
      return false;
    }

    if (taskToEdit.startDate != null && taskToEdit.localization == "ANYTIME") {
      await Dialogs.showWarningDialog(context, AppLocalizations.of(context).startDateMustBeScheduled);
      return false;
    }

    if (taskToEdit.localization == "COMPLETED" && !taskToEdit.done) {
      await Dialogs.showWarningDialog(context, AppLocalizations.of(context).completedTaskMarkAsDone);
      return false;
    }

    if (originalTask.localization != "INBOX" && taskToEdit.localization == "INBOX") {
      await Dialogs.showWarningDialog(context, AppLocalizations.of(context).cannotBackToInbox);
      return false;
    }

    if (taskToEdit.localization == 'DELEGATED' && (taskToEdit.delegatedEmail == null || taskToEdit.delegatedEmail.length <= 1)) {
      await Dialogs.showWarningDialog(context, AppLocalizations.of(context).delegateMustHavePerson);
      return false;
    }

    if (originalTask.localization == 'DELEGATED' && taskToEdit.localization != 'DELEGATED' && taskToEdit.delegatedEmail != null) {
      await Dialogs.showWarningDialog(context, AppLocalizations.of(context).taskWithPersonOnDelegated);
      return false;
    }

    if (originalTask.supervisorEmail != null && originalTask.supervisorEmail == taskToEdit.delegatedEmail) {
      await Dialogs.showWarningDialog(context, AppLocalizations.of(context).cannotDelegateToPrincipal);
      return false;
    }
    if (taskToEdit.endDate != null && taskToEdit.startDate != null && taskToEdit.endDate.isBefore(taskToEdit.startDate)) {
      await Dialogs.showWarningDialog(context, AppLocalizations.of(context).endDateLaterThanStartDate);
      return false;
    }

    return true;
  }

  static Future<bool> validateNewTask(DateTime startDate, DateTime endDate, String localization, bool isDone, String delegatedEmail, BuildContext context) async {
    if (startDate == null && localization == "SCHEDULED") {
      await Dialogs.showWarningDialog(context, AppLocalizations.of(context).scheduledTask);
      return false;
    }

    if (startDate != null && localization == "ANYTIME") {
      await Dialogs.showWarningDialog(context, AppLocalizations.of(context).startDateMustBeScheduled);
      return false;
    }

    if (localization == "COMPLETED" && !isDone) {
      await Dialogs.showWarningDialog(context, AppLocalizations.of(context).completedTaskMarkAsDone);
      return false;
    }

    if (localization == 'DELEGATED' && (delegatedEmail == null || delegatedEmail.length <= 1)) {
      await Dialogs.showWarningDialog(context, AppLocalizations.of(context).delegateMustHavePerson);
      return false;
    }

    if (endDate != null && startDate != null && endDate.isBefore(startDate)) {
      await Dialogs.showWarningDialog(context, AppLocalizations.of(context).endDateLaterThanStartDate);
      return false;
    }

    return true;
  }
}
