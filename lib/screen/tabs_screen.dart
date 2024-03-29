import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:productive_app/provider/auth_provider.dart';
import 'package:productive_app/screen/tutorial_screen.dart';
import 'package:provider/provider.dart';

import '../provider/delegate_provider.dart';
import '../provider/task_provider.dart';
import '../widget/appBar/newTask_appBar.dart';
import '../widget/new_task.dart';
import 'anyTime_screen.dart';
import 'delegated_screen.dart';
import 'inbox_screen.dart';
import 'scheduled_screen.dart';

class TabsScreen extends StatefulWidget {
  static const routeName = '/tabs-screen';

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> with TickerProviderStateMixin<TabsScreen> {
  List<Map<String, Object>> _pages;

  AnimationController _hideFab;

  Color _selectedItemColor;
  Color _unselectedItemColor;
  Color _selectedBgColor;
  Color _unselectedBgColor;
  int _selectedPageIndex = 0;

  double offsetX = 0;
  double offsetY = 0;
  double scale = 1;
  bool isDrawerVisible = false;

  String _getCurrentLocalizationName() {
    if (this._selectedPageIndex == 0) {
      return 'INBOX';
    } else if (this._selectedPageIndex == 1) {
      return 'ANYTIME';
    } else if (this._selectedPageIndex == 2) {
      return 'SCHEDULED';
    } else if (this._selectedPageIndex == 3) {
      return 'DELEGATED';
    } else
      return 'INBOX';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    if (isDarkMode) {
      this._selectedItemColor = Colors.black;
      this._unselectedItemColor = Colors.white;
      this._selectedBgColor = Colors.white;
      this._unselectedBgColor = Colors.grey[700];
    } else {
      this._selectedItemColor = Colors.white;
      this._unselectedItemColor = Colors.black;
      this._selectedBgColor = Colors.black;
      this._unselectedBgColor = Colors.white;
    }

    this._pages = [
      {
        'page': InboxScreen(),
        'title': AppLocalizations.of(context).inbox,
      },
      {
        'page': AnytimeScreen(),
        'title': AppLocalizations.of(context).anytime,
      },
      {
        'page': ScheduledScreen(),
        'title': AppLocalizations.of(context).scheduled,
      },
      {
        'page': DelegatedScreen(),
        'title': AppLocalizations.of(context).delegated,
      }
    ];
  }

  @override
  void initState() {
    super.initState();

    this._hideFab = AnimationController(vsync: this, duration: kThemeAnimationDuration);
    this._hideFab.forward();
  }

  @override
  void dispose() {
    this._hideFab.dispose();
    super.dispose();
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification.depth == 0) {
      if (notification is UserScrollNotification) {
        final UserScrollNotification userScroll = notification;
        switch (userScroll.direction) {
          case ScrollDirection.forward:
            if (userScroll.metrics.maxScrollExtent != userScroll.metrics.minScrollExtent && mounted) {
              this._hideFab.forward();
            }
            break;
          case ScrollDirection.reverse:
            if (userScroll.metrics.maxScrollExtent != userScroll.metrics.minScrollExtent && mounted) {
              this._hideFab.reverse();
            }
            break;
          case ScrollDirection.idle:
            break;
        }
      }
    }
    return false;
  }

  void _addNewTaskForm(BuildContext buildContext) {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Theme.of(buildContext).accentColor,
      context: buildContext,
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: GestureDetector(
              onTap: () {},
              child: NewTask(
                localization: this._getCurrentLocalizationName(),
              ),
              behavior: HitTestBehavior.opaque,
            ),
          ),
        );
      },
    );
  }

  void _selectPage(int index) {
    if (index >= 0 && index < _pages.length) {
      setState(() {
        this._hideFab.forward();
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
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: AutoSizeText(
                      text,
                      style: TextStyle(color: this._getItemColor(index)),
                      minFontSize: 10,
                      maxFontSize: 24,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            onTap: () => this._selectPage(index),
          ),
        ),
      );

  Widget _buildIconInbox(IconData iconData, String text, int index) => Container(
        width: double.infinity,
        height: 60,
        child: Material(
          color: this._getBgColor(index),
          child: InkWell(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Badge(
                  showBadge: Provider.of<TaskProvider>(context).countInboxDelegated() != null && Provider.of<TaskProvider>(context).countInboxDelegated() > 0,
                  badgeColor: index == _selectedPageIndex ? Theme.of(context).accentColor : Theme.of(context).primaryColor,
                  badgeContent: Text(
                    Provider.of<TaskProvider>(context).countInboxDelegated().toString(),
                    style: TextStyle(
                      color: index == _selectedPageIndex ? Theme.of(context).primaryColor : Theme.of(context).accentColor,
                    ),
                  ),
                  child: Icon(iconData),
                ),
                Flexible(
                  child: AutoSizeText(
                    text,
                    style: TextStyle(color: this._getItemColor(index)),
                    textAlign: TextAlign.center,
                    minFontSize: 10,
                    maxFontSize: 24,
                  ),
                ),
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
  }

  @override
  Widget build(BuildContext context) {
    final isFirstLogin = Provider.of<AuthProvider>(context).firstLogin;

    return isFirstLogin
        ? TutorialScreen()
        : NotificationListener<ScrollNotification>(
            onNotification: this._handleScrollNotification,
            child: AnimatedContainer(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.6),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              transform: Matrix4.translationValues(offsetX, offsetY, 0)..scale(scale),
              duration: Duration(milliseconds: 300),
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
                  appBar: NewTaskAppBar(
                    title: this._pages[_selectedPageIndex]['title'],
                    leadingButton: IconButton(
                      icon: Badge(
                        position: BadgePosition.topStart(),
                        showBadge:
                            Provider.of<DelegateProvider>(context).received.length > 0 || Provider.of<DelegateProvider>(context).numberOfPermissionRequest > 0,
                        badgeColor: Theme.of(context).primaryColor,
                        child: Icon(Icons.menu),
                      ),
                      onPressed: () {
                        isDrawerVisible ? _changeTranform(0, 0, 1) : _changeTranform(230, 70, 0.8);
                      },
                    ),
                  ),
                  body: this._pages[_selectedPageIndex]['page'],
                  floatingActionButton: ScaleTransition(
                    scale: this._hideFab,
                    alignment: Alignment.bottomCenter,
                    child: FloatingActionButton(
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 50,
                      ),
                      onPressed: () {
                        this._addNewTaskForm(context);
                      },
                    ),
                  ),
                  bottomNavigationBar: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      border: Border(
                        top: BorderSide(
                          color: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).primaryColorDark : Colors.black,
                          width: 1.0,
                        ),
                      ),
                    ),
                    child: BottomNavigationBar(
                      selectedFontSize: 0,
                      currentIndex: _selectedPageIndex,
                      type: BottomNavigationBarType.fixed,
                      items: [
                        BottomNavigationBarItem(
                          icon: _buildIconInbox(Icons.inbox_outlined, AppLocalizations.of(context).inbox, 0),
                          title: SizedBox.shrink(),
                        ),
                        BottomNavigationBarItem(
                          icon: _buildIcon(Icons.access_time, AppLocalizations.of(context).anytime, 1),
                          title: SizedBox.shrink(),
                        ),
                        BottomNavigationBarItem(
                          icon: _buildIcon(Icons.calendar_today, AppLocalizations.of(context).scheduled, 2),
                          title: SizedBox.shrink(),
                        ),
                        BottomNavigationBarItem(
                          icon: _buildIcon(Icons.person_outline_outlined, AppLocalizations.of(context).delegated, 3),
                          title: SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
