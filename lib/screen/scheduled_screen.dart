import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:productive_app/provider/attachment_provider.dart';
import 'package:productive_app/provider/location_provider.dart';
import 'package:productive_app/utils/internet_connection.dart';
import 'package:provider/provider.dart';

import '../model/task.dart';
import '../provider/settings_provider.dart';
import '../provider/task_provider.dart';
import '../utils/manage_filters.dart';
import '../widget/empty_list.dart';
import '../widget/task_widget.dart';

class ScheduledScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Task> before = Provider.of<TaskProvider>(context).tasksBeforeToday();
    List<Task> today = Provider.of<TaskProvider>(context).tasksToday();
    List<Task> after = Provider.of<TaskProvider>(context).taskAfterToday();

    final userSettings = Provider.of<SettingsProvider>(context).userSettings;

    before = ManageFilters.filter(before, userSettings, context);
    today = ManageFilters.filter(today, userSettings, context);
    after = ManageFilters.filter(after, userSettings, context);

    return RefreshIndicator(
      backgroundColor: Theme.of(context).primaryColor,
      onRefresh: () async {
        if (await InternetConnection.internetConnection()) {
          final taskProvider = Provider.of<TaskProvider>(context, listen: false);
          await Future.wait(
            [
              taskProvider.fetchTasks(),
              Provider.of<AttachmentProvider>(context, listen: false).getAllDelegatedAttachments(taskProvider.delegatedTasksUuid),
              Provider.of<LocationProvider>(context, listen: false).getLocations(),
            ],
          );
        }
      },
      child: before.length == 0 && today.length == 0 && after.length == 0
          ? EmptyList(message: AppLocalizations.of(context).emptyScheduled)
          : SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(left: 21, right: 17, top: 10),
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (before.length > 0)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            AppLocalizations.of(context).beforeToday,
                            style: TextStyle(
                              fontSize: 27,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Divider(
                            thickness: 1.5,
                            color: Theme.of(context).primaryColor,
                          ),
                          if (userSettings.sortingMode == 6)
                            ReorderableListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: before.length,
                              itemBuilder: (ctx, index) => TaskWidget(
                                task: before[index],
                                key: ValueKey(before[index]),
                              ),
                              onReorder: (int oldIndex, int newIndex) {
                                if (newIndex > before.length) newIndex = before.length;
                                if (oldIndex < newIndex) newIndex -= 1;

                                final item = before.elementAt(oldIndex);
                                double newPosition = item.position;

                                if (newIndex < oldIndex) {
                                  if (newIndex != 0) {
                                    newPosition = (before.elementAt(newIndex).position + before.elementAt(newIndex - 1).position) / 2;
                                  } else {
                                    newPosition = before.elementAt(newIndex).position / 2;
                                  }
                                } else {
                                  if (newIndex != before.length - 1) {
                                    newPosition = (before.elementAt(newIndex).position + before.elementAt(newIndex + 1).position) / 2;
                                  } else {
                                    newPosition = before.elementAt(newIndex).position * 2;
                                  }
                                }

                                final task = before.removeAt(oldIndex);
                                before.insert(newIndex, task);
                                before.addAll(after);
                                before.addAll(today);
                                Provider.of<TaskProvider>(context, listen: false).setScheduledTasks(before);

                                Provider.of<TaskProvider>(context, listen: false).updateTaskPosition(item, newPosition);
                              },
                            ),
                          if (userSettings.sortingMode != 6)
                            Flexible(
                              child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: before.length,
                                itemBuilder: (ctx, index) => TaskWidget(
                                  task: before[index],
                                  key: ValueKey(before[index]),
                                ),
                              ),
                            ),
                        ],
                      ),
                    if (today.length > 0)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            AppLocalizations.of(context).today,
                            style: TextStyle(
                              fontSize: 27,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Divider(
                            thickness: 1.5,
                            color: Theme.of(context).primaryColor,
                          ),
                          if (userSettings.sortingMode == 6)
                            ReorderableListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: today.length,
                              itemBuilder: (ctx, index) => TaskWidget(
                                task: today[index],
                                key: ValueKey(today[index]),
                              ),
                              onReorder: (int oldIndex, int newIndex) {
                                if (newIndex > today.length) newIndex = today.length;
                                if (oldIndex < newIndex) newIndex -= 1;

                                final item = today.elementAt(oldIndex);
                                double newPosition = item.position;

                                if (newIndex < oldIndex) {
                                  if (newIndex != 0) {
                                    newPosition = (today.elementAt(newIndex).position + today.elementAt(newIndex - 1).position) / 2;
                                  } else {
                                    newPosition = today.elementAt(newIndex).position / 2;
                                  }
                                } else {
                                  if (newIndex != today.length - 1) {
                                    newPosition = (today.elementAt(newIndex).position + today.elementAt(newIndex + 1).position) / 2;
                                  } else {
                                    newPosition = today.elementAt(newIndex).position * 2;
                                  }
                                }

                                final task = today.removeAt(oldIndex);
                                today.insert(newIndex, task);
                                today.addAll(before);
                                today.addAll(after);
                                Provider.of<TaskProvider>(context, listen: false).setScheduledTasks(today);

                                Provider.of<TaskProvider>(context, listen: false).updateTaskPosition(item, newPosition);
                              },
                            ),
                          if (userSettings.sortingMode != 6)
                            Flexible(
                              child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: today.length,
                                itemBuilder: (ctx, index) => TaskWidget(
                                  task: today[index],
                                  key: ValueKey(today[index]),
                                ),
                              ),
                            ),
                        ],
                      ),
                    if (after.length > 0)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            AppLocalizations.of(context).afterToday,
                            style: TextStyle(
                              fontSize: 27,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Divider(
                            thickness: 1.5,
                            color: Theme.of(context).primaryColor,
                          ),
                          if (userSettings.sortingMode == 6)
                            ReorderableListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: after.length,
                              itemBuilder: (ctx, index) => TaskWidget(
                                task: after[index],
                                key: ValueKey(after[index]),
                              ),
                              onReorder: (int oldIndex, int newIndex) {
                                if (newIndex > after.length) newIndex = after.length;
                                if (oldIndex < newIndex) newIndex -= 1;

                                final item = after.elementAt(oldIndex);
                                double newPosition = item.position;

                                if (newIndex < oldIndex) {
                                  if (newIndex != 0) {
                                    newPosition = (after.elementAt(newIndex).position + after.elementAt(newIndex - 1).position) / 2;
                                  } else {
                                    newPosition = after.elementAt(newIndex).position / 2;
                                  }
                                } else {
                                  if (newIndex != after.length - 1) {
                                    newPosition = (after.elementAt(newIndex).position + after.elementAt(newIndex + 1).position) / 2;
                                  } else {
                                    newPosition = after.elementAt(newIndex).position * 2;
                                  }
                                }

                                final task = after.removeAt(oldIndex);
                                after.insert(newIndex, task);
                                after.addAll(before);
                                after.addAll(today);
                                Provider.of<TaskProvider>(context, listen: false).setScheduledTasks(after);

                                Provider.of<TaskProvider>(context, listen: false).updateTaskPosition(item, newPosition);
                              },
                            ),
                          if (userSettings.sortingMode != 6)
                            Flexible(
                              child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: after.length,
                                itemBuilder: (ctx, index) => TaskWidget(
                                  task: after[index],
                                  key: ValueKey(after[index]),
                                ),
                              ),
                            ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
    );
  }
}
