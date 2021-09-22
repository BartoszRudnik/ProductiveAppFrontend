import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:productive_app/provider/synchronize_provider.dart';
import 'package:provider/provider.dart';

import '../../provider/location_provider.dart';
import '../../provider/task_provider.dart';

class DeleteAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;
  final IconButton leadingButton;

  DeleteAppBar({@required this.title, this.leadingButton});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      title: Text(
        this.title,
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w400,
          color: Theme.of(context).primaryColor,
        ),
      ),
      systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.black),
      backgroundColor: Theme.of(context).accentColor,
      iconTheme: Theme.of(context).iconTheme,
      brightness: Brightness.dark,
      leading: (leadingButton != null) ? leadingButton : null,
      actions: [
        PopupMenuButton(
          icon: Icon(Icons.more_vert_outlined),
          onSelected: (value) async {
            if (value == "restoreAll") {
              final tasks = this.title == AppLocalizations.of(context).completed
                  ? Provider.of<TaskProvider>(context, listen: false).completedTasks
                  : Provider.of<TaskProvider>(context, listen: false).trashTasks;

              tasks.forEach(
                (element) {
                  String newLocation;

                  element.taskState = "PLAN&DO";
                  element.done = false;

                  if (element.delegatedEmail == null) {
                    if (element.startDate != null) {
                      newLocation = 'SCHEDULED';
                    } else {
                      newLocation = 'ANYTIME';
                    }
                  } else {
                    newLocation = 'DELEGATED';
                  }
                  if (element.notificationLocalizationUuid == null) {
                    Provider.of<TaskProvider>(context, listen: false).updateTask(element, newLocation);
                  } else {
                    final longitude = Provider.of<LocationProvider>(context, listen: false).getLongitude(element.notificationLocalizationUuid);
                    final latitude = Provider.of<LocationProvider>(context, listen: false).getLatitude(element.notificationLocalizationUuid);

                    Provider.of<TaskProvider>(context, listen: false).updateTaskWithGeolocation(element, newLocation, longitude, latitude);
                  }
                },
              );
            } else if (value == "deleteAll") {
              String listName;

              if (this.title == AppLocalizations.of(context).completed) {
                listName = 'Completed';

                final completedTasks = Provider.of<TaskProvider>(context, listen: false).completedTasks;

                completedTasks.forEach((element) {
                  Provider.of<SynchronizeProvider>(context, listen: false).addTaskToDelete(element.uuid);
                });
              } else {
                listName = 'Trash';

                final trashTasks = Provider.of<TaskProvider>(context, listen: false).trashTasks;

                trashTasks.forEach((element) {
                  Provider.of<SynchronizeProvider>(context, listen: false).addTaskToDelete(element.uuid);
                });
              }

              await Provider.of<TaskProvider>(context, listen: false).deleteAllTasks(listName);
            }
          },
          itemBuilder: (_) => [
            PopupMenuItem(
              child: Text(AppLocalizations.of(context).restoreAll),
              value: 'restoreAll',
            ),
            PopupMenuItem(
              child: Text(AppLocalizations.of(context).deleteAll),
              value: 'deleteAll',
            ),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(50);
}
