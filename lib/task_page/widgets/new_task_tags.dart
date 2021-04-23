import 'package:flutter/material.dart';
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
    final tags = Provider.of<TagProvider>(context).tags;
    List<Tag> filteredTags = Provider.of<TagProvider>(context).tags;

    return IconButton(
      icon: Icon(
        Icons.tag,
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  content: Container(
                    height: 350,
                    width: 300,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          horizontalTitleGap: 6,
                          title: Form(
                            key: this._tagKey,
                            child: TextFormField(
                              onChanged: (value) {
                                setState(() {
                                  filteredTags = tags.where((element) => element.name.toLowerCase().contains(value.toLowerCase())).toList();
                                });
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'tag name cannot be empty';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                setState(() {
                                  final newTag = Tag(id: (tags.length + 1), name: value);
                                  final alreadyExists = tags.where((element) => element.name == newTag.name);
                                  if (alreadyExists.isEmpty) {
                                    Provider.of<TagProvider>(context, listen: false).addTag(newTag);
                                    tags.insert(0, newTag);
                                  }
                                });
                              },
                              maxLines: null,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(10),
                                hintText: 'Find or create new tag',
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
                              final isValid = this._tagKey.currentState.validate();
                              if (isValid) {
                                this._tagKey.currentState.save();
                                this._tagKey.currentState.reset();
                                filteredTags = tags;
                              }
                            },
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            padding: EdgeInsets.all(10),
                            itemCount: filteredTags.length,
                            itemBuilder: (ctx, tagIndex) {
                              return GestureDetector(
                                onTap: () => setState(() {
                                  filteredTags[tagIndex].isSelected = !filteredTags[tagIndex].isSelected;
                                  if (filteredTags[tagIndex].isSelected) {
                                    this.widget.finalTags.add(filteredTags[tagIndex]);
                                  } else {
                                    this.widget.finalTags.remove(filteredTags[tagIndex]);
                                  }
                                }),
                                child: Card(
                                  color: filteredTags[tagIndex].isSelected ? Theme.of(context).primaryColor : Theme.of(context).accentColor,
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Text(
                                      filteredTags[tagIndex].name,
                                      style: TextStyle(
                                        color: filteredTags[tagIndex].isSelected ? Theme.of(context).accentColor : Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).primaryColor,
                                side: BorderSide(color: Theme.of(context).primaryColor),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).accentColor,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).primaryColor,
                                side: BorderSide(color: Theme.of(context).primaryColor),
                              ),
                              onPressed: () {
                                this.widget.setTags(this.widget.finalTags);
                                Navigator.of(context).pop(true);
                              },
                              child: Text(
                                'Add tag/tags',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).accentColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
