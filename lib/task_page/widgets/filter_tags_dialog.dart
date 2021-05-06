import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/tag.dart';
import '../providers/delegate_provider.dart';
import '../providers/tag_provider.dart';

class FilterTagsDialog extends StatelessWidget {
  final _tagKey = GlobalKey<FormState>();

  List<String> choosenTags = [];

  FilterTagsDialog({
    this.choosenTags,
  });

  @override
  Widget build(BuildContext context) {
    List<Tag> tags = Provider.of<TagProvider>(context).tags;
    List<Tag> filteredTags = List<Tag>.from(tags);

    filteredTags.forEach(
      (element) {
        if (this.choosenTags != null && this.choosenTags.contains(element.name)) {
          element.isSelected = true;
        } else {
          element.isSelected = false;
        }
      },
    );

    return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          content: Container(
            height: 350,
            width: 350,
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
                      onSaved: (value) async {
                        final alreadyExists = tags.where((element) => element.name == value);
                        if (alreadyExists.isEmpty) {
                          try {
                            await Provider.of<TagProvider>(context, listen: false).addTag(Tag(id: tags.length + 1, name: value));
                          } catch (error) {
                            print(error);
                          }
                        }
                      },
                      maxLines: null,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        hintText: 'Find or add new tag',
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
                        onTap: () {
                          setState(() {
                            filteredTags[tagIndex].isSelected = !filteredTags[tagIndex].isSelected;
                            this.choosenTags.add(filteredTags[tagIndex].name);
                          });
                        },
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
                        filteredTags.forEach((element) {
                          element.isSelected = false;
                        });
                        Navigator.of(context).pop();
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
                        filteredTags.forEach((element) {
                          element.isSelected = false;
                        });
                        Navigator.of(context).pop(this.choosenTags);
                      },
                      child: Text(
                        'Save',
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
  }
}
