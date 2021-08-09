import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/const_values.dart';
import '../provider/settings_provider.dart';

class FiltersSortingMode extends StatelessWidget {
  final int sortingMode;

  FiltersSortingMode({
    @required this.sortingMode,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Card(
        elevation: 8,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 4),
              child: Row(
                children: [
                  Text(
                    'Sort by',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 8),
              height: 70,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: ConstValues.sortingModes.length,
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () => Provider.of<SettingsProvider>(context, listen: false).changeSortingMode(index),
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: this.sortingMode == index ? Theme.of(context).primaryColor : Theme.of(context).primaryColorDark,
                    ),
                    child: Center(
                      child: Text(
                        ConstValues.sortingModes[index],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: this.sortingMode == index ? Theme.of(context).accentColor : Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
