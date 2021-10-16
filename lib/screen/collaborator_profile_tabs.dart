import 'package:flutter/material.dart';
import '../model/collaborator.dart';
import 'active_tasks_screen.dart';
import 'collaborator_profile.dart';
import 'recent_tasks.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:auto_size_text/auto_size_text.dart';

class CollaboratorProfileTabs extends StatefulWidget {
  static const routeName = "/collaboratorProfileTabs";

  @override
  _CollaboratorProfileTabsState createState() => _CollaboratorProfileTabsState();
}

class _CollaboratorProfileTabsState extends State<CollaboratorProfileTabs> {
  List<Map<String, Object>> _pages;

  Color _selectedItemColor;
  Color _unselectedItemColor;
  Color _selectedBgColor;
  Color _unselectedBgColor;
  int _selectedPageIndex = 0;

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

    final collaborator = ModalRoute.of(context).settings.arguments as Collaborator;

    _pages = [
      {
        'page': CollaboratorProfile(
          collaboratorUuid: collaborator.uuid,
        ),
        'title': 'Collaborator profile',
      },
      {
        'page': RecentTasks(
          collaborator: collaborator,
        ),
        'title': 'Recently finished tasks',
      },
      {
        'page': ActiveTasks(
          collaborator: collaborator,
        ),
        'title': 'Active tasks',
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
        height: 65,
        child: Material(
          color: this._getBgColor(index),
          child: InkWell(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  child: AutoSizeText(
                    text,
                    style: TextStyle(color: this._getItemColor(index)),
                    textAlign: TextAlign.center,
                    minFontSize: 10,
                    maxFontSize: 16,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
            onTap: () => this._selectPage(index),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      child: Scaffold(
        body: _pages[this._selectedPageIndex]['page'],
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
                icon: _buildIcon(Icons.settings, AppLocalizations.of(context).collaboratorProfile, 0),
                title: SizedBox.shrink(),
              ),
              BottomNavigationBarItem(
                icon: _buildIcon(Icons.done_all_outlined, AppLocalizations.of(context).recentlyFinishedTasks, 1),
                title: SizedBox.shrink(),
              ),
              BottomNavigationBarItem(
                icon: _buildIcon(Icons.present_to_all_outlined, AppLocalizations.of(context).activeTasks, 2),
                title: SizedBox.shrink(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
