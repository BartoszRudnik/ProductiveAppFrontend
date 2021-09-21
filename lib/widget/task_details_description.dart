import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:productive_app/config/color_themes.dart';

class TaskDetailsDescription extends StatelessWidget {
  final String description;
  final descriptionFocus;
  final isDescriptionInitial;
  final isFocused;
  final Function onDescriptionChanged;

  TaskDetailsDescription({
    @required this.description,
    @required this.descriptionFocus,
    @required this.isDescriptionInitial,
    @required this.isFocused,
    @required this.onDescriptionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          minLeadingWidth: 16,
          contentPadding: EdgeInsets.symmetric(horizontal: 0),
          leading: Icon(Icons.edit),
          title: Align(
            alignment: Alignment(-1.1, 0),
            child: Text(
              AppLocalizations.of(context).description,
              style: TextStyle(fontSize: 21),
            ),
          ),
        ),
        TextFormField(
          initialValue: this.description,
          maxLines: null,
          focusNode: this.descriptionFocus,
          onSaved: (value) {
            this.onDescriptionChanged(value);
          },
          style: TextStyle(fontSize: 16),
          textAlign: this.isDescriptionInitial ? TextAlign.center : TextAlign.left,
          decoration: ColorThemes.taskDetailsFieldDecoration(this.isFocused, this.description, context),
        ),
      ],
    );
  }
}
