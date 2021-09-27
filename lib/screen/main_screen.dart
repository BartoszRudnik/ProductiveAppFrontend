import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:productive_app/provider/delegate_provider.dart';
import 'package:productive_app/screen/collaborators_screen.dart';
import 'package:productive_app/utils/internet_connection.dart';
import 'package:provider/provider.dart';

import '../model/task.dart';
import '../provider/location_provider.dart';
import '../provider/task_provider.dart';
import '../utils/data.dart';
import '../utils/notifications.dart';
import '../widget/drawer/main_drawer.dart';
import 'loading_task_screen.dart';
import 'tabs_screen.dart';
import 'task_details_screen.dart';

class MainScreen extends StatefulWidget {
  static const routeName = '/main-screen';

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  void onClickedNotification(String payload) async {
    if (payload == "collaborator") {
      Navigator.of(context).pushNamed(CollaboratorsScreen.routeName);
    } else {
      Task task = Provider.of<TaskProvider>(context, listen: false).taskList.firstWhere((element) => element.uuid == payload, orElse: () => null);

      if (task == null) {
        await Provider.of<LocationProvider>(context, listen: false).getLocations();
        await Provider.of<TaskProvider>(context, listen: false).fetchSingleTaskFull(payload, context);

        task = Provider.of<TaskProvider>(context, listen: false).taskList.firstWhere((element) => element.uuid == payload);
      }

      if (task != null && task.title != null) {
        Navigator.of(context).pushNamed(TaskDetailScreen.routeName, arguments: task);
      }
    }
  }

  void listenNotifications() => Notifications.onNotifications.stream.listen(onClickedNotification);

  void listenInternetChanges(BuildContext ctx) => Connectivity().onConnectivityChanged.listen((connectionResult) async {
        if (checkInternetConnection(connectionResult)) {
          await this.loadData(ctx);
        }
      });

  bool checkInternetConnection(ConnectivityResult result) {
    return result != ConnectivityResult.none;
  }

  Future<void> loadData(BuildContext context) async {
    if (await InternetConnection.internetConnection()) {
      await Data.synchronizeData(context);
      await Data.loadData(context);
    } else {
      await Data.loadDataOffline(context);
    }
  }

  Future future;

  @override
  void initState() {
    super.initState();

    Provider.of<DelegateProvider>(context, listen: false).subscribe(context);
    Provider.of<DelegateProvider>(context, listen: false).subscribeCollaborators(context);

    this.future = this.loadData(context);

    Notifications.initLocalization();
    Notifications.initNotification();

    listenNotifications();
    listenInternetChanges(context);

    WidgetsBinding.instance.addPostFrameCallback((_) => Data.notify(context));
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
