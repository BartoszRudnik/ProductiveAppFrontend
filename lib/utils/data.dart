import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../model/task.dart';
import '../provider/attachment_provider.dart';
import '../provider/auth_provider.dart';
import '../provider/delegate_provider.dart';
import '../provider/location_provider.dart';
import '../provider/settings_provider.dart';
import '../provider/tag_provider.dart';
import '../provider/task_provider.dart';

class Data {
  static Future<void> loadData(BuildContext context) async {
    try {
      await Future.wait(
        [
          Provider.of<TaskProvider>(context, listen: false).fetchTasks(),
          Provider.of<TaskProvider>(context, listen: false).getPriorities(),
          Provider.of<TagProvider>(context, listen: false).getTags(),
          Provider.of<LocationProvider>(context, listen: false).getLocations(),
          Provider.of<DelegateProvider>(context, listen: false).getCollaborators(),
          Provider.of<SettingsProvider>(context, listen: false).getFilterSettings(),
          Provider.of<AuthProvider>(context, listen: false).getUserData(),
          Provider.of<AuthProvider>(context, listen: false).checkIfAvatarExists(),
          Provider.of<AttachmentProvider>(context, listen: false).getAttachments(),
        ],
      );
    } catch (error) {
      print(error);
    }

    final List<Task> delegatedTasks = Provider.of<TaskProvider>(context, listen: false).taskList.where((element) => element.parentId != null).toList();

    if (delegatedTasks != null && delegatedTasks.length > 0) {
      List<int> delegatedTasksId = [];

      delegatedTasks.forEach((task) {
        delegatedTasksId.add(task.parentId);
      });

      await Provider.of<AttachmentProvider>(context, listen: false).getDelegatedAttachments(delegatedTasksId);
    }
  }
}
