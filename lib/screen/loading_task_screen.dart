import 'package:flutter/material.dart';
import 'package:productive_app/widget/appBar/newTask_appBar.dart';
import 'package:shimmer/shimmer.dart';

class LoadingTaskScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(
          double.infinity,
          kToolbarHeight,
        ),
        child: Shimmer.fromColors(
          child: NewTaskAppBar(title: 'Inbox'),
          baseColor: Theme.of(context).primaryColorLight,
          highlightColor: Theme.of(context).primaryColorDark,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: 5,
          itemBuilder: (ctx, _) {
            return Padding(
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
            );
          },
        ),
      ),
      floatingActionButton: Shimmer.fromColors(
        child: FloatingActionButton(
          elevation: 0,
          onPressed: () {},
          child: Icon(
            Icons.add_outlined,
          ),
        ),
        baseColor: Theme.of(context).primaryColorLight,
        highlightColor: Theme.of(context).primaryColorDark,
      ),
      bottomNavigationBar: Shimmer.fromColors(
        child: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.inbox_outlined), label: 'Inbox'),
            BottomNavigationBarItem(icon: Icon(Icons.inbox_outlined), label: 'Anytime'),
            BottomNavigationBarItem(icon: Icon(Icons.inbox_outlined), label: 'Scheduled'),
            BottomNavigationBarItem(icon: Icon(Icons.inbox_outlined), label: 'Delegated'),
          ],
        ),
        baseColor: Theme.of(context).primaryColorLight,
        highlightColor: Theme.of(context).primaryColorDark,
      ),
    );
  }
}
