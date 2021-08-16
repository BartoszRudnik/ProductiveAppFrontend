import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/settings_provider.dart';
import '../widget/appBar/filters_appBar.dart';
import '../widget/button/clear_filters_button.dart';
import '../widget/filter_priorities.dart';
import '../widget/filters_collaborators.dart';
import '../widget/filters_locations.dart';
import '../widget/filters_sorting_mode.dart';
import '../widget/filters_tags.dart';
import '../widget/switch_list_tile/filter_switch_list_tile.dart';

class FiltersScreen extends StatelessWidget {
  static const routeName = '/filters-screen';

  @override
  Widget build(BuildContext context) {
    final userSettings = Provider.of<SettingsProvider>(context).userSettings;

    return Scaffold(
      appBar: FiltersAppBar(
        title: 'Tasks filters',
      ),
      bottomNavigationBar: ClearFiltersButton(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10.0,
            vertical: 10.0,
          ),
          child: Column(
            children: [
              FiltersSortingMode(sortingMode: userSettings.sortingMode),
              FiltersTags(tags: userSettings.tags),
              FiltersLocations(locations: userSettings.locations),
              FiltersCollaborators(collaborators: userSettings.collaborators),
              FilterPriorities(priorities: userSettings.priorities),
              FilterSwitchListTile(
                func: Provider.of<SettingsProvider>(context, listen: false).changeShowOnlyUnfinished,
                message: 'Show unfinished tasks',
                value: userSettings.showOnlyUnfinished,
              ),
              FilterSwitchListTile(
                func: Provider.of<SettingsProvider>(context, listen: false).changeShowOnlyDelegated,
                message: 'Show received tasks',
                value: userSettings.showOnlyDelegated,
              ),
              FilterSwitchListTile(
                func: Provider.of<SettingsProvider>(context, listen: false).changeShowOnlyWithLocalization,
                message: 'Show tasks with localization',
                value: userSettings.showOnlyWithLocalization,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
