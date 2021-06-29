import 'package:flutter/material.dart';
import 'package:productive_app/task_page/models/collaborator.dart';
import 'package:productive_app/task_page/task_screens/collaborator_profile.dart';
import 'package:productive_app/task_page/task_screens/recent_tasks.dart';

class CollaboratorProfileTabs extends StatefulWidget {
  static const routeName = "/collaboratorProfileTabs";

  @override
  _CollaboratorProfileTabsState createState() => _CollaboratorProfileTabsState();
}

class _CollaboratorProfileTabsState extends State<CollaboratorProfileTabs> {
  List<Map<String, Object>> _pages;

  final _selectedItemColor = Colors.white;
  final _unselectedItemColor = Colors.black;
  final _selectedBgColor = Colors.black;
  final _unselectedBgColor = Colors.white;
  int _selectedPageIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final collaborator = ModalRoute.of(context).settings.arguments as Collaborator;

    _pages = [
      {
        'page': CollaboratorProfile(
          collaborator: collaborator,
        ),
        'title': 'Collaborator profile',
      },
      {
        'page': RecentTasks(
          collaborator: collaborator,
        ),
        'title': 'Recently finished tasks',
      },
    ];
  }

  void _selectPage(int index) {
    if (index >= 0 && index < _pages.length) {
      setState(() {
        _selectedPageIndex = index;
      });
    }
  }

  Color _getBgColor(int index) => _selectedPageIndex == index ? _selectedBgColor : _unselectedBgColor;

  Color _getItemColor(int index) => _selectedPageIndex == index ? _selectedItemColor : _unselectedItemColor;

  Widget _buildIcon(IconData iconData, String text, int index) => Container(
        width: double.infinity,
        height: 65,
        child: Material(
          color: this._getBgColor(index),
          child: InkWell(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(text, style: TextStyle(fontSize: 12, color: this._getItemColor(index))),
              ],
            ),
            onTap: () => this._selectPage(index),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 250),
      child: Scaffold(
        body: _pages[this._selectedPageIndex]['page'],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            border: Border(
              top: BorderSide(color: Theme.of(context).primaryColor, width: 1.0),
            ),
          ),
          child: BottomNavigationBar(
            selectedFontSize: 0,
            currentIndex: _selectedPageIndex,
            selectedItemColor: this._selectedItemColor,
            unselectedItemColor: this._unselectedItemColor,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                icon: _buildIcon(Icons.settings, "Collaborator profile", 0),
                title: SizedBox.shrink(),
              ),
              BottomNavigationBarItem(
                icon: _buildIcon(Icons.people_outline, "Recently finished tasks", 1),
                title: SizedBox.shrink(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
