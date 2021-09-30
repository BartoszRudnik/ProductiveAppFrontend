import 'package:flutter/material.dart';
import 'package:productive_app/config/const_values.dart';

class TaskLocalization extends StatefulWidget {
  final List<String> localizations;
  String localization;
  final Function setLocalization;

  TaskLocalization({
    @required this.localization,
    @required this.localizations,
    @required this.setLocalization,
  });

  @override
  _TaskLocalizationState createState() => _TaskLocalizationState();
}

class _TaskLocalizationState extends State<TaskLocalization> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      child: Row(
        children: [
          Icon(Icons.all_inbox),
          Text(ConstValues.stateName(this.widget.localization, context)),
        ],
      ),
      initialValue: this.widget.localization,
      onSelected: (value) {
        setState(() {
          this.widget.localization = value;
          this.widget.setLocalization(value);
        });
      },
      itemBuilder: (context) {
        return widget.localizations.map(
          (e) {
            return PopupMenuItem(
              child: Text(ConstValues.stateName(e, context)),
              value: e,
            );
          },
        ).toList();
      },
    );
  }
}
