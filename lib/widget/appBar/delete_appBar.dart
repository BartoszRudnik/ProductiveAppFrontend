import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:productive_app/config/color_themes.dart';
import 'package:productive_app/provider/synchronize_provider.dart';
import 'package:provider/provider.dart';

import '../../provider/location_provider.dart';
import '../../provider/task_provider.dart';

class DeleteAppBar extends StatefulWidget with PreferredSizeWidget {
  final String title;
  final IconButton leadingButton;

  DeleteAppBar({@required this.title, this.leadingButton});

  @override
  State<DeleteAppBar> createState() => _DeleteAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(50);
}

class _DeleteAppBarState extends State<DeleteAppBar> {
  bool _searchBarActive = false;
  final _formKey = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context) {
    String text = '';

    if (this.widget.title == AppLocalizations.of(context).completed) {
      text = AppLocalizations.of(context).completed;
    } else {
      text = AppLocalizations.of(context).trash;
    }

    final provider = Provider.of<TaskProvider>(context, listen: false);

    return AppBar(
      elevation: 0,
      title: this._searchBarActive
          ? TextFormField(
              autofocus: true,
              key: this._formKey,
              onChanged: (value) {
                if (this.widget.title == AppLocalizations.of(context).completed) {
                  provider.setCompletedName(value);
                } else {
                  provider.setTrashName(value);
                }
              },
              decoration: ColorThemes.searchFormFieldDecoration(
                context,
                text,
              ),
            )
          : Text(
              this.widget.title,
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
      leading: (widget.leadingButton != null) ? widget.leadingButton : null,
      actions: [
        IconButton(
          icon: Icon(this._searchBarActive ? Icons.close_outlined : Icons.search_outlined),
          onPressed: () {
            if (this._formKey != null && this._formKey.currentState != null) {
              this._formKey.currentState.reset();
            }

            if (this.widget.title == AppLocalizations.of(context).completed) {
              provider.clearCompletedName();
            } else {
              provider.clearTrashName();
            }

            setState(() {
              this._searchBarActive = !this._searchBarActive;
            });
          },
        ),
        PopupMenuButton(
          icon: Icon(Icons.more_vert_outlined),
          onSelected: (value) async {
            if (value == "restoreAll") {
              final tasks = this.widget.title == AppLocalizations.of(context).completed
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

              if (this.widget.title == AppLocalizations.of(context).completed) {
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
}
