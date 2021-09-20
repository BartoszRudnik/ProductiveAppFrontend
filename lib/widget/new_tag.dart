import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:productive_app/model/tag.dart';
import 'package:productive_app/provider/settings_provider.dart';
import 'package:productive_app/provider/tag_provider.dart';
import 'package:productive_app/provider/task_provider.dart';
import 'package:productive_app/utils/dialogs.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class NewTag extends StatefulWidget {
  final int tagsLength;
  String initialValue;
  final bool editMode;
  final int tagId;

  NewTag({
    @required this.tagsLength,
    this.editMode,
    this.initialValue,
    this.tagId,
  });

  @override
  State<StatefulWidget> createState() => _NewTagState();
}

class _NewTagState extends State<NewTag> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Form(
        key: this._formKey,
        child: ListTile(
          title: TextFormField(
            initialValue: this.widget.editMode ? this.widget.initialValue : '',
            autofocus: true,
            key: ValueKey('TagName'),
            onSaved: (value) {
              if (!this.widget.editMode) {
                final uuid = Uuid();

                Tag newTag = Tag(
                  id: this.widget.tagsLength + 1,
                  name: value,
                  uuid: uuid.v1(),
                );

                if (!Provider.of<TagProvider>(context, listen: false).tagNames.contains(newTag.name)) {
                  Provider.of<TagProvider>(context, listen: false).addTag(newTag);
                } else {
                  Dialogs.showWarningDialog(context, AppLocalizations.of(context).tagAlreadyExist);
                }
              } else {
                Provider.of<TagProvider>(context, listen: false).updateTag(value, widget.initialValue);
                Provider.of<TaskProvider>(context, listen: false).editTag(widget.initialValue, value);
                Provider.of<SettingsProvider>(context, listen: false).editTag(this.widget.initialValue, value);
                Navigator.of(context).pop();
              }
            },
            maxLines: null,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context).enterTagName,
              hintStyle: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 20,
              ),
            ),
          ),
          trailing: FloatingActionButton(
            mini: true,
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              this._formKey.currentState.save();
              this._formKey.currentState.reset();
            },
          ),
        ),
      ),
    );
  }
}
