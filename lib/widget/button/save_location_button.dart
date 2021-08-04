import 'package:flutter/material.dart';

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
                  child: Text('Save location'),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
