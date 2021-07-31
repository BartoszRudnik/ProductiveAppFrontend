import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:productive_app/provider/delegate_provider.dart';
import 'package:productive_app/provider/theme_provider.dart';
import 'package:productive_app/screen/settings_screen.dart';
import 'package:provider/provider.dart';

import 'collaborators_screen.dart';

class SettingsTabsScreen extends StatefulWidget {
  static const routeName = "/settingTabsScreen";

  @override
  _SettingsTabsScreenState createState() => _SettingsTabsScreenState();
}

class _SettingsTabsScreenState extends State<SettingsTabsScreen> {
  List<Map<String, Object>> _pages;

  Color _selectedItemColor;
  Color _unselectedItemColor;
  Color _selectedBgColor;
  Color _unselectedBgColor;
  int _selectedPageIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

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
  }

  @override
  void initState() {
    super.initState();

    _pages = [
      {
        'page': SettingsScreen(),
        'title': 'Inbox',
      },
      {
        'page': CollaboratorsScreen(),
        'title': 'Collaborators',
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
  Widget _buildIcon(IconData iconData, String text, int index, bool isBadge) => Container(
        width: double.infinity,
        height: 60,
        child: Material(
          color: this._getBgColor(index),
          child: InkWell(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                isBadge
                    ? Badge(
                        position: BadgePosition.topStart(),
                        showBadge: Provider.of<DelegateProvider>(context).received.length > 0,
                        badgeColor: index == _selectedPageIndex ? Theme.of(context).accentColor : Theme.of(context).primaryColor,
                        badgeContent: Text(
                          Provider.of<DelegateProvider>(context).received.length.toString(),
                          style: TextStyle(
                            color: index == _selectedPageIndex ? Theme.of(context).primaryColor : Theme.of(context).accentColor,
                          ),
                        ),
                        child: Icon(iconData),
                      )
                    : Icon(iconData),
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
          child: BottomNavigationBar(
            selectedFontSize: 0,
            currentIndex: _selectedPageIndex,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                icon: _buildIcon(Icons.settings, "Settings", 0, false),
                title: SizedBox.shrink(),
              ),
              BottomNavigationBarItem(
                icon: _buildIcon(Icons.people_outline, "Collaborators", 1, true),
                title: SizedBox.shrink(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
