import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../model/tag.dart';
import '../../provider/tag_provider.dart';

class FilterTagsDialog extends StatelessWidget {
  final _tagKey = GlobalKey<FormState>();

  final List<String> alreadyChoosenTags;

  FilterTagsDialog({
    @required this.alreadyChoosenTags,
  });

  @override
  Widget build(BuildContext context) {
    List<Tag> tags = Provider.of<TagProvider>(context).tags;
    List<Tag> filteredTags = List<Tag>.from(tags);
    List<String> newTags = List<String>.from(this.alreadyChoosenTags);

    filteredTags.forEach(
      (element) {
        if (this.alreadyChoosenTags != null && this.alreadyChoosenTags.contains(element.name)) {
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
                          return AppLocalizations.of(context).tagEmptyName;
                        }
                        return null;
                      },
                      onSaved: (value) async {
                        final alreadyExists = tags.where((element) => element.name == value);
                        if (alreadyExists.isEmpty) {
                          try {
                            final uuid = Uuid();
                            await Provider.of<TagProvider>(context, listen: false).addTag(
                              Tag(
                                id: tags.length + 1,
                                name: value,
                                uuid: uuid.v1(),
                              ),
                            );
                          } catch (error) {
                            print(error);
                          }
                        }
                      },
                      maxLines: null,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        hintText: AppLocalizations.of(context).findOrAddTag,
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
                            if (!newTags.contains(filteredTags[tagIndex].name) && filteredTags[tagIndex].isSelected) {
                              newTags.add(filteredTags[tagIndex].name);
                            } else if (!filteredTags[tagIndex].isSelected) {
                              newTags.remove(filteredTags[tagIndex].name);
                            }
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
                      onPressed: () {
                        filteredTags.forEach((element) {
                          element.isSelected = false;
                        });
                        Navigator.of(context).pop('cancel');
                      },
                      child: Text(AppLocalizations.of(context).cancel),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        filteredTags.forEach((element) {
                          element.isSelected = false;
                        });
                        Navigator.of(context).pop(newTags);
                      },
                      child: Text(AppLocalizations.of(context).save),
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
