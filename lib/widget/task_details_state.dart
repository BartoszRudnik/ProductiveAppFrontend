import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:productive_app/config/const_values.dart';

class TaskDetailsState extends StatelessWidget {
  final String taskState;
  final Function setTaskState;
  final List<String> states;

  TaskDetailsState({
    @required this.taskState,
    @required this.setTaskState,
    @required this.states,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          minLeadingWidth: 16,
          contentPadding: EdgeInsets.symmetric(horizontal: 0),
          leading: Icon(Icons.list_alt_outlined),
          title: Align(
            alignment: Alignment(-1.1, 0),
            child: Text(
              AppLocalizations.of(context).state,
              style: TextStyle(fontSize: 21),
            ),
          ),
        ),
        Card(
          elevation: 2,
          child: PopupMenuButton(
            initialValue: this.taskState,
            onSelected: (value) {
              this.setTaskState(value);
            },
            itemBuilder: (ctx) {
              return this.states.map(
                (e) {
                  return PopupMenuItem(
                    value: e,
                    child: Text(
                      ConstValues.stateName(e, context),
                    ),
                  );
                },
              ).toList();
            },
            child: Container(
              height: 50,
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorLight,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: Center(
                  child: Text(
                    ConstValues.stateName(this.taskState, context),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
