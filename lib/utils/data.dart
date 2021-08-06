import 'package:flutter/widgets.dart';
import 'package:productive_app/provider/auth_provider.dart';
import 'package:productive_app/provider/delegate_provider.dart';
import 'package:productive_app/provider/location_provider.dart';
import 'package:productive_app/provider/settings_provider.dart';
import 'package:productive_app/provider/tag_provider.dart';
import 'package:productive_app/provider/task_provider.dart';
import 'package:provider/provider.dart';

class Data {
  static Future<void> loadData(BuildContext context) async {
    await Provider.of<TaskProvider>(context, listen: false).fetchTasks();
    await Provider.of<TaskProvider>(context, listen: false).getPriorities();
    await Provider.of<TagProvider>(context, listen: false).getTags();
    await Provider.of<LocationProvider>(context, listen: false).getLocations();
    await Provider.of<DelegateProvider>(context, listen: false).getCollaborators();
    await Provider.of<SettingsProvider>(context, listen: false).getFilterSettings();
    await Provider.of<AuthProvider>(context, listen: false).getUserData();
    await Provider.of<AuthProvider>(context, listen: false).checkIfAvatarExists();
  }
}
