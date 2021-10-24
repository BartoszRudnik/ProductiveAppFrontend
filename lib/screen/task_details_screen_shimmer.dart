import 'package:flutter/material.dart';
import 'package:productive_app/widget/appBar/newTask_appBar.dart';
import 'package:productive_app/widget/details_shimmer.dart';
import 'package:shimmer/shimmer.dart';

class TaskDetailsScreenShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(
          double.infinity,
          kToolbarHeight,
        ),
        child: Shimmer.fromColors(
          child: NewTaskAppBar(title: 'Details'),
          baseColor: Theme.of(context).primaryColorLight,
          highlightColor: Theme.of(context).primaryColorDark,
        ),
      ),
      body: DetailsShimmer(),
      bottomNavigationBar: Shimmer.fromColors(
        child: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.inbox_outlined), label: 'Inbox'),
            BottomNavigationBarItem(icon: Icon(Icons.inbox_outlined), label: 'Anytime'),
            BottomNavigationBarItem(icon: Icon(Icons.inbox_outlined), label: 'Scheduled'),
          ],
        ),
        baseColor: Theme.of(context).primaryColorLight,
        highlightColor: Theme.of(context).primaryColorDark,
      ),
    );
  }
}
