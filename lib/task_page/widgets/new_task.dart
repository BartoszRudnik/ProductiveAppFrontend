import 'package:flutter/material.dart';

class NewTask extends StatefulWidget {
  @override
  _NewTaskState createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTask> {
  var _isFullScreen = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
        return SingleChildScrollView(
          child: Container(
            height: this._isFullScreen ? MediaQuery.of(context).size.height - 25 : null,
            padding: EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Expanded(
              child: Column(
                children: [
                  ListTile(
                    isThreeLine: true,
                    horizontalTitleGap: 5,
                    minLeadingWidth: 20,
                    contentPadding: EdgeInsets.all(0),
                    leading: RawMaterialButton(
                      focusElevation: 0,
                      child: Icon(
                        Icons.done,
                        color: Colors.white,
                        size: 14,
                      ),
                      onPressed: () {},
                      constraints: BoxConstraints(minWidth: 20, minHeight: 18),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      fillColor: Theme.of(context).accentColor,
                      shape: CircleBorder(
                        side: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 1,
                        ),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    title: TextFormField(
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
                      IconButton(
                        icon: Icon(
                          Icons.flag_outlined,
                        ),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.calendar_today_outlined,
                        ),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.tag,
                        ),
                        onPressed: () {},
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          onPrimary: Theme.of(context).primaryColor,
                          primary: Theme.of(context).accentColor,
                          elevation: 0,
                        ),
                        onPressed: () {},
                        icon: Icon(Icons.all_inbox),
                        label: Text(
                          'Inbox',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          onPrimary: Theme.of(context).primaryColor,
                          primary: Theme.of(context).accentColor,
                          elevation: 0,
                        ),
                        onPressed: () {},
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
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
