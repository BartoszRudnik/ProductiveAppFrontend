import 'package:flutter/material.dart';
import 'package:productive_app/provider/settings_provider.dart';
import 'package:productive_app/widget/dialog/filter_priority_dialog.dart';
import 'package:provider/provider.dart';

class FilterPriorities extends StatelessWidget {
  final priorities;

  FilterPriorities({
    @required this.priorities,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Card(
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    Text(
                      'Priorities',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(4),
                        primary: Theme.of(context).accentColor,
                        side: BorderSide(color: Theme.of(context).primaryColor),
                      ),
                      onPressed: () async {
                        final selected = await showDialog(
                          context: context,
                          builder: (context) {
                            if (this.priorities != null) {
                              return FilterPriorityDialog(
                                choosenPriorities: this.priorities,
                              );
                            } else {
                              return FilterPriorityDialog();
                            }
                          },
                        );

                        if (selected != null && selected.length >= 1) {
                          await Provider.of<SettingsProvider>(context, listen: false).addFilterPriorities(selected);
                        } else if (selected != 'cancel') {
                          await Provider.of<SettingsProvider>(context, listen: false).clearFilterPriorities();
                        }
                      },
                      child: Text(
                        'Choose priorities',
                        style: TextStyle(
                          fontSize: 24,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (this.priorities != null && this.priorities.length >= 1)
                Container(
                  height: 60,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: this.priorities.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(200, 200, 200, 1),
                          border: Border.all(
                            color: Color.fromRGBO(191, 191, 196, 1),
                            width: 2.5,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: Text(
                                this.priorities[index],
                                style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            if (this.priorities[index] == 'LOW') Icon(Icons.arrow_downward_outlined, color: Theme.of(context).accentColor),
                            if (this.priorities[index] == 'HIGH') Icon(Icons.arrow_upward_outlined, color: Theme.of(context).accentColor),
                            if (this.priorities[index] == 'HIGHER') Icon(Icons.arrow_upward_outlined, color: Theme.of(context).accentColor),
                            if (this.priorities[index] == 'HIGHER') Icon(Icons.arrow_upward_outlined, color: Theme.of(context).accentColor),
                            if (this.priorities[index] == 'CRITICAL') Icon(Icons.warning_amber_sharp, color: Theme.of(context).accentColor),
                            IconButton(
                              icon: Icon(Icons.cancel_outlined, color: Theme.of(context).accentColor),
                              onPressed: () {
                                Provider.of<SettingsProvider>(context, listen: false).deleteFilterPriority(this.priorities[index]);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
