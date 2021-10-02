import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:productive_app/db/attachment_database.dart';
import 'package:productive_app/db/collaborator_database.dart';
import 'package:productive_app/db/graphic_database.dart';
import 'package:productive_app/db/locale_database.dart';
import 'package:productive_app/db/location_database.dart';
import 'package:productive_app/db/settings_database.dart';
import 'package:productive_app/db/tag_database.dart';
import 'package:productive_app/db/task_database.dart';
import 'package:productive_app/db/user_database.dart';
import 'package:productive_app/model/attachment.dart';
import 'package:productive_app/model/collaborator.dart';
import 'package:productive_app/model/location.dart';
import 'package:productive_app/model/settings.dart';
import 'package:productive_app/model/tag.dart';
import 'package:productive_app/model/user.dart';
import 'package:productive_app/provider/locale_provider.dart';
import 'package:productive_app/provider/synchronize_provider.dart';
import 'package:productive_app/provider/tag_provider.dart';
import 'package:productive_app/provider/theme_provider.dart';
import 'package:provider/provider.dart';

import '../model/task.dart';
import '../provider/attachment_provider.dart';
import '../provider/auth_provider.dart';
import '../provider/delegate_provider.dart';
import '../provider/location_provider.dart';
import '../provider/settings_provider.dart';
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
      List<Attachment> attachments = [];

      final provider = Provider.of<SynchronizeProvider>(context, listen: false);
      final userEmail = Provider.of<AuthProvider>(context, listen: false).email;

      await Future.wait(
        [
          TagDatabase.readAll(userEmail).then((value) => tags = value),
          CollaboratorDatabase.readAll(userEmail).then((value) => collaborators = value),
          LocationDatabase.readAll(userEmail).then((value) => locations = value),
          LocaleDatabase.read(userEmail).then((value) => locale = value),
          GraphicDatabase.read(userEmail).then((value) => graphic = value),
          UserDatabase.read(userEmail).then((value) => user = value),
          SettingsDatabase.read(userEmail).then((value) => settings = value),
          AttachmentDatabase.readAllNotSynchronized(userEmail).then((value) => attachments = value),
        ],
      );

      await TaskDatabase.readAll(tags, userEmail).then((value) => tasks = value);

      await Future.wait(
        [
          provider.synchronizeTags(tags),
          provider.synchronizeCollaborators(collaborators),
          provider.synchronizeLocations(locations),
          provider.synchronizeLocale(locale),
          provider.synchronizeGraphic(graphic),
          provider.synchronizeUser(user),
          provider.synchronizeSettings(settings),
          provider.synchronizeTasks(tasks, attachments),
        ],
      );
    } catch (error) {
      print(error);
    }
  }

  static void notify(BuildContext context) {
    Provider.of<TagProvider>(context, listen: false).notify();
    Provider.of<TaskProvider>(context, listen: false).notify();
    Provider.of<SettingsProvider>(context, listen: false).notify();
    Provider.of<DelegateProvider>(context, listen: false).notify();
    Provider.of<LocationProvider>(context, listen: false).notify();
    Provider.of<AttachmentProvider>(context, listen: false).notify();
  }

  static Future<void> loadDataOffline(BuildContext context) async {
    try {
      final tags = await Provider.of<TagProvider>(context, listen: false).getTagsOffline();

      await Future.wait(
        [
          Provider.of<TaskProvider>(context, listen: false).fetchTasksOffline(tags),
          Provider.of<TaskProvider>(context, listen: false).getPriorities(),
          Provider.of<LocationProvider>(context, listen: false).getLocationsOffline(),
          Provider.of<ThemeProvider>(context, listen: false).getUserModeOffline(),
          Provider.of<DelegateProvider>(context, listen: false).getCollaboratorsOffline(),
          Provider.of<SettingsProvider>(context, listen: false).getFilterSettingsOffline(),
          Provider.of<AttachmentProvider>(context, listen: false).getAttachmentsOffline(),
          Provider.of<AuthProvider>(context, listen: false).getUserDataOffline(),
          Provider.of<AuthProvider>(context, listen: false).checkIfAvatarExistsOffline(),
          Provider.of<AuthProvider>(context, listen: false).getUserImageOffline(),
          Provider.of<TagProvider>(context, listen: false).getTagsOffline(),
        ],
      );

      await Provider.of<LocaleProvider>(context, listen: false).getLocaleOffline();
    } catch (error) {
      print(error);
    }
  }

  static Future<void> loadData(BuildContext context) async {
    try {
      await Future.wait(
        [
          Provider.of<TagProvider>(context, listen: false).getTags(),
          Provider.of<TaskProvider>(context, listen: false).fetchTasks(),
          Provider.of<TaskProvider>(context, listen: false).getPriorities(),
          Provider.of<LocationProvider>(context, listen: false).getLocations(),
          Provider.of<DelegateProvider>(context, listen: false).getCollaborators(),
          Provider.of<SettingsProvider>(context, listen: false).getFilterSettings(),
          Provider.of<AuthProvider>(context, listen: false).getUserData(),
          Provider.of<AuthProvider>(context, listen: false).checkIfAvatarExists(),
          Provider.of<AttachmentProvider>(context, listen: false).getAttachments(),
          Provider.of<AuthProvider>(context, listen: false).getUserImage(),
          Provider.of<LocaleProvider>(context, listen: false).getLocale(),
          Provider.of<ThemeProvider>(context, listen: false).getUserMode(),
        ],
      );

      final List<String> delegatedTasks = Provider.of<TaskProvider>(context, listen: false).delegatedTasksUuid;

      if (delegatedTasks != null && delegatedTasks.length > 0) {
        await Provider.of<AttachmentProvider>(context, listen: false).getAllDelegatedAttachments(delegatedTasks);
      }
    } catch (error) {
      print(error);
    }
  }
}
