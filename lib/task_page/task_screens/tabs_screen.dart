import 'package:flutter/material.dart';
import 'package:productive_app/task_page/widgets/task_appBar.dart';
import 'package:productive_app/task_page/widgets/main_drawer.dart';
import 'package:productive_app/task_page/task_screens/anyTime_screen.dart';
import 'package:productive_app/task_page/task_screens/delegated_screen.dart';
import 'package:productive_app/task_page/task_screens/inbox_screen.dart';
import 'package:productive_app/task_page/task_screens/scheduled_screen.dart';

class TabsScreen extends StatefulWidget {
  static const routeName = ('/tabs-screen');

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  List<Map<String, Object>> _pages;

  final _selectedItemColor = Colors.white;
  final _unselectedItemColor = Colors.black;
  final _selectedBgColor = Colors.black;
  final _unselectedBgColor = Colors.white;
  int _selectedPageIndex = 0;

  final String username = 'Karolina Modzelewska';

  @override
  void initState() {
    super.initState();
    _pages = [
      {
        'page': InboxScreen(),
        'title': 'Inbox',
      },
      {
        'page': AnytimeScreen(),
        'title': 'AnyTime',
      },
      {
        'page': ScheduledScreen(),
        'title': 'Scheduled',
      },
      {
        'page': DelegatedScreen(),
        'title': 'Delegated',
      }
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
        height: 60,
        child: Material(
          color: this._getBgColor(index),
          child: InkWell(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(iconData),
                Text(text, style: TextStyle(fontSize: 12, color: this._getItemColor(index))),
              ],
            ),
            onTap: () => this._selectPage(index),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity < 0) {
          _selectPage(_selectedPageIndex + 1);
        }
        if (details.primaryVelocity > 0) {
          _selectPage(_selectedPageIndex - 1);
        }
      },
      child: Scaffold(
        appBar: TaskAppBar(
          title: _pages[_selectedPageIndex]['title'],
        ),
        drawer: MainDrawer(username: this.username),
        body: _pages[_selectedPageIndex]['page'],
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
            color: Theme.of(context).accentColor,
            size: 50,
          ),
          onPressed: () {},
          backgroundColor: Theme.of(context).primaryColor,
        ),
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
                icon: _buildIcon(Icons.inbox_outlined, 'Inbox', 0),
                title: SizedBox.shrink(),
              ),
              BottomNavigationBarItem(
                icon: _buildIcon(Icons.access_time, 'Anytime', 1),
                title: SizedBox.shrink(),
              ),
              BottomNavigationBarItem(
                icon: _buildIcon(Icons.calendar_today_outlined, 'Scheduled', 2),
                title: SizedBox.shrink(),
              ),
              BottomNavigationBarItem(
                icon: _buildIcon(Icons.person_outline_outlined, 'Delegated', 3),
                title: SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
