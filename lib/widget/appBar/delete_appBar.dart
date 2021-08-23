import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../provider/location_provider.dart';
import '../../provider/task_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      backwardsCompatibility: false,
      iconTheme: Theme.of(context).iconTheme,
      brightness: Brightness.dark,
      leading: (leadingButton != null) ? leadingButton : null,
      actions: [
        PopupMenuButton(
          icon: Icon(Icons.more_vert_outlined),
          onSelected: (value) async {
            if (value == "restoreAll") {
              final tasks = this.title == AppLocalizations.of(context).completed ? Provider.of<TaskProvider>(context, listen: false).completedTasks : Provider.of<TaskProvider>(context, listen: false).trashTasks;

              tasks.forEach(
                (element) {
                  String newLocation;

                  if (element.delegatedEmail == null) {
                    if (element.startDate != null) {
                      newLocation = 'SCHEDULED';
                    } else {
                      newLocation = 'ANYTIME';
                    }
                  } else {
                    newLocation = 'DELEGATED';
                  }
                  if (element.notificationLocalizationId == null) {
                    Provider.of<TaskProvider>(context, listen: false).updateTask(element, newLocation);
                  } else {
                    final longitude = Provider.of<LocationProvider>(context, listen: false).getLongitude(element.notificationLocalizationId);
                    final latitude = Provider.of<LocationProvider>(context, listen: false).getLatitude(element.notificationLocalizationId);

                    Provider.of<TaskProvider>(context, listen: false).updateTaskWithGeolocation(element, newLocation, longitude, latitude);
                  }
                },
              );
            } else if (value == "deleteAll") {
              await Provider.of<TaskProvider>(context, listen: false).deleteAllTasks(this.title);
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
