import 'package:flutter/material.dart';
import 'package:productive_app/provider/auth_provider.dart';
import 'package:productive_app/provider/theme_provider.dart';
import 'package:productive_app/widget/drawer/main_drawer.dart';
import 'package:provider/provider.dart';
import 'tabs_screen.dart';

class MainScreen extends StatefulWidget {
  static const routeName = '/main-screen';

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    Provider.of<ThemeProvider>(context, listen: false).getUserMode();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MainDrawer(username: Provider.of<AuthProvider>(context, listen: false).email),
          TabsScreen(),
        ],
      ),
    );
  }
}
