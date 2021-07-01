import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:productive_app/task_page/models/collaborator.dart';
import 'package:productive_app/task_page/providers/delegate_provider.dart';
import 'package:provider/provider.dart';

class CollaboratorProfile extends StatefulWidget {
  Collaborator collaborator;

  CollaboratorProfile({
    @required this.collaborator,
  });

  @override
  _CollaboratorProfileState createState() => _CollaboratorProfileState();
}

class _CollaboratorProfileState extends State<CollaboratorProfile> {
  String _serverUrl = GlobalConfiguration().getValue("serverUrl");

  String collaboratorName;
  bool grantAccess;

  @override
  void initState() {
    grantAccess = this.widget.collaborator.sentPermission;
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    await Provider.of<DelegateProvider>(context, listen: false).getCollaboratorName(this.widget.collaborator.email).then((value) {
      setState(() {
        collaboratorName = value;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.black),
        backgroundColor: Theme.of(context).accentColor,
        iconTheme: Theme.of(context).iconTheme,
        brightness: Brightness.dark,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color.fromRGBO(237, 237, 240, 1),
                border: Border.all(
                  color: Color.fromRGBO(221, 221, 226, 1),
                  width: 2.5,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(90),
                child: FadeInImage(
                  fit: BoxFit.cover,
                  width: 220,
                  height: 220,
                  image: NetworkImage(this._serverUrl + 'userImage/getImage/${this.widget.collaborator.email}'),
                  placeholder: AssetImage('assets/images/profile_placeholder.jpg'),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color.fromRGBO(237, 237, 240, 1),
                border: Border.all(
                  color: Color.fromRGBO(221, 221, 226, 1),
                  width: 2.5,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Text(
                          "E-mail:",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Expanded(
                        flex: 8,
                        child: TextFormField(
                          enabled: false,
                          initialValue: this.widget.collaborator.email,
                          style: TextStyle(fontSize: 18),
                          maxLines: 1,
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Text(
                          "Name:",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Expanded(
                        flex: 8,
                        child: TextFormField(
                          key: ObjectKey(collaboratorName),
                          enabled: false,
                          initialValue: collaboratorName,
                          style: TextStyle(fontSize: 18),
                          maxLines: 1,
                          decoration: InputDecoration(hintText: "Name"),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color.fromRGBO(237, 237, 240, 1),
                border: Border.all(
                  color: Color.fromRGBO(221, 221, 226, 1),
                  width: 2.5,
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Card(
                      elevation: 8,
                      child: SwitchListTile(
                        activeColor: Theme.of(context).primaryColor,
                        title: Text('Grant access to my activity'),
                        value: grantAccess,
                        onChanged: (bool value) {
                          setState(
                            () {
                              grantAccess = value;
                              Provider.of<DelegateProvider>(context, listen: false).changePermission(this.widget.collaborator.email);
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 5,
                      primary: Color.fromRGBO(201, 201, 206, 1),
                      side: BorderSide(
                        color: Colors.grey.withOpacity(0.8),
                      ),
                    ),
                    onPressed: () {
                      return showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Center(
                            child: Text(
                              'Delete',
                              style: Theme.of(context).textTheme.headline3,
                            ),
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Are you sure you want to delete this collaborator?'),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Theme.of(context).primaryColor,
                                      side: BorderSide(color: Theme.of(context).primaryColor),
                                    ),
                                    onPressed: () async {
                                      await Provider.of<DelegateProvider>(context, listen: false).deleteCollaborator(this.widget.collaborator.id);
                                      Navigator.of(context).pop(true);
                                      Navigator.of(context).pop(true);
                                    },
                                    child: Text(
                                      'Yes',
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
                                      Navigator.of(context).pop(false);
                                    },
                                    child: Text(
                                      'No',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Theme.of(context).accentColor,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'Delete from collaborators',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
