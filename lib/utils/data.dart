import 'package:flutter/widgets.dart';
import '../provider/auth_provider.dart';
import '../provider/delegate_provider.dart';
import '../provider/location_provider.dart';
import '../provider/settings_provider.dart';
import '../provider/tag_provider.dart';
import '../provider/task_provider.dart';
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
