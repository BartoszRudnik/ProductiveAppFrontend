import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/tag.dart';
import '../models/task.dart';
import '../providers/tag_provider.dart';
import '../providers/task_provider.dart';

class NewTask extends StatefulWidget {
  String localization;

  NewTask({
    @required this.localization,
  });

  @override
  _NewTaskState createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTask> {
  var _isFullScreen = false;
  var _isValid = true;

  final _formKey = GlobalKey<FormState>();
  final _tagKey = GlobalKey<FormState>();

  String _localization;
  String _priority = 'NORMAL';
  String _taskName = '';
  String _taskDescription = '';
  DateTime _startDate;
  DateTime _endDate;
  bool _isDone = false;
  List<Tag> _finalTags = [];

  DateTime _startInitialValue = DateTime.now();
  DateTime _endInitialValue = DateTime.now();

  @override
  void initState() {
    super.initState();
    this._localization = this.widget.localization;
  }

  Future<void> _addNewTask() async {
    var isValid = this._formKey.currentState.validate();

    setState(() {
      this._isValid = isValid;
    });

    if (!this._isValid) {
      return;
    }

    this._formKey.currentState.save();

    final newTask = Task(
      id: null,
      title: this._taskName,
      startDate: this._startDate,
      endDate: this._endDate,
      done: this._isDone,
      priority: this._priority,
      tags: this._finalTags,
      description: this._taskDescription,
      localization: this._localization,
    );

    try {
      await Provider.of<TaskProvider>(context, listen: false).addTask(newTask);

      this._formKey.currentState.reset();
      setState(() {
        this._startInitialValue = DateTime.now();
        this._endInitialValue = DateTime.now();
        this._localization = this.widget.localization;
        this._isDone = false;
        this._finalTags.forEach((element) {
          element.isSelected = false;
        });
        this._finalTags = [];
      });
    } catch (error) {
      print(error);
      throw error;
    }
  }

  @override
  Widget build(BuildContext context) {
    final priorities = Provider.of<TaskProvider>(context, listen: false).priorities;
    final localizations = Provider.of<TaskProvider>(context, listen: false).localizations;

    final tags = Provider.of<TagProvider>(context).tags;
    List<Tag> filteredTags = Provider.of<TagProvider>(context).tags;

    return LayoutBuilder(
      builder: (context, constraint) {
        return SingleChildScrollView(
          child: Container(
            height: this._isFullScreen ? MediaQuery.of(context).size.height - 25 : null,
            padding: EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Form(
              key: this._formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    isThreeLine: true,
                    horizontalTitleGap: 5,
                    minLeadingWidth: 20,
                    contentPadding: EdgeInsets.all(0),
                    leading: RawMaterialButton(
                      fillColor: this._isDone ? Colors.grey : Theme.of(context).accentColor,
                      focusElevation: 0,
                      child: this._isDone
                          ? Icon(
                              Icons.done,
                              color: Colors.white,
                              size: 14,
                            )
                          : null,
                      onPressed: () {
                        setState(() {
                          this._isDone = !this._isDone;
                        });
                      },
                      constraints: BoxConstraints(minWidth: 20, minHeight: 18),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: CircleBorder(
                        side: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 1,
                        ),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    title: TextFormField(
                      key: ValueKey('taskName'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Task title cannot be empty';
                        }

                        return null;
                      },
                      onSaved: (value) {
                        this._taskName = value;
                      },
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                      decoration: InputDecoration(
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 20,
                        ),
                        hintText: 'Task name',
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                    trailing: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(20, 20),
                        onPrimary: Theme.of(context).primaryColor,
                        primary: Theme.of(context).accentColor,
                        elevation: 0,
                      ),
                      onPressed: () {
                        setState(() {
                          this._isFullScreen = !this._isFullScreen;
                        });
                      },
                      icon: Icon(Icons.open_in_full),
                      label: Text(''),
                    ),
                    subtitle: TextFormField(
                      key: ValueKey('taskDescription'),
                      onSaved: (value) {
                        this._taskDescription = value;
                      },
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Task description',
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                        ),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      PopupMenuButton(
                        initialValue: this._priority,
                        onSelected: (value) {
                          setState(() {
                            this._priority = value;
                          });
                        },
                        icon: Icon(Icons.flag_outlined),
                        itemBuilder: (context) {
                          print('flag');
                          return priorities.map((e) {
                            return PopupMenuItem(
                              child: Text(e),
                              value: e,
                            );
                          }).toList();
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.calendar_today_outlined,
                        ),
                        onPressed: () async {
                          final picked = await showDateRangePicker(
                            context: context,
                            firstDate: new DateTime.now().subtract(Duration(days: 730)),
                            lastDate: new DateTime.now().add(Duration(days: 730)),
                            initialDateRange: DateTimeRange(
                              start: this._startInitialValue,
                              end: this._endInitialValue,
                            ),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: ColorScheme.light(
                                    primary: Colors.grey,
                                    onPrimary: Colors.white,
                                    onSurface: Colors.black,
                                  ),
                                  textButtonTheme: TextButtonThemeData(
                                    style: TextButton.styleFrom(
                                      primary: Colors.black,
                                    ),
                                  ),
                                ),
                                child: child,
                              );
                            },
                          );
                          if (picked != null) {
                            this._startDate = picked.start;
                            this._startInitialValue = picked.start;

                            this._endDate = picked.end;
                            this._endInitialValue = picked.end;
                          }
                        },
                      ),
                      IconButton(
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
                                      height: 300,
                                      width: 300,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          ListTile(
                                            title: Form(
                                              key: this._tagKey,
                                              child: TextFormField(
                                                onChanged: (value) {
                                                  setState(() {
                                                    filteredTags = tags.where((element) => element.name.toLowerCase().contains(value.toLowerCase())).toList();
                                                  });
                                                },
                                                onSaved: (value) {
                                                  setState(() {
                                                    final newTag = Tag(id: (tags.length + 1), name: value);
                                                    Provider.of<TagProvider>(context, listen: false).addTag(newTag);
                                                    tags.add(newTag);
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
                                                this._tagKey.currentState.save();
                                                this._tagKey.currentState.reset();
                                                filteredTags = tags.reversed.toList();
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
                                                      this._finalTags.add(filteredTags[tagIndex]);
                                                    } else {
                                                      this._finalTags.remove(filteredTags[tagIndex]);
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
                      ),
                      IconButton(
                        icon: Icon(Icons.save),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.person_add_alt_1_outlined,
                        ),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(Icons.attach_file_outlined),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  Divider(
                    thickness: 1.5,
                    color: Theme.of(context).primaryColor,
                  ),
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.values(),
                    children: [
                      PopupMenuButton(
                        icon: Icon(Icons.all_inbox),
                        initialValue: this._localization,
                        onSelected: (value) {
                          setState(() {
                            this._localization = value;
                          });
                        },
                        itemBuilder: (context) {
                          return localizations.map((e) {
                            return PopupMenuItem(
                              child: Text(e),
                              value: e,
                            );
                          }).toList();
                        },
                      ),
                      Expanded(child: Text(this._localization)),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          onPrimary: Theme.of(context).primaryColor,
                          primary: Theme.of(context).accentColor,
                          elevation: 0,
                        ),
                        onPressed: () {
                          this._addNewTask();
                        },
                        icon: Icon(Icons.subdirectory_arrow_left_outlined),
                        label: Text(
                          'Save',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
