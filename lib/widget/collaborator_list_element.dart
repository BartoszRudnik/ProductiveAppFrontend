import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import '../config/images.dart';
import '../model/collaborator.dart';

class CollaboratorListElement extends StatelessWidget {
  final Collaborator collaborator;

  CollaboratorListElement({
    @required this.collaborator,
  });

  final _serverUrl = GlobalConfiguration().getValue("serverUrl");

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Badge(
          padding: EdgeInsets.all(8.5),
          position: BadgePosition.topStart(),
          showBadge: this.collaborator.isAskingForPermission != null ? this.collaborator.isAskingForPermission : false,
          badgeColor: Theme.of(context).primaryColor,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: FadeInImage(
              image: NetworkImage(this._serverUrl + 'userImage/getImage/${this.collaborator.email}'),
              placeholder: AssetImage(Images.profilePicturePlacholder),
            ),
          ),
        ),
        title: Text(
          this.collaborator.collaboratorName != null && this.collaborator.collaboratorName.length > 1 ? this.collaborator.collaboratorName : this.collaborator.email,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
        ),
      ),
    );
  }
}
