import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/settings_provider.dart';
import '../widgets/filter_delegate_dialog.dart';
import '../widgets/filter_priority_dialog.dart';
import '../widgets/filter_tags_dialog.dart';
import '../widgets/filters_appBar.dart';

class FiltersScreen extends StatefulWidget {
  static const routeName = '/filters-screen';

  @override
  _FiltersScreenState createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  final sortingModes = [
    'end Date ascending',
    'end Date descending',
    'start Date ascending',
    'start Date descending',
    'priority descending',
    'priority ascending',
    'custom',
  ];

  @override
  Widget build(BuildContext context) {
    final userSettings = Provider.of<SettingsProvider>(context).userSettings;

    List<String> tags = userSettings.tags;
    List<String> priorities = userSettings.priorities;
    List<String> collaborators = userSettings.collaborators;
    bool showOnlyUnfinished = userSettings.showOnlyUnfinished;
    bool showOnlyDelegated = userSettings.showOnlyDelegated;
    int sortingMode = userSettings.sortingMode;

    return Scaffold(
      appBar: FiltersAppBar(
        title: 'Tasks filters',
      ),
      bottomNavigationBar: Container(
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
              primary: Theme.of(context).primaryColor,
              side: BorderSide(color: Theme.of(context).primaryColor),
            ),
            onPressed: () async {
              final userSettings = Provider.of<SettingsProvider>(context, listen: false).userSettings;

              if (userSettings.showOnlyDelegated != null && userSettings.showOnlyDelegated) {
                await Provider.of<SettingsProvider>(context, listen: false).changeShowOnlyDelegated();
              }
              if (userSettings.showOnlyUnfinished != null && userSettings.showOnlyUnfinished) {
                await Provider.of<SettingsProvider>(context, listen: false).changeShowOnlyUnfinished();
              }
              if (userSettings.collaborators != null) {
                await Provider.of<SettingsProvider>(context, listen: false).clearFilterCollaborators();
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
              style: TextStyle(fontSize: 28, color: Theme.of(context).accentColor),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10.0,
            vertical: 10.0,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Card(
                  elevation: 8,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8, bottom: 4),
                        child: Row(
                          children: [
                            Text(
                              'Sort by',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w400,
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        height: 70,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: sortingModes.length,
                          itemBuilder: (context, index) => GestureDetector(
                            onTap: () => Provider.of<SettingsProvider>(context, listen: false).changeSortingMode(index),
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              margin: EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                color: sortingMode == index ? Colors.grey : Colors.white,
                                border: Border.all(
                                  color: Theme.of(context).primaryColor,
                                  width: sortingMode == index ? 0.9 : 0.2,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  sortingModes[index],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: sortingMode == index ? Colors.white : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Card(
                  elevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            children: [
                              Text(
                                'Tags',
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
                                      if (tags != null) {
                                        return FilterTagsDialog(choosenTags: tags);
                                      } else {
                                        return FilterTagsDialog();
                                      }
                                    },
                                  );

                                  if (selected != null && selected.length >= 1) {
                                    await Provider.of<SettingsProvider>(context, listen: false).addFilterTags(selected);
                                  } else {
                                    await Provider.of<SettingsProvider>(context, listen: false).clearFilterTags();
                                  }
                                },
                                child: Text(
                                  'Choose tags',
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (tags != null && tags.length >= 1)
                          Container(
                            height: 60,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: tags.length,
                              itemBuilder: (context, index) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(horizontal: 4),
                                  margin: EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    border: Border.all(
                                      color: Theme.of(context).primaryColor,
                                      width: 0.7,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 16.0),
                                        child: Text(
                                          tags[index],
                                          style: TextStyle(color: Theme.of(context).accentColor, fontSize: 18),
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.cancel_outlined, color: Theme.of(context).accentColor),
                                        onPressed: () {
                                          setState(
                                            () {
                                              Provider.of<SettingsProvider>(context, listen: false).deleteFilterTag(tags[index]);
                                            },
                                          );
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
              ),
              Padding(
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
                                      if (priorities != null) {
                                        return FilterPriorityDialog(
                                          choosenPriorities: priorities,
                                        );
                                      } else {
                                        return FilterPriorityDialog();
                                      }
                                    },
                                  );

                                  if (selected != null && selected.length >= 1) {
                                    await Provider.of<SettingsProvider>(context, listen: false).addFilterPriorities(selected);
                                  } else {
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
                        if (priorities != null && priorities.length >= 1)
                          Container(
                            height: 60,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: priorities.length,
                              itemBuilder: (context, index) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(horizontal: 4),
                                  margin: EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    border: Border.all(
                                      color: Theme.of(context).primaryColor,
                                      width: 0.7,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 16.0),
                                        child: Text(
                                          priorities[index],
                                          style: TextStyle(color: Theme.of(context).accentColor, fontSize: 18),
                                        ),
                                      ),
                                      if (priorities[index] == 'LOW') Icon(Icons.arrow_downward_outlined, color: Theme.of(context).accentColor),
                                      if (priorities[index] == 'HIGH') Icon(Icons.arrow_upward_outlined, color: Theme.of(context).accentColor),
                                      if (priorities[index] == 'HIGHER') Icon(Icons.arrow_upward_outlined, color: Theme.of(context).accentColor),
                                      if (priorities[index] == 'HIGHER') Icon(Icons.arrow_upward_outlined, color: Theme.of(context).accentColor),
                                      if (priorities[index] == 'CRITICAL') Icon(Icons.warning_amber_sharp, color: Theme.of(context).accentColor),
                                      IconButton(
                                        icon: Icon(Icons.cancel_outlined, color: Theme.of(context).accentColor),
                                        onPressed: () {
                                          setState(
                                            () {
                                              Provider.of<SettingsProvider>(context, listen: false).deleteFilterPriority(priorities[index]);
                                            },
                                          );
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
              ),
              Padding(
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
                                'Collaborators',
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
                                      if (collaborators != null) {
                                        return FilterDelegateDialog(
                                          choosenCollaborators: collaborators,
                                        );
                                      } else {
                                        return FilterDelegateDialog();
                                      }
                                    },
                                  );

                                  if (selected != null && selected.length >= 1) {
                                    await Provider.of<SettingsProvider>(context, listen: false).addFilterCollaboratorEmail(selected);
                                  } else {
                                    await Provider.of<SettingsProvider>(context, listen: false).clearFilterCollaborators();
                                  }
                                },
                                child: Text(
                                  'Choose collaborators',
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (collaborators != null && collaborators.length >= 1)
                          Container(
                            height: 60,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: collaborators.length,
                              itemBuilder: (context, index) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(horizontal: 4),
                                  margin: EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    border: Border.all(
                                      color: Theme.of(context).primaryColor,
                                      width: 0.7,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 16.0),
                                        child: Text(
                                          collaborators[index],
                                          style: TextStyle(color: Theme.of(context).accentColor, fontSize: 18),
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.cancel_outlined, color: Theme.of(context).accentColor),
                                        onPressed: () {
                                          setState(
                                            () {
                                              Provider.of<SettingsProvider>(context, listen: false).deleteFilterCollaboratorEmail(collaborators[index]);
                                            },
                                          );
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
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Card(
                  elevation: 8,
                  child: SwitchListTile(
                    activeColor: Theme.of(context).primaryColor,
                    title: Text('Show only unfinished tasks'),
                    value: showOnlyUnfinished,
                    onChanged: (bool value) {
                      setState(() {
                        showOnlyUnfinished = value;
                        Provider.of<SettingsProvider>(context, listen: false).changeShowOnlyUnfinished();
                      });
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Card(
                  elevation: 8,
                  child: SwitchListTile(
                    activeColor: Theme.of(context).primaryColor,
                    title: Text('Show only received tasks'),
                    value: showOnlyDelegated,
                    onChanged: (bool value) {
                      setState(() {
                        showOnlyDelegated = value;
                        Provider.of<SettingsProvider>(context, listen: false).changeShowOnlyDelegated();
                      });
                    },
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
