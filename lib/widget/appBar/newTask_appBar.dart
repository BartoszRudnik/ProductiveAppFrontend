import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:productive_app/config/color_themes.dart';
import 'package:productive_app/provider/settings_provider.dart';
import 'package:provider/provider.dart';
import '../../screen/filters_screen.dart';
import '../../screen/task_map.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:auto_size_text/auto_size_text.dart';

class NewTaskAppBar extends StatefulWidget with PreferredSizeWidget {
  final String title;
  final IconButton leadingButton;
  NewTaskAppBar({@required this.title, this.leadingButton});

  @override
  Size get preferredSize => Size.fromHeight(50);

  @override
  _NewTaskAppBarState createState() => _NewTaskAppBarState();
}

class _NewTaskAppBarState extends State<NewTaskAppBar> {
  final _formKey = GlobalKey<FormFieldState>();
  bool searchBarActive = false;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      title: this.searchBarActive
          ? TextFormField(
              autofocus: true,
              key: this._formKey,
              onChanged: (value) {
                Provider.of<SettingsProvider>(context, listen: false).setTaskName(value);
              },
              decoration: ColorThemes.searchFormFieldDecoration(
                context,
                AppLocalizations.of(context).enterTaskName,
                () {
                  this._formKey.currentState.reset();
                  Provider.of<SettingsProvider>(context, listen: false).clearTaskName();
                },
              ),
            )
          : AutoSizeText(
              this.widget.title,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
              minFontSize: 20,
              maxFontSize: 26,
              maxLines: 1,
            ),
      systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.black),
      backgroundColor: Theme.of(context).accentColor,
      iconTheme: Theme.of(context).iconTheme,
      backwardsCompatibility: false,
      brightness: Brightness.dark,
      leading: (widget.leadingButton != null) ? widget.leadingButton : null,
      actions: [
        IconButton(
          icon: Icon(Icons.search_outlined),
          onPressed: () {
            if (this.searchBarActive) {
              this._formKey.currentState.reset();
              Provider.of<SettingsProvider>(context, listen: false).clearTaskName();
            }

            setState(() {
              this.searchBarActive = !this.searchBarActive;
            });
          },
        ),
        PopupMenuButton(
          onSelected: (value) {
            if (value == 'filters') {
              Navigator.of(context).pushNamed(FiltersScreen.routeName);
            } else if (value == 'map') {
              Navigator.of(context).pushNamed(TaskMap.routeName);
            }
          },
          icon: Icon(Icons.more_vert),
          itemBuilder: (_) => [
            PopupMenuItem(
              child: Text(AppLocalizations.of(context).filters),
              value: 'filters',
            ),
            PopupMenuItem(
              child: Text(AppLocalizations.of(context).taskMap),
              value: 'map',
            ),
          ],
        ),
      ],
    );
  }
}
