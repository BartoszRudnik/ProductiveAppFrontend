import 'package:flutter/material.dart';
import 'package:productive_app/provider/settings_provider.dart';
import 'package:productive_app/widget/dialog/filter_priority_dialog.dart';
import 'package:productive_app/widget/single_selected_filter.dart';
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
                        style: TextStyle(fontSize: 24),
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
                    itemBuilder: (context, index) {
                      Future<void> onPressed() async {
                        Provider.of<SettingsProvider>(context, listen: false).deleteFilterPriority(this.priorities[index]);
                      }

                      Widget icon;

                      if (this.priorities[index] == 'LOW') icon = Icon(Icons.arrow_downward_outlined, color: Theme.of(context).primaryColor);
                      if (this.priorities[index] == 'HIGH') icon = Icon(Icons.arrow_upward_outlined, color: Theme.of(context).primaryColor);
                      if (this.priorities[index] == 'HIGHER')
                        icon = Row(
                          children: [
                            Icon(Icons.arrow_upward_outlined, color: Theme.of(context).primaryColor),
                            Icon(Icons.arrow_upward_outlined, color: Theme.of(context).primaryColor),
                          ],
                        );
                      if (this.priorities[index] == 'CRITICAL') icon = Icon(Icons.warning_amber_sharp, color: Theme.of(context).primaryColor);

                      return SingleSelectedFilter(
                        text: this.priorities[index],
                        onPressed: onPressed,
                        icon: icon,
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
