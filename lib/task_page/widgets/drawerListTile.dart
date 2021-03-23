import 'package:flutter/material.dart';

class DrawerListTile extends StatelessWidget {
  final IconData icon;
  final String title;

  DrawerListTile({
    @required this.icon,
    @required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minLeadingWidth: 16,
      contentPadding: EdgeInsets.symmetric(horizontal: 0),
      leading: Icon(this.icon),
      title: Text(this.title),
      onTap: () {},
    );
  }
}
