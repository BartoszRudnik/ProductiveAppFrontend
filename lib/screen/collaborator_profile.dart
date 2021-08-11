import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:productive_app/config/images.dart';
import 'package:productive_app/widget/switch_list_tile/grant_access_list_tile.dart';
import 'package:provider/provider.dart';
import '../model/collaborator.dart';
import '../provider/delegate_provider.dart';
import '../widget/appBar/collaborator_profile_appBar.dart';

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

  bool grantAccess;

  @override
  void initState() {
    grantAccess = this.widget.collaborator.sentPermission;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CollaboratorProfileAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorLight,
                  border: Border.all(
                    color: Theme.of(context).primaryColorDark,
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
                    placeholder: AssetImage(Images.profilePicturePlacholder),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorLight,
                  border: Border.all(
                    color: Theme.of(context).primaryColorDark,
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
                            key: ObjectKey(this.widget.collaborator.collaboratorName),
                            enabled: false,
                            initialValue: this.widget.collaborator.collaboratorName,
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
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorLight,
                  border: Border.all(
                    color: Theme.of(context).primaryColorDark,
                    width: 2.5,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (this.widget.collaborator.isAskingForPermission)
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorDark,
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.8),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'Asked for permission to see your activity',
                            ),
                            IconButton(
                              icon: Icon(Icons.cancel_outlined),
                              onPressed: () {
                                Provider.of<DelegateProvider>(context, listen: false).declineAskForPermission(this.widget.collaborator.email);
                                setState(() {
                                  this.widget.collaborator.isAskingForPermission = false;
                                });
                              },
                            )
                          ],
                        ),
                      ),
                    if (this.widget.collaborator.isAskingForPermission)
                      SizedBox(
                        height: 10,
                      ),
                    GrantAccessListTile(
                      email: this.widget.collaborator.email,
                      grantAccess: this.grantAccess,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorLight,
                  border: Border.all(
                    color: Theme.of(context).primaryColorDark,
                    width: 2.5,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
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
                                      onPressed: () async {
                                        await Provider.of<DelegateProvider>(context, listen: false).deleteCollaborator(this.widget.collaborator.id);
                                        Navigator.of(context).pop(true);
                                        Navigator.of(context).pop(true);
                                      },
                                      child: Text('Yes'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                      child: Text('No'),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      child: Text('Delete from collaborators'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
