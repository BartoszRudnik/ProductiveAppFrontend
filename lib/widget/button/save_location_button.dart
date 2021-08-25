import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SaveLocationButton extends StatelessWidget {
  final choosenLocation;

  SaveLocationButton({
    @required this.choosenLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(this.choosenLocation);
                  },
                  child: Text(AppLocalizations.of(context).save),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
