import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ChartShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      child: Card(
        elevation: 6,
        margin: EdgeInsets.all(15),
        child: Container(
          padding: EdgeInsets.all(7),
          height: 205,
          width: double.infinity,
          color: Theme.of(context).primaryColor,
        ),
      ),
      baseColor: Theme.of(context).primaryColorLight,
      highlightColor: Theme.of(context).primaryColorDark,
    );
  }
}
