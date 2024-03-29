import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../model/task.dart';
import '../../screen/related_task_info_screen.dart';

class DetailsAppBar extends StatefulWidget with PreferredSizeWidget {
  final String title;
  final IconButton leadingButton;
  final Task task;
  DetailsAppBar({
    @required this.title,
    this.leadingButton,
    @required this.task,
  });

  @override
  Size get preferredSize => Size.fromHeight(50);

  @override
  _DetailsAppBarState createState() => _DetailsAppBarState();
}

class _DetailsAppBarState extends State<DetailsAppBar> {
  @override
  Widget build(BuildContext context) {
    if (this.widget.task != null && this.widget.task.isDelegated == null) {
      this.widget.task.isDelegated = false;
    }
    return AppBar(
      elevation: 0,
      title: Text(
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
      backwardsCompatibility: false,
      leading: (widget.leadingButton != null) ? widget.leadingButton : null,
      actions: <Widget>[
        if (this.widget.task != null && (this.widget.task.childUuid != null || this.widget.task.isDelegated))
          PopupMenuButton(
            onSelected: (value) {
              if (value == 'related') {
                Navigator.of(context).pushNamed(RelatedTaskInfoScreen.routeName,
                    arguments: this.widget.task != null && this.widget.task.childUuid != null ? this.widget.task.childUuid : this.widget.task.parentUuid);
              }
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (this.widget.task != null && (this.widget.task.childUuid != null || this.widget.task.isDelegated))
                ? (_) => [
                      PopupMenuItem(
                        child: Text(AppLocalizations.of(context).relatedTask),
                        value: 'related',
                      ),
                    ]
                : (_) => [],
          ),
      ],
    );
  }
}
