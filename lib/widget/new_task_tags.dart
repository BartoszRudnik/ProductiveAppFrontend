import 'package:flutter/material.dart';

import '../model/tag.dart';
import 'dialog/tags_dialog.dart';

class NewTaskTags extends StatefulWidget {
  final Function setTags;
  List<Tag> finalTags;

  NewTaskTags({
    @required this.setTags,
    @required this.finalTags,
  });

  @override
  _NewTaskTagsState createState() => _NewTaskTagsState();
}

class _NewTaskTagsState extends State<NewTaskTags> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.tag,
      ),
      onPressed: () async {
        var newTags = await showDialog(
          context: context,
          builder: (context) {
            return TagsDialog(
              taskTags: this.widget.finalTags,
            );
          },
        );
        if (newTags != null) {
          if (newTags == 'cancel') {
            newTags = null;
          }

          this.widget.finalTags = newTags;
          this.widget.setTags(newTags);
        }
      },
    );
  }
}
