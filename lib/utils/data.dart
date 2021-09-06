import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:productive_app/db/collaborator_database.dart';
import 'package:productive_app/db/graphic_database.dart';
import 'package:productive_app/db/locale_database.dart';
import 'package:productive_app/db/location_database.dart';
import 'package:productive_app/db/settings_database.dart';
import 'package:productive_app/db/tag_database.dart';
import 'package:productive_app/db/task_database.dart';
import 'package:productive_app/db/user_database.dart';
import 'package:productive_app/model/collaborator.dart';
import 'package:productive_app/model/location.dart';
import 'package:productive_app/model/settings.dart';
import 'package:productive_app/model/tag.dart';
import 'package:productive_app/model/user.dart';
import 'package:productive_app/provider/locale_provider.dart';
import 'package:productive_app/provider/synchronize_provider.dart';
import 'package:productive_app/provider/theme_provider.dart';
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
  static Future<void> synchronizeData(BuildContext context) async {
    try {
      List<Tag> tags = [];
      List<Collaborator> collaborators = [];
      List<Location> locations = [];
      List<String> locale = [];
      List<String> graphic = [];
      User user;
      Settings settings;
      List<Task> tasks = [];

      final provider = Provider.of<SynchronizeProvider>(context, listen: false);
      final userEmail = Provider.of<AuthProvider>(context, listen: false).email;

      await Future.wait([
        TagDatabase.readAll(userEmail).then((value) => tags = value),
        CollaboratorDatabase.readAll(userEmail).then((value) => collaborators = value),
        LocationDatabase.readAll(userEmail).then((value) => locations = value),
        LocaleDatabase.read(userEmail).then((value) => locale = value),
        GraphicDatabase.read(userEmail).then((value) => graphic = value),
        UserDatabase.read(userEmail).then((value) => user = value),
        SettingsDatabase.read(userEmail).then((value) => settings = value),
        TaskDatabase.readAll(context, userEmail).then((value) => tasks = value),
      ]);

      await Future.wait([
        provider.synchronizeTags(tags),
        provider.synchronizeCollaborators(collaborators),
        provider.synchronizeLocations(locations),
        provider.synchronizeLocale(locale),
        provider.synchronizeGraphic(graphic),
        provider.synchronizeUser(user),
        provider.synchronizeSettings(settings),
        provider.synchronizeTasks(tasks),
      ]);
    } catch (error) {
      print(error);
    }
  }

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
          Provider.of<LocaleProvider>(context, listen: false).getLocale(),
          Provider.of<ThemeProvider>(context, listen: false).getUserMode(),
          Provider.of<AuthProvider>(context, listen: false).getUserImage(),
        ],
      );
    } catch (error) {
      print(error);
    }

    final List<Task> delegatedTasks =
        Provider.of<TaskProvider>(context, listen: false).taskList.where((element) => element.parentId != null).toList();

    if (delegatedTasks != null && delegatedTasks.length > 0) {
      List<int> delegatedTasksId = [];

      delegatedTasks.forEach((task) {
        delegatedTasksId.add(task.parentId);
      });

      await Provider.of<AttachmentProvider>(context, listen: false).getDelegatedAttachments(delegatedTasksId);
    }
  }
}
