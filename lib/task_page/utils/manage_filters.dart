import 'package:flutter/material.dart';
import 'package:productive_app/task_page/models/settings.dart';
import 'package:productive_app/task_page/models/task.dart';
import 'package:productive_app/task_page/providers/task_provider.dart';
import 'package:provider/provider.dart';

class ManageFilters {
  static List<Task> filter(List<Task> tasks, Settings userSettings, BuildContext context) {
    if (userSettings.showOnlyUnfinished != null && userSettings.showOnlyUnfinished) {
      tasks = Provider.of<TaskProvider>(context, listen: false).onlyUnfinishedTasks(tasks);
    }
    if (userSettings.showOnlyDelegated != null && userSettings.showOnlyDelegated) {
      tasks = Provider.of<TaskProvider>(context, listen: false).onlyDelegatedTasks(tasks);
    }
    if (userSettings.collaborators != null && userSettings.collaborators.length >= 1) {
      tasks = Provider.of<TaskProvider>(context, listen: false).filterCollaboratorEmail(tasks, userSettings.collaborators);
    }
    if (userSettings.priorities != null && userSettings.priorities.length >= 1) {
      tasks = Provider.of<TaskProvider>(context, listen: false).filterPriority(tasks, userSettings.priorities);
    }
    if (userSettings.tags != null && userSettings.tags.length >= 1) {
      tasks = Provider.of<TaskProvider>(context, listen: false).filterTags(tasks, userSettings.tags);
    }
    if (userSettings.sortingMode == 0) {
      Provider.of<TaskProvider>(context, listen: false).sortByEndDateAscending(tasks);
    }
    if (userSettings.sortingMode == 1) {
      Provider.of<TaskProvider>(context, listen: false).sortByEndDateDescending(tasks);
    }
    if (userSettings.sortingMode == 2) {
      Provider.of<TaskProvider>(context, listen: false).sortByStartDateAscending(tasks);
    }
    if (userSettings.sortingMode == 3) {
      Provider.of<TaskProvider>(context, listen: false).sortByStartDateDescending(tasks);
    }
    if (userSettings.sortingMode == 4) {
      Provider.of<TaskProvider>(context, listen: false).sortByPriorityDescending(tasks);
    }
    if (userSettings.sortingMode == 5) {
      Provider.of<TaskProvider>(context, listen: false).sortByPriorityAscending(tasks);
    }

    return tasks;
  }
}
