import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:productive_app/provider/location_provider.dart';
import 'package:provider/provider.dart';
import '../../config/color_themes.dart';
import '../../provider/tag_provider.dart';

class SearchAppBar extends StatefulWidget with PreferredSizeWidget {
  final String title;
  final String searchingName;

  SearchAppBar({
    @required this.title,
    @required this.searchingName,
  });

  @override
  Size get preferredSize => Size.fromHeight(50);

  @override
  _SearchAppBarState createState() => _SearchAppBarState();
}

class _SearchAppBarState extends State<SearchAppBar> {
  final _formKey = GlobalKey<FormFieldState>();
  bool searchBarActive = false;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      title: this.searchBarActive
          ? TextFormField(
              autofocus: true,
              key: this._formKey,
              onChanged: (value) {
                this.widget.searchingName == 'tag' ? Provider.of<TagProvider>(context, listen: false).setSearchingText(value) : Provider.of<LocationProvider>(context, listen: false).setSearchingText(value);
              },
              decoration: ColorThemes.searchFormFieldDecoration(
                context,
                'Enter ${this.widget.searchingName} name',
                () {
                  this._formKey.currentState.reset();
                  this.widget.searchingName == 'tag' ? Provider.of<TagProvider>(context, listen: false).clearSearchingText() : Provider.of<LocationProvider>(context, listen: false).clearSearchingText();
                },
              ),
            )
          : Text(
              this.widget.title,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).primaryColor,
              ),
            ),
      systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.black),
      backgroundColor: Theme.of(context).accentColor,
      iconTheme: Theme.of(context).iconTheme,
      backwardsCompatibility: false,
      brightness: Brightness.dark,
      actions: [
        IconButton(
          icon: Icon(Icons.search_outlined),
          onPressed: () {
            if (this.searchBarActive) {
              this._formKey.currentState.reset();
              this.widget.searchingName == 'tag' ? Provider.of<TagProvider>(context, listen: false).clearSearchingText() : Provider.of<LocationProvider>(context, listen: false).clearSearchingText();
            }

            setState(() {
              this.searchBarActive = !this.searchBarActive;
            });
          },
        ),
      ],
    );
  }
}
