import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/settings.dart';
import '../model/task.dart';
import '../provider/task_provider.dart';

class ManageFilters {
  static List<Task> filter(List<Task> tasks, Settings userSettings, BuildContext context) {
    if (userSettings.showOnlyWithLocalization != null && userSettings.showOnlyWithLocalization) {
      tasks = Provider.of<TaskProvider>(context, listen: false).onlyWithLocalization(tasks);
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
    if (userSettings.locations != null && userSettings.locations.length >= 1) {
      tasks = Provider.of<TaskProvider>(context, listen: false).filterLocations(tasks, userSettings.locations);
    }
    if (userSettings.sortingMode == 0) {
      Provider.of<TaskProvider>(context, listen: false).sortByEndDateAscending(tasks);
    } else if (userSettings.sortingMode == 1) {
      Provider.of<TaskProvider>(context, listen: false).sortByEndDateDescending(tasks);
    } else if (userSettings.sortingMode == 2) {
      Provider.of<TaskProvider>(context, listen: false).sortByStartDateAscending(tasks);
    } else if (userSettings.sortingMode == 3) {
      Provider.of<TaskProvider>(context, listen: false).sortByStartDateDescending(tasks);
    } else if (userSettings.sortingMode == 4) {
      Provider.of<TaskProvider>(context, listen: false).sortByPriorityDescending(tasks);
    } else if (userSettings.sortingMode == 5) {
      Provider.of<TaskProvider>(context, listen: false).sortByPriorityAscending(tasks);
    }

    if (userSettings.taskName != null && userSettings.taskName.length >= 1) {
      tasks = tasks.where((task) => task.title.toLowerCase().contains(userSettings.taskName.toLowerCase())).toList();
    }

    return tasks;
  }
}
