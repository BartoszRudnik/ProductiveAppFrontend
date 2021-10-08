import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ListShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 4,
      itemBuilder: (ctx, index) => Padding(
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
          ],
        ),
      ),
    );
  }
}
