import 'package:flutter/material.dart';
import 'package:productive_app/task_page/models/tag.dart';
import 'package:productive_app/task_page/providers/tag_provider.dart';
import 'package:productive_app/task_page/providers/task_provider.dart';
import 'package:provider/provider.dart';

class NewTag extends StatefulWidget {
  int tagsLength;
  String initialValue;
  bool editMode;

  NewTag({
    @required this.tagsLength,
    this.editMode,
    this.initialValue,
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
            initialValue: widget.editMode ? widget.initialValue : ' ',
            autofocus: true,
            key: ValueKey('TagName'),
            onSaved: (value) {
              if (!widget.editMode) {
                Tag newTag = Tag(id: widget.tagsLength + 1, name: value);
                Provider.of<TagProvider>(context, listen: false).addTag(newTag);
              } else {
                Provider.of<TagProvider>(context, listen: false).updateTag(value, widget.initialValue);
                Provider.of<TaskProvider>(context, listen: false).editTag(widget.initialValue, value);
                Navigator.of(context).pop();
              }
            },
            maxLines: null,
            decoration: InputDecoration(
              hintText: 'Enter tag name',
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
              color: Theme.of(context).accentColor,
              size: 30,
            ),
            onPressed: () {
              this._formKey.currentState.save();
              this._formKey.currentState.reset();
            },
            backgroundColor: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}
