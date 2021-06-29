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
  void didChangeDependencies() {
    Provider.of<DelegateProvider>(context, listen: false).getCollaboratorName(this.widget.collaborator.email).then((value) {
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
        systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.black),
        backgroundColor: Theme.of(context).accentColor,
        iconTheme: Theme.of(context).iconTheme,
        brightness: Brightness.dark,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: 220,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
            ),
            child: ClipRRect(
              child: FadeInImage(
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ListTile(
                  minLeadingWidth: 16,
                  contentPadding: EdgeInsets.symmetric(horizontal: 0),
                  title: Align(
                    alignment: Alignment(-1.1, 0),
                    child: Center(
                      child: Text(
                        "Email: " + this.widget.collaborator.email,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ),
                ListTile(
                  minLeadingWidth: 16,
                  contentPadding: EdgeInsets.symmetric(horizontal: 0),
                  title: Align(
                    alignment: Alignment(-1.1, 0),
                    child: Center(
                      child: Text(
                        "Name: " + collaboratorName,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
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
            onPressed: () {},
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
    );
  }
}
