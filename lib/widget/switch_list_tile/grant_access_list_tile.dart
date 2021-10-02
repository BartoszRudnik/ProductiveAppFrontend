import 'package:flutter/material.dart';
import 'package:productive_app/provider/delegate_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GrantAccessListTile extends StatefulWidget {
  final email;
  final uuid;
  bool grantAccess;

  GrantAccessListTile({
    @required this.uuid,
    @required this.email,
    @required this.grantAccess,
  });

  @override
  _GrantAccessListTileState createState() => _GrantAccessListTileState();
}

class _GrantAccessListTileState extends State<GrantAccessListTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).floatingActionButtonTheme.backgroundColor : Theme.of(context).primaryColor,
        border: Border.all(
          color: Theme.of(context).primaryColor,
        ),
      ),
      child: SwitchListTile(
        tileColor: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).primaryColorDark : Colors.black,
        activeColor: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).primaryColor : Theme.of(context).primaryColorDark,
        inactiveTrackColor: Theme.of(context).primaryColorLight,
        activeTrackColor: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).primaryColor : Theme.of(context).accentColor,
        title: Text(
          AppLocalizations.of(context).grantActivityAccess,
          style: TextStyle(color: Colors.white),
        ),
        value: this.widget.grantAccess,
        onChanged: (bool value) {
          setState(
            () {
              this.widget.grantAccess = value;
              Provider.of<DelegateProvider>(context, listen: false).changePermission(this.widget.email, this.widget.uuid);
            },
          );
        },
      ),
    );
  }
}
