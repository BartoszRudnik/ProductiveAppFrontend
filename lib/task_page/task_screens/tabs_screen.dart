import 'package:flutter/material.dart';
import 'package:productive_app/login/providers/auth_provider.dart';
import 'package:productive_app/task_page/models/task.dart';
import 'package:productive_app/task_page/providers/task_provider.dart';
import 'package:productive_app/task_page/widgets/new_task.dart';
import 'package:productive_app/task_page/widgets/task_appBar.dart';
import 'package:productive_app/task_page/task_screens/anyTime_screen.dart';
import 'package:productive_app/task_page/task_screens/delegated_screen.dart';
import 'package:productive_app/task_page/task_screens/inbox_screen.dart';
import 'package:productive_app/task_page/task_screens/scheduled_screen.dart';
import 'package:provider/provider.dart';

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

  double offsetX = 0;
  double offsetY = 0;
  double scale = 1;
  bool isDrawerVisible = false;

  @override
  void initState() {
    super.initState();

    Provider.of<TaskProvider>(context, listen: false).getPriorities();

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

  void _addNewTaskForm(BuildContext buildContext) {
    showModalBottomSheet(
      enableDrag: true,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).accentColor,
      context: buildContext,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewTask(),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
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
  void _changeTranform(double x, double y, double s) {
    setState(() {
      offsetX = x;
      offsetY = y;
      scale = s;
    });
    isDrawerVisible = !isDrawerVisible;
    print("Transform change");
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      transform: Matrix4.translationValues(offsetX, offsetY, 0)..scale(scale),
      duration: Duration(milliseconds: 250),
      child: GestureDetector(
        onTap: () {
          if (isDrawerVisible) _changeTranform(0, 0, 1);
        },
        onHorizontalDragEnd: (details) {
          if (!isDrawerVisible) {
            if (details.primaryVelocity < 0) {
              _selectPage(_selectedPageIndex + 1);
            }
            if (details.primaryVelocity > 0) {
              if (_selectedPageIndex == 0 && !isDrawerVisible) {
                _changeTranform(230, 70, 0.8);
              }
              _selectPage(_selectedPageIndex - 1);
            }
          } else {
            if (details.primaryVelocity < 0) {
              _changeTranform(0, 0, 1);
            }
          }
        },
        child: Scaffold(
          appBar: TaskAppBar(
            title: _pages[_selectedPageIndex]['title'],
            leadingButton: IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  isDrawerVisible ? _changeTranform(0, 0, 1) : _changeTranform(230, 70, 0.8);
                }),
          ),
          /*drawer: DrawerScreen(
            username: Provider.of<AuthProvider>(context, listen: false).email,
          ), */
          body: _pages[_selectedPageIndex]['page'],
          floatingActionButton: FloatingActionButton(
            child: Icon(
              Icons.add,
              color: Theme.of(context).accentColor,
              size: 50,
            ),
            onPressed: () {
              this._addNewTaskForm(context);
            },
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
                  icon: _buildIcon(Icons.calendar_today, 'Scheduled', 2),
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
      ),
    );
  }
}
