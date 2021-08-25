import 'package:flutter/material.dart';
import 'package:productive_app/config/const_values.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../provider/task_provider.dart';

class FilterPriorityDialog extends StatelessWidget {
  List<String> choosenPriorities = [];

  FilterPriorityDialog({
    this.choosenPriorities,
  });

  @override
  Widget build(BuildContext context) {
    List<String> priorities = Provider.of<TaskProvider>(context, listen: false).priorities.reversed.toList();
    List<bool> selectedPriorities = [false, false, false, false, false];

    for (int i = 0; i < priorities.length; i++) {
      if (this.choosenPriorities.contains(priorities[i])) {
        selectedPriorities[i] = true;
      }
    }

    return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          content: Container(
            height: 320,
            width: 350,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(10),
                    itemCount: priorities.length,
                    itemBuilder: (ctx, priorityIndex) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: selectedPriorities[priorityIndex] ? Theme.of(context).primaryColor : Theme.of(context).accentColor,
                          side: BorderSide(color: Theme.of(context).primaryColor),
                        ),
                        onPressed: () {
                          setState(
                            () {
                              if (selectedPriorities[priorityIndex]) {
                                selectedPriorities[priorityIndex] = false;
                                this.choosenPriorities.remove(priorities[priorityIndex]);
                              } else {
                                selectedPriorities[priorityIndex] = true;
                                this.choosenPriorities.add(priorities[priorityIndex]);
                              }
                            },
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                ConstValues.priorities(priorities[priorityIndex], context),
                                style: TextStyle(
                                  color: selectedPriorities[priorityIndex] ? Theme.of(context).accentColor : Theme.of(context).primaryColor,
                                ),
                              ),
                              SizedBox(width: 10),
                              if (priorities[priorityIndex] == 'LOW')
                                Icon(
                                  Icons.arrow_downward_outlined,
                                  color: selectedPriorities[priorityIndex] ? Theme.of(context).accentColor : Theme.of(context).primaryColor,
                                ),
                              if (priorities[priorityIndex] == 'HIGH')
                                Icon(
                                  Icons.arrow_upward_outlined,
                                  color: selectedPriorities[priorityIndex] ? Theme.of(context).accentColor : Theme.of(context).primaryColor,
                                ),
                              if (priorities[priorityIndex] == 'HIGHER')
                                Icon(
                                  Icons.arrow_upward_outlined,
                                  color: selectedPriorities[priorityIndex] ? Theme.of(context).accentColor : Theme.of(context).primaryColor,
                                ),
                              if (priorities[priorityIndex] == 'HIGHER')
                                Icon(
                                  Icons.arrow_upward_outlined,
                                  color: selectedPriorities[priorityIndex] ? Theme.of(context).accentColor : Theme.of(context).primaryColor,
                                ),
                              if (priorities[priorityIndex] == 'CRITICAL')
                                Icon(
                                  Icons.warning_amber_sharp,
                                  color: selectedPriorities[priorityIndex] ? Theme.of(context).accentColor : Theme.of(context).primaryColor,
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop('cancel');
                      },
                      child: Text(AppLocalizations.of(context).cancel),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(this.choosenPriorities);
                      },
                      child: Text(AppLocalizations.of(context).save),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
