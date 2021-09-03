import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:productive_app/config/images.dart';
import 'package:productive_app/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsUserAvatar extends StatefulWidget {
  final Function removeAvatar;
  final Function changeAvatar;

  SettingsUserAvatar({
    @required this.removeAvatar,
    @required this.changeAvatar,
  });

  @override
  _SettingsUserAvatarState createState() => _SettingsUserAvatarState();
}

class _SettingsUserAvatarState extends State<SettingsUserAvatar> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;

    return Container(
      padding: EdgeInsets.only(top: 10, left: 6, bottom: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColorLight,
        border: Border.all(
          color: Theme.of(context).primaryColorDark,
          width: 2.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 100,
            height: 100,
            child: GestureDetector(
              onTap: () => this.widget.changeAvatar(),
              child: Badge(
                position: BadgePosition.topEnd(),
                badgeColor: Theme.of(context).accentColor,
                badgeContent: Icon(Icons.photo_camera),
                child: user != null && !user.removed
                    ? Container(
                        width: 100,
                        height: 100,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: user.userImage != null
                              ? user.userImage
                              : user.localImage != null
                                  ? MemoryImage(user.localImage)
                                  : null,
                        ),
                      )
                    : Container(
                        width: 100,
                        height: 100,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage(Images.profilePicturePlacholder),
                        ),
                      ),
              ),
            ),
          ),
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Text(
                    user.email,
                    style: TextStyle(fontSize: 20),
                    maxLines: 2,
                    softWrap: true,
                    overflow: TextOverflow.clip,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    this.widget.removeAvatar();
                  },
                  child: Text(AppLocalizations.of(context).removeAvatar),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
