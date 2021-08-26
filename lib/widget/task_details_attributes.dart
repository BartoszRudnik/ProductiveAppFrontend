import 'package:flutter/material.dart';
import 'package:productive_app/config/color_themes.dart';
import 'package:productive_app/config/const_values.dart';
import 'package:productive_app/model/task.dart';
import 'package:productive_app/provider/delegate_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:auto_size_text/auto_size_text.dart';

class TaskDetailsAttributes extends StatelessWidget {
  final Task taskToEdit;
  final List<String> priorities;
  final List<String> localizations;
  final Function setDelegatedEmail;
  final Function setPriority;
  final Function setLocalization;

  TaskDetailsAttributes({
    @required this.taskToEdit,
    @required this.priorities,
    @required this.setDelegatedEmail,
    @required this.localizations,
    @required this.setPriority,
    @required this.setLocalization,
  });

  @override
  Widget build(BuildContext context) {
    String collaboratorName;

    if (this.taskToEdit.delegatedEmail != null) {
      final collab = Provider.of<DelegateProvider>(context).collaborators.firstWhere((element) => element.email == this.taskToEdit.delegatedEmail, orElse: () => null);

      if (collab != null) {
        collaboratorName = collab.collaboratorName;
      }
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 5,
          child: SizedBox(
            height: 100,
            child: PopupMenuButton(
              initialValue: this.taskToEdit.priority,
              onSelected: (value) {
                this.setPriority(value);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorLight,
                  borderRadius: BorderRadius.circular(3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.8),
                      offset: Offset(0.0, 1.0),
                      blurRadius: 1.0,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (this.taskToEdit.priority == 'NORMAL') Icon(Icons.flag),
                    if (this.taskToEdit.priority == 'LOW') Icon(Icons.arrow_downward_outlined),
                    if (this.taskToEdit.priority == 'HIGH') Icon(Icons.arrow_upward_outlined),
                    if (this.taskToEdit.priority == 'HIGHER')
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.arrow_upward_outlined),
                          Icon(Icons.arrow_upward_outlined),
                        ],
                      ),
                    if (this.taskToEdit.priority == 'CRITICAL') Icon(Icons.warning_amber_sharp),
                    Text(AppLocalizations.of(context).priority),
                  ],
                ),
              ),
              itemBuilder: (context) {
                return priorities.reversed.map((e) {
                  return PopupMenuItem(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(ConstValues.priorities(e, context)),
                        SizedBox(
                          width: 5,
                        ),
                        if (e == 'LOW') Icon(Icons.arrow_downward_outlined),
                        if (e == 'HIGH') Icon(Icons.arrow_upward_outlined),
                        if (e == 'HIGHER') Icon(Icons.arrow_upward_outlined),
                        if (e == 'HIGHER') Icon(Icons.arrow_upward_outlined),
                        if (e == 'CRITICAL') Icon(Icons.warning_amber_sharp),
                      ],
                    ),
                    value: e,
                  );
                }).toList();
              },
            ),
          ),
        ),
        Expanded(flex: 1, child: SizedBox()),
        Expanded(
          flex: 5,
          child: SizedBox(
            height: 100,
            child: ElevatedButton(
              style: ColorThemes.taskDetailsButtonStyle(context),
              onPressed: () {
                this.setDelegatedEmail();
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_add),
                  AutoSizeText(
                    this.taskToEdit.delegatedEmail == null || collaboratorName == null
                        ? AppLocalizations.of(context).assigned
                        : collaboratorName.length > 1
                            ? collaboratorName
                            : this.taskToEdit.delegatedEmail,
                    textAlign: TextAlign.center,
                    presetFontSizes: ConstValues.fontSizes,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(flex: 1, child: SizedBox()),
        Expanded(
          flex: 5,
          child: SizedBox(
            height: 100,
            child: PopupMenuButton(
              initialValue: taskToEdit.localization,
              onSelected: (value) {
                this.setLocalization(value);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorLight,
                  borderRadius: BorderRadius.circular(3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.8),
                      offset: Offset(0.0, 1.0),
                      blurRadius: 1.0,
                    )
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inbox),
                    Flexible(
                      child: AutoSizeText(
                        ConstValues.listName(taskToEdit.localization, context),
                        minFontSize: 10,
                        maxFontSize: 16,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              itemBuilder: (context) {
                return localizations.map((e) {
                  return PopupMenuItem(
                    child: Text(ConstValues.listName(e, context)),
                    value: e,
                  );
                }).toList();
              },
            ),
          ),
        ),
      ],
    );
  }
}
