import 'package:flutter/material.dart';
import 'package:productive_app/provider/delegate_provider.dart';
import 'package:provider/provider.dart';

class GrantAccessListTile extends StatefulWidget {
  final email;
  bool grantAccess;

  GrantAccessListTile({
    @required this.email,
    @required this.grantAccess,
  });

  @override
  _GrantAccessListTileState createState() => _GrantAccessListTileState();
}

class _GrantAccessListTileState extends State<GrantAccessListTile> {
  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      tileColor: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).primaryColorDark : Colors.black,
      activeColor: Theme.of(context).primaryColor,
      inactiveTrackColor: Theme.of(context).primaryColorLight,
      activeTrackColor: Theme.of(context).primaryColor,
      title: Text(
        'Grant access to my activity',
        style: TextStyle(color: Colors.white),
      ),
      value: this.widget.grantAccess,
      onChanged: (bool value) {
        setState(
          () {
            this.widget.grantAccess = value;
            Provider.of<DelegateProvider>(context, listen: false).changePermission(this.widget.email);
          },
        );
      },
    );
  }
}
