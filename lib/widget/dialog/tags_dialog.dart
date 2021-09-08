import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:productive_app/model/tag.dart';
import 'package:productive_app/provider/tag_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class TagsDialog extends StatefulWidget {
  static const routeName = "/tags-dialog";
  final List<Tag> taskTags;

  TagsDialog({
    @required this.taskTags,
  });

  @override
  _TagsDialogState createState() => _TagsDialogState();
}

class _TagsDialogState extends State<TagsDialog> {
  final _tKey = GlobalKey<FormState>();
  List<Tag> _finalTags = [];
  List<Tag> tags;
  List<Tag> filteredTags;
  List<Tag> taskTags;

  @override
  void initState() {
    initValues();
    super.initState();
  }

  void organizeFinalList(int index) {
    setState(() {
      filteredTags[index].isSelected = !filteredTags[index].isSelected;
      Tag tagInList = _finalTags.firstWhere((element) => element.name == filteredTags[index].name, orElse: () => null);
      if (filteredTags[index].isSelected && tagInList == null) {
        _finalTags.add(filteredTags[index]);
      } else {
        _finalTags.remove(tagInList);
      }
    });
  }

  void initValues() {
    tags = Provider.of<TagProvider>(context, listen: false).tags;
    filteredTags = List<Tag>.from(tags);

    filteredTags.forEach((element) {
      element.isSelected = false;
    });

    if (this.widget.taskTags != null) {
      _finalTags = List<Tag>.from(this.widget.taskTags);

      this.widget.taskTags.forEach((element) {
        element.isSelected = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                key: _tKey,
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
                  onSaved: (value) {
                    setState(() {
                      final uuid = Uuid();
                      final newTag = Tag(
                        id: (tags.length + 1),
                        name: value,
                        uuid: uuid.v1(),
                      );
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
                    hintText: AppLocalizations.of(context).enterTagName,
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
                  final isValid = _tKey.currentState.validate();
                  if (isValid) {
                    _tKey.currentState.save();
                    _tKey.currentState.reset();
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
                    onTap: () => organizeFinalList(tagIndex),
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
                    if (this.widget.taskTags == null) {
                      Navigator.of(context).pop('cancel');
                    } else {
                      Navigator.of(context).pop(this.widget.taskTags);
                    }
                  },
                  child: Text(AppLocalizations.of(context).cancel),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_finalTags == null) {
                      Navigator.of(context).pop('cancel');
                    } else {
                      Navigator.of(context).pop(_finalTags);
                    }
                  },
                  child: Text(AppLocalizations.of(context).save),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
