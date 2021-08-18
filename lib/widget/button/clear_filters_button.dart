import 'package:flutter/material.dart';
import 'package:productive_app/provider/settings_provider.dart';
import 'package:provider/provider.dart';

class ClearFiltersButton extends StatelessWidget {
  Future<void> clear(userSettings, context) async {
    await Future.wait(
      [
        if (userSettings.showOnlyWithLocalization != null && userSettings.showOnlyWithLocalization) Provider.of<SettingsProvider>(context, listen: false).changeShowOnlyWithLocalization(),
        if (userSettings.showOnlyDelegated != null && userSettings.showOnlyDelegated) Provider.of<SettingsProvider>(context, listen: false).changeShowOnlyDelegated(),
        if (userSettings.showOnlyUnfinished != null && userSettings.showOnlyUnfinished) Provider.of<SettingsProvider>(context, listen: false).changeShowOnlyUnfinished(),
        if (userSettings.collaborators != null) Provider.of<SettingsProvider>(context, listen: false).clearFilterCollaborators(),
        if (userSettings.locations != null) Provider.of<SettingsProvider>(context, listen: false).clearFilterLocations(),
        if (userSettings.priorities != null) Provider.of<SettingsProvider>(context, listen: false).clearFilterPriorities(),
        if (userSettings.tags != null) Provider.of<SettingsProvider>(context, listen: false).clearFilterTags(),
        if (userSettings.sortingMode != 0) Provider.of<SettingsProvider>(context, listen: false).changeSortingMode(0),
      ],
    );
  }

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
          onPressed: () async {
            final userSettings = Provider.of<SettingsProvider>(context, listen: false).userSettings;

            await this.clear(userSettings, context);
          },
          child: Text(
            'Clear Filters',
            style: TextStyle(fontSize: 28),
          ),
        ),
      ),
    );
  }
}
