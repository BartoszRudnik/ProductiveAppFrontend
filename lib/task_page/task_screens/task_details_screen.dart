import 'package:flutter/material.dart';
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
  bool _isFocused = false;
  bool _isDescriptionInitial = true;
  bool _isStartDateInitial = true;
  bool _isEndDateInitial = true;
  String _description = "";
  @override
  void initState() {
    Provider.of<TaskProvider>(context, listen: false).fetchTasks();
    _descriptionFocus.addListener(onDescriptionFocusChange);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TaskAppBar(
        title: 'Details',
      ),
      body: SingleChildScrollView (
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0), 
          child: Column(
            children: [
              TextFormField(
                style: TextStyle(fontSize: 25),
                maxLines: null,
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
                //key: Key(_description),
                maxLines: null,
                focusNode: _descriptionFocus,
                onChanged: (text) {
                  onDescriptionChanged(text);
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
                  ConstrainedBox(
                    constraints: BoxConstraints.tightFor(width: 90, height: 100),
                    child: ElevatedButton(
                      onPressed: (){},
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromRGBO(221, 221, 226, 1),
                        onPrimary: Colors.black,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.flag),
                          Text("Priority")
                        ],
                      )
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints.tightFor(width: 90, height: 100),
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
                  SizedBox(
                    width: 15,
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints.tightFor(width: 90, height: 100),
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
              TextFormField(
                maxLines: null,
                style: TextStyle(fontSize: 16),
                textAlign: _isStartDateInitial? TextAlign.center : TextAlign.left,
                decoration: InputDecoration(
                  hintText: "Start date",
                  hintStyle: TextStyle(
                    color: Color.fromRGBO(119, 119, 120, 1)
                  ),
                  filled: true,
                  fillColor: _isStartDateInitial? Color.fromRGBO(237, 237, 240, 1) : Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color.fromRGBO(221, 221, 226, 1))
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                maxLines: null,
                style: TextStyle(fontSize: 16),
                textAlign: _isEndDateInitial? TextAlign.center : TextAlign.left,
                decoration: InputDecoration(
                  hintText: "End date",
                  hintStyle: TextStyle(
                    color: Color.fromRGBO(119, 119, 120, 1)
                  ),
                  filled: true,
                  fillColor: _isEndDateInitial? Color.fromRGBO(237, 237, 240, 1) : Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color.fromRGBO(221, 221, 226, 1))
                  ),
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
              SizedBox(
                width: 105,
              ),
              TextButton.icon(
                onPressed: (){},
                style: ElevatedButton.styleFrom(
                  onPrimary: Colors.black,
                ),
                icon: Icon(Icons.done),
                label: Text("Mark as done"),
              )
            ],
          ),
        )
      ), 
    );
  }
}
