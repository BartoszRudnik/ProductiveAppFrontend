import 'package:flutter/material.dart';
import 'package:productive_app/provider/settings_provider.dart';
import 'package:provider/provider.dart';

class ClearFiltersButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).accentColor,
        border: Border(
          top: BorderSide(color: Theme.of(context).primaryColor, width: 1.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(4),
            primary: Theme.of(context).primaryColorLight,
            side: BorderSide(color: Theme.of(context).primaryColorDark),
          ),
          onPressed: () async {
            final userSettings = Provider.of<SettingsProvider>(context, listen: false).userSettings;

            if (userSettings.showOnlyWithLocalization != null && userSettings.showOnlyWithLocalization) {
              await Provider.of<SettingsProvider>(context, listen: false).changeShowOnlyWithLocalization();
            }
            if (userSettings.showOnlyDelegated != null && userSettings.showOnlyDelegated) {
              await Provider.of<SettingsProvider>(context, listen: false).changeShowOnlyDelegated();
            }
            if (userSettings.showOnlyUnfinished != null && userSettings.showOnlyUnfinished) {
              await Provider.of<SettingsProvider>(context, listen: false).changeShowOnlyUnfinished();
            }
            if (userSettings.collaborators != null) {
              await Provider.of<SettingsProvider>(context, listen: false).clearFilterCollaborators();
            }
            if (userSettings.locations != null) {
              await Provider.of<SettingsProvider>(context, listen: false).clearFilterLocations();
            }
            if (userSettings.priorities != null) {
              await Provider.of<SettingsProvider>(context, listen: false).clearFilterPriorities();
            }
            if (userSettings.tags != null) {
              await Provider.of<SettingsProvider>(context, listen: false).clearFilterTags();
            }
            if (userSettings.sortingMode != 0) {
              await Provider.of<SettingsProvider>(context, listen: false).changeSortingMode(0);
            }
          },
          child: Text(
            'Clear Filters',
            style: TextStyle(
              fontSize: 28,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
