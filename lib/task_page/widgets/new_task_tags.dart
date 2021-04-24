import 'package:flutter/material.dart';
import 'package:productive_app/task_page/widgets/tags_dialog.dart';
import 'package:provider/provider.dart';

import '../models/tag.dart';
import '../providers/tag_provider.dart';

class NewTaskTags extends StatefulWidget {
  Function setTags;
  List<Tag> finalTags;

  NewTaskTags({
    @required this.setTags,
    @required this.finalTags,
  });

  @override
  _NewTaskTagsState createState() => _NewTaskTagsState();
}

class _NewTaskTagsState extends State<NewTaskTags> {
  final _tagKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    List<Tag> finalTags;

    return IconButton(
      icon: Icon(
        Icons.tag,
      ),
      onPressed: () async{
        finalTags = await showDialog(
          context: context,
          builder: (context){
            return TagsDialog(UniqueKey(), []); 
          } 
        );
        this.widget.setTags(finalTags);
      },
    );
  }
}
