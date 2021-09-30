import 'package:flutter/cupertino.dart';
import 'package:productive_app/model/task.dart';
import 'package:productive_app/utils/dialogs.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TaskValidate {
  static Future<bool> validateTaskEdit(Task taskToEdit, Task originalTask, BuildContext context) async {
    if (originalTask.localization != "INBOX" && taskToEdit.localization == "INBOX") {
      await Dialogs.showWarningDialog(context, AppLocalizations.of(context).cannotBackToInbox);
      return false;
    }

    if (taskToEdit.localization == 'DELEGATED' && (taskToEdit.delegatedEmail == null || taskToEdit.delegatedEmail.length <= 1)) {
      await Dialogs.showWarningDialog(context, AppLocalizations.of(context).delegateMustHavePerson);
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

  static Future<bool> validateNewTask(
      DateTime startDate, DateTime endDate, String localization, bool isDone, String delegatedEmail, BuildContext context) async {
    if (endDate != null && startDate != null && endDate.isBefore(startDate)) {
      await Dialogs.showWarningDialog(context, AppLocalizations.of(context).endDateLaterThanStartDate);
      return false;
    }

    return true;
  }
}
