import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:productive_app/db/version_database.dart';
import 'package:productive_app/model/appVersion.dart';
import '../config/images.dart';
import '../widget/appBar/login_appbar.dart';
import '../widget/button/login_button.dart';
import '../widget/button/sign_with_google.dart';
import 'login_screen.dart';

class EntryScreen extends StatefulWidget {
  static const routeName = 'entry-screen';

  @override
  State<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  void checkAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final String newVersion = packageInfo.version;

    final dbVersion = await VersionDatabase.read();
    if (dbVersion == null) {
      VersionDatabase.create(AppVersion(version: newVersion));
    } else {
      final String currentVersion = dbVersion.version;

      print('new: ' + newVersion);
      print('current: ' + currentVersion);

      if (newVersion != currentVersion) {
        await VersionDatabase.delete();
        await Future.wait(
          [
            VersionDatabase.create(AppVersion(version: newVersion)),
            DefaultCacheManager().emptyCache(),
          ],
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();

    this.checkAppVersion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LoginAppBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              height: 100,
              child: Image(
                color: Theme.of(context).primaryColor,
                image: AssetImage(Images.entryScreenImage),
                fit: BoxFit.fitHeight,
              ),
            ),
            SizedBox(
              height: 60,
            ),
            Container(
              width: double.infinity,
              height: 89,
              child: Text(
                'Task manager',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            SizedBox(
              height: 40,
            ),
            LoginButton(
              routeName: LoginScreen.routeName,
              backgroundColor: Theme.of(context).accentColor,
              textColor: Theme.of(context).primaryColor,
              labelText: AppLocalizations.of(context).signIn,
              loginMode: true,
            ),
            SizedBox(height: 40),
            LoginButton(
              routeName: LoginScreen.routeName,
              backgroundColor: Theme.of(context).accentColor,
              textColor: Theme.of(context).primaryColor,
              labelText: AppLocalizations.of(context).signUp,
              loginMode: false,
            ),
            SizedBox(height: 20),
            Text(
              AppLocalizations.of(context).or,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 20),
            SignWithGoogle(),
          ],
        ),
      ),
    );
  }
}
