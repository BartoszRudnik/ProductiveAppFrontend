import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ListShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Shimmer.fromColors(
              child: Card(
                child: Container(
                  height: 70,
                  width: double.infinity,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              baseColor: Theme.of(context).primaryColorLight,
              highlightColor: Theme.of(context).primaryColorDark,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Shimmer.fromColors(
              child: Card(
                child: Container(
                  height: 70,
                  width: double.infinity,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              baseColor: Theme.of(context).primaryColorLight,
              highlightColor: Theme.of(context).primaryColorDark,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Shimmer.fromColors(
              child: Card(
                child: Container(
                  height: 70,
                  width: double.infinity,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              baseColor: Theme.of(context).primaryColorLight,
              highlightColor: Theme.of(context).primaryColorDark,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Shimmer.fromColors(
              child: Card(
                child: Container(
                  height: 70,
                  width: double.infinity,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              baseColor: Theme.of(context).primaryColorLight,
              highlightColor: Theme.of(context).primaryColorDark,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Shimmer.fromColors(
              child: Card(
                child: Container(
                  height: 70,
                  width: double.infinity,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              baseColor: Theme.of(context).primaryColorLight,
              highlightColor: Theme.of(context).primaryColorDark,
            ),
          ),
        ],
      ),
    );
  }
}
