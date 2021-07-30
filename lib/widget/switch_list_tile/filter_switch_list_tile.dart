import 'package:flutter/material.dart';

class FilterSwitchListTile extends StatelessWidget {
  final Function func;
  final String message;
  final bool value;

  FilterSwitchListTile({
    @required this.func,
    @required this.message,
    @required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Card(
        elevation: 8,
        child: SwitchListTile(
          activeColor: Theme.of(context).primaryColor,
          title: Text(this.message),
          value: this.value,
          onChanged: (bool value) {
            this.func();
          },
        ),
      ),
    );
  }
}
