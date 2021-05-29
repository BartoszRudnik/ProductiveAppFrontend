import 'package:flutter/material.dart';

import '../models/tag.dart';
import 'tags_dialog.dart';

class NewTaskTags extends StatefulWidget {
  final Function setTags;
  final List<Tag> finalTags;

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
        final newTags = await showDialog(
            context: context,
            builder: (context) {
              return TagsDialog(UniqueKey(), this.widget.finalTags);
            });
        this.widget.setTags(newTags);
      },
    );
  }
}
