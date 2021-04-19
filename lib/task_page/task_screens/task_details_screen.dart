import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:productive_app/task_page/models/task.dart';
import 'package:productive_app/task_page/providers/task_provider.dart';
import 'package:productive_app/task_page/widgets/task_appBar.dart';
import 'package:provider/provider.dart';

class TaskDetailScreen extends StatefulWidget {
  static const routeName = "/task-details";

  @override
  _TaskDetailScreenState createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  FocusNode _descriptionFocus = new FocusNode();
  final _formKey = GlobalKey<FormState>();
  Task taskToEdit; 
  Task originalTask;

  bool _isValid = true;
  bool _isFocused = false;
  bool _isDescriptionInitial = true;
  String _description = "";
  DateFormat formatter = DateFormat("yyyy-MM-dd");
  @override
  void initState() {
    _descriptionFocus.addListener(onDescriptionFocusChange);
    taskToEdit = null;
    super.initState();
  }

  void onDescriptionFocusChange(){
    setState(() {
      _isFocused = !_isFocused;
    });
    checkColor();
    print("change");
  }

  void onDescriptionChanged(String text){
    setState(() {
      _description = text;
    });
    checkColor();
  }

  void checkColor(){
    setState(() {
      _isDescriptionInitial = true;
      if(_description.isNotEmpty){
        _isDescriptionInitial = false;
      }
      if(_isFocused){
        _isDescriptionInitial = false;
      }
    });
  }

  Future<DateTime> pickDate(DateTime initDate) async{
    final DateTime pick = await showDatePicker(
      context: context, 
      initialDate: initDate, 
      firstDate: DateTime(2000), 
      lastDate: DateTime(3000),
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
    return pick;
  }

  Future<void> selectStartDate() async{
    DateTime initDate = taskToEdit.startDate;
    if(taskToEdit.startDate == null){
      initDate = DateTime.now();
    }
    final DateTime pick = await pickDate(initDate);
    setState(() {
      taskToEdit.startDate = pick;
    });
  }

  Future<void> selectEndDate() async{
    DateTime initDate = taskToEdit.endDate;
    if(taskToEdit.endDate == null){
      initDate = DateTime.now();
    }
    final DateTime pick = await pickDate(initDate);
    setState(() {
      taskToEdit.endDate = pick;
    });
  }

  Future<void> saveTask() async{
    var isValid = this._formKey.currentState.validate();

    setState(() {
      this._isValid = isValid;
    });

    if(taskToEdit.startDate != null && taskToEdit.endDate == null){
      setState((){
        this._isValid = false;
      });showDialog(
        context: context, 
        builder: (context) => AlertDialog(
          title: Text(
            'Warning',
            style: Theme.of(context).textTheme.headline2,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Task end date must be specified if you specify task start date'),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor,
                      side: BorderSide(color: Theme.of(context).primaryColor),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: Text(
                      'OK',
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
        )
      );
    }

    if (!this._isValid) {
      return;
    }

    this._formKey.currentState.save();
    try{
      await Provider.of<TaskProvider>(context, listen: false).updateTask(taskToEdit, taskToEdit.localization);
      Provider.of<TaskProvider>(context, listen: false).deleteFromLocalization(originalTask);  
    }catch (error){
      print(error);
    }
    Navigator.pop(context);
  }

  void setTaskToEdit(Task argTask){
      taskToEdit = new Task(
        id: argTask.id,
        title: argTask.title,
        description: argTask.description,
        done: argTask.done,
        startDate: argTask.startDate,
        endDate: argTask.endDate,
        localization: argTask.localization,
        priority: argTask.priority,
        tags: argTask.tags,
      );

  }

  @override
  Widget build(BuildContext context) {
    final priorities = Provider.of<TaskProvider>(context, listen: false).priorities;

    if(taskToEdit == null){
      originalTask = ModalRoute.of(context).settings.arguments as Task;  
      setTaskToEdit(originalTask);
      _description = taskToEdit.description;
      if(_description.isNotEmpty && _description.trim() != ''){
        onDescriptionChanged(taskToEdit.description);
      }
    }
    
    return Scaffold(
      appBar: TaskAppBar(
        title: 'Details',
      ),
      body: SingleChildScrollView (
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0), 
          child: Form(
            key: this._formKey,
            child: Column(
              children: [
                TextFormField(
                  initialValue: taskToEdit.title,
                  style: TextStyle(fontSize: 25),
                  maxLines: null,
                  onSaved: (value){
                    taskToEdit.title = value;
                  },
                  validator: (value){
                    if(value.isEmpty){
                      return 'Task title cannot be empty';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                ListTile(
                  minLeadingWidth: 16,
                  contentPadding: EdgeInsets.symmetric(horizontal: 0),
                  leading: Icon(Icons.edit),
                  title: Align(
                    alignment: Alignment(-1.1,0),
                    child: Text(
                      "Description",
                      style: TextStyle(fontSize: 21),
                    ),
                  ),
                ),
                TextFormField(
                  initialValue: taskToEdit.description,
                  maxLines: null,
                  focusNode: _descriptionFocus,
                  onChanged: (text) {
                    //taskToEdit.description = text;
                    onDescriptionChanged(text);
                  },
                  onSaved: (value){
                    taskToEdit.description = value;
                  },
                  style: TextStyle(fontSize: 16),
                  textAlign: _isDescriptionInitial? TextAlign.center : TextAlign.left,
                  decoration: InputDecoration(
                    hintText: _isFocused? "" : "Tap to add description",
                    hintStyle: TextStyle(
                      color: Color.fromRGBO(119, 119, 120, 1)
                    ),
                    filled: true,
                    fillColor: _isDescriptionInitial? Color.fromRGBO(237, 237, 240, 1) : Colors.white,
                    enabledBorder: _description.isEmpty? OutlineInputBorder(
                      borderSide: BorderSide(color: Color.fromRGBO(221, 221, 226, 1))
                    ) : InputBorder.none,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: SizedBox(
                        height: 100,
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            canvasColor: Color.fromRGBO(221, 221, 226, 1)
                          ),
                          child: PopupMenuButton(
                            initialValue: taskToEdit.priority,
                            onSelected: (value){
                              setState(() {
                                taskToEdit.priority = value;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(221, 221, 226, 1),
                                borderRadius: BorderRadius.circular(3),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.8),
                                    offset: Offset(0.0, 1.0),
                                    blurRadius: 1.0,
                                  )
                                ]
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.flag),
                                  Text("Priority")
                                ],
                              ),
                            ),
                            itemBuilder: (context){
                              return priorities.reversed.map((e) {
                              return PopupMenuItem(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Text(e),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    if (e == 'LOW') Icon(Icons.arrow_downward_outlined),
                                    if (e == 'HIGH') Icon(Icons.arrow_upward_outlined),
                                    if (e == 'HIGHER') Icon(Icons.arrow_upward_outlined),
                                    if (e == 'HIGHER') Icon(Icons.arrow_upward_outlined),
                                    if (e == 'CRITICAL') Icon(Icons.warning_amber_sharp),
                                  ],
                                ),
                                value: e,
                              );
                            }).toList();
                            },
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: SizedBox()
                    ),
                    Expanded(
                      flex: 5,
                      child: SizedBox(
                        height: 100,
                        child: ElevatedButton(
                          onPressed: (){},
                          style: ElevatedButton.styleFrom(
                            primary: Color.fromRGBO(221, 221, 226, 1),
                            onPrimary: Colors.black,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.person_add),
                              Text("Assigned")
                            ],
                          )
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: SizedBox()
                    ),
                    Expanded(
                      flex: 5,
                      child: SizedBox(
                        height: 100,
                        child: ElevatedButton(
                          onPressed: (){},
                          style: ElevatedButton.styleFrom(
                            primary: Color.fromRGBO(221, 221, 226, 1),
                            onPrimary: Colors.black,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.inbox),
                              Text("Inbox")
                            ],
                          )
                        ),
                      ),
                    ),
                  ],
                ),
                ListTile(
                  minLeadingWidth: 16,
                  contentPadding: EdgeInsets.symmetric(horizontal: 0),
                  leading: Icon(Icons.calendar_today),
                  title: Align(
                    alignment: Alignment(-1.1,0),
                    child: Text(
                      "Start and due date",
                      style: TextStyle(fontSize: 21),
                    ),
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints.tightFor(width: double.infinity, height: 50),
                  child: ElevatedButton(
                    onPressed: () => selectStartDate(),
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromRGBO(237, 237, 240, 1),
                      onPrimary: Color.fromRGBO(119, 119, 120, 1),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            (taskToEdit.startDate.toString() == "null")? "Start date" :
                              "Start date: " + formatter.format(taskToEdit.startDate)
                        )
                      ],
                    )
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                ConstrainedBox(
                  constraints: BoxConstraints.tightFor(width: double.infinity, height: 50),
                  child: ElevatedButton(
                    onPressed: () => selectEndDate(),
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromRGBO(237, 237, 240, 1),
                      onPrimary: Color.fromRGBO(119, 119, 120, 1),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            (taskToEdit.endDate.toString() == "null")? "End date" :
                              "End date: " + formatter.format(taskToEdit.endDate)
                        )
                      ],
                    )
                  ),
                ),
                ListTile(
                  minLeadingWidth: 16,
                  contentPadding: EdgeInsets.symmetric(horizontal: 0),
                  leading: Icon(Icons.tag),
                  title: Align(
                    alignment: Alignment(-1.1,0),
                    child: Text(
                      "Tags",
                      style: TextStyle(fontSize: 21),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            children: [
              TextButton.icon(
                onPressed: (){},
                style: ElevatedButton.styleFrom(
                  onPrimary: Colors.black,
                ),
                icon: Icon(Icons.delete),
                label: Text("Trash"),
              ),
              TextButton.icon(
                onPressed: (){},
                style: ElevatedButton.styleFrom(
                  onPrimary: Colors.black,
                ),
                icon: Icon(Icons.done),
                label: Text("Mark as done"),
              ),
              TextButton.icon(
                onPressed: () => saveTask(),
                style: ElevatedButton.styleFrom(
                  onPrimary: Colors.black,
                ),
                icon: Icon(Icons.save),
                label: Text("Save task"),
              )
            ],
          ),
        )
      ), 
    );
  }
}
