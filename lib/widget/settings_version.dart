import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsVersion extends StatefulWidget {
  @override
  State<SettingsVersion> createState() => _SettingsVersionState();
}

class _SettingsVersionState extends State<SettingsVersion> {
  String version;
  String buildNumber;

  void _getVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();

    setState(() {
      this.version = packageInfo.version;
      this.buildNumber = packageInfo.buildNumber;
    });
  }

  @override
  void initState() {
    super.initState();

    this._getVersion();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColorLight,
        border: Border.all(
          color: Theme.of(context).primaryColorDark,
          width: 2.5,
        ),
      ),
      child: Column(
        children: [
          ListTile(
            minLeadingWidth: 16,
            contentPadding: EdgeInsets.symmetric(horizontal: 0),
            title: Align(
              alignment: Alignment(-1.1, 0),
              child: Center(
                child: Text(
                  AppLocalizations.of(context).version,
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ),
          if (this.version != null && this.buildNumber != null)
            Text(
              this.version + " build: #" + this.buildNumber,
            ),
        ],
      ),
    );
  }
}
