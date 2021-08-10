import 'package:flutter/material.dart';
import 'package:productive_app/screen/loading_task_screen.dart';
import 'package:provider/provider.dart';
import '../model/task.dart';
import '../provider/location_provider.dart';
import '../provider/task_provider.dart';
import '../provider/theme_provider.dart';
import '../utils/data.dart';
import '../utils/notifications.dart';
import '../widget/drawer/main_drawer.dart';
import 'loading_auth_screen.dart';
import 'tabs_screen.dart';
import 'task_details_screen.dart';

class MainScreen extends StatefulWidget {
  static const routeName = '/main-screen';

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  void onClickedNotification(String payload) async {
    Task task = Provider.of<TaskProvider>(context, listen: false).taskList.firstWhere((element) => element.id == int.parse(payload), orElse: () => null);

    if (task == null) {
      await Provider.of<LocationProvider>(context, listen: false).getLocations();
      await Provider.of<TaskProvider>(context, listen: false).fetchSingleTaskFull(int.parse(payload));

      task = Provider.of<TaskProvider>(context, listen: false).taskList.firstWhere((element) => element.id == int.parse(payload));
    }

    Navigator.of(context).pushNamed(TaskDetailScreen.routeName, arguments: task);
  }

  void listenNotifications() => Notifications.onNotifications.stream.listen(onClickedNotification);

  Future<void> future;

  @override
  void initState() {
    future = Data.loadData(context);
    Provider.of<ThemeProvider>(context, listen: false).getUserMode();

    Notifications.initLocalization();
    Notifications.initNotification();
    listenNotifications();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: this.future,
      builder: (ctx, loadResult) => loadResult.connectionState == ConnectionState.waiting
          ? LoadingTaskScreen()
          : Scaffold(
              body: Stack(
                children: [
                  MainDrawer(),
                  TabsScreen(),
                ],
              ),
            ),
    );
  }
}
