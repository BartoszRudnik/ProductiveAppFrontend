import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:productive_app/provider/location_provider.dart';
import 'package:productive_app/provider/synchronize_provider.dart';
import 'package:productive_app/provider/task_provider.dart';
import 'package:productive_app/screen/collaborator_profile_tabs.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../config/images.dart';
import '../model/collaborator.dart';
import '../provider/delegate_provider.dart';
import '../widget/appBar/collaborator_profile_appBar.dart';

class CollaboratorReceivedProfile extends StatefulWidget {
  static String routeName = "/collaboratorReceivedProfile";

  @override
  State<CollaboratorReceivedProfile> createState() => _CollaboratorReceivedProfileState();
}

class _CollaboratorReceivedProfileState extends State<CollaboratorReceivedProfile> {
  final String _serverUrl = GlobalConfiguration().getValue("serverUrl");

  bool isNavigating = false;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;

    final bool isReceived = args['isReceived'];
    final Collaborator collaborator = args['collaborator'];

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
                    image: NetworkImage(this._serverUrl + 'userImage/getImage/${collaborator.email}'),
                    placeholder: AssetImage(Images.profilePicturePlacholder),
                    imageErrorBuilder: (ctx, obj, stackTrace) => Image.asset(Images.profilePicturePlacholder),
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
                            AppLocalizations.of(context).email,
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        Expanded(
                          flex: 8,
                          child: TextFormField(
                            enabled: false,
                            initialValue: collaborator.email,
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
                            AppLocalizations.of(context).name,
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        Expanded(
                          flex: 8,
                          child: TextFormField(
                            key: ObjectKey(collaborator.collaboratorName),
                            enabled: false,
                            initialValue: collaborator.collaboratorName,
                            style: TextStyle(fontSize: 18),
                            maxLines: 1,
                            decoration: InputDecoration(hintText: AppLocalizations.of(context).name),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              if (this.isNavigating)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorLight,
                  ),
                  child: Shimmer.fromColors(
                    child: Container(
                      color: Theme.of(context).primaryColor,
                      height: 40,
                      width: MediaQuery.of(context).size.width,
                    ),
                    baseColor: Theme.of(context).primaryColorLight,
                    highlightColor: Theme.of(context).primaryColorDark,
                  ),
                ),
              if (this.isNavigating) SizedBox(height: 10),
              if (this.isNavigating)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorLight,
                  ),
                  child: Shimmer.fromColors(
                    child: Container(
                      color: Theme.of(context).primaryColor,
                      height: 40,
                      width: MediaQuery.of(context).size.width,
                    ),
                    baseColor: Theme.of(context).primaryColorLight,
                    highlightColor: Theme.of(context).primaryColorDark,
                  ),
                ),
              if (!this.isNavigating)
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
                      Row(
                        mainAxisAlignment: isReceived ? MainAxisAlignment.spaceAround : MainAxisAlignment.center,
                        children: [
                          if (!isReceived)
                            ElevatedButton(
                              onPressed: () {
                                return showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Center(
                                      child: Text(
                                        AppLocalizations.of(context).cancel,
                                        style: Theme.of(context).textTheme.headline3,
                                      ),
                                    ),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(AppLocalizations.of(context).areYouSureCancelInvitation),
                                        SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () async {
                                                final locations = Provider.of<LocationProvider>(context, listen: false).locationList;
                                                Provider.of<TaskProvider>(context, listen: false).deleteCollaboratorFromTasks(collaborator.email, locations);
                                                Provider.of<TaskProvider>(context, listen: false).deleteReceivedFromCollaborator(collaborator.email, locations);

                                                Provider.of<SynchronizeProvider>(context, listen: false).addCollaboratorToDelete(collaborator.uuid);
                                                await Provider.of<DelegateProvider>(context, listen: false).deleteCollaborator(collaborator.uuid);
                                                Navigator.of(context).pop(true);
                                                Navigator.of(context).pop(true);
                                              },
                                              child: Text(
                                                AppLocalizations.of(context).yes,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Theme.of(context).accentColor,
                                                ),
                                              ),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(context).pop(false);
                                                Navigator.of(context).pop(false);
                                              },
                                              child: Text(
                                                AppLocalizations.of(context).no,
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
                              child: Text(AppLocalizations.of(context).cancelInvitation),
                            ),
                          if (isReceived)
                            ElevatedButton(
                              onPressed: () {
                                return showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Center(
                                      child: Text(
                                        AppLocalizations.of(context).decline,
                                        style: Theme.of(context).textTheme.headline3,
                                      ),
                                    ),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(AppLocalizations.of(context).areYouSureDeclineInvitation),
                                        SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            ElevatedButton(
                                                onPressed: () async {
                                                  Provider.of<SynchronizeProvider>(context, listen: false).addCollaboratorToDelete(collaborator.uuid);
                                                  await Provider.of<DelegateProvider>(context, listen: false).declineInvitation(collaborator.uuid);
                                                  Navigator.of(context).pop(true);
                                                  Navigator.of(context).pop(true);
                                                },
                                                child: Text(AppLocalizations.of(context).yes)),
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(context).pop(false);
                                              },
                                              child: Text(AppLocalizations.of(context).no),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                              child: Text(AppLocalizations.of(context).declineInvitation),
                            ),
                          if (isReceived)
                            ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  this.isNavigating = true;
                                });

                                await Provider.of<TaskProvider>(context, listen: false).getTasksFromCollaborator(collaborator.email);
                                await Provider.of<DelegateProvider>(context, listen: false).acceptInvitation(collaborator.uuid);

                                Navigator.of(context).pushReplacementNamed(CollaboratorProfileTabs.routeName, arguments: collaborator);
                              },
                              child: Text(AppLocalizations.of(context).acceptInvitation),
                            ),
                        ],
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
