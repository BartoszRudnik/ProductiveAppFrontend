import 'package:flutter/material.dart';
import 'package:productive_app/task_page/models/tag.dart';
import 'package:productive_app/task_page/providers/tag_provider.dart';
import 'package:provider/provider.dart';

class NewTag extends StatelessWidget {
  int tagsLength;
  final _formKey = GlobalKey<FormState>();

  NewTag({
    @required this.tagsLength,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Form(
        key: this._formKey,
        child: ListTile(
          title: TextFormField(
            autofocus: true,
            key: ValueKey('TagName'),
            onSaved: (value) {
              Tag newTag = Tag(id: this.tagsLength + 1, name: value);
              Provider.of<TagProvider>(context, listen: false).addTag(newTag);
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
