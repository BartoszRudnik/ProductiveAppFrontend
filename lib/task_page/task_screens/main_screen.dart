import 'package:flutter/material.dart';
import 'package:productive_app/login/providers/auth_provider.dart';
import 'package:productive_app/task_page/widgets/main_drawer.dart';
import 'package:provider/provider.dart';

import 'tabs_screen.dart';

class MainScreen extends StatefulWidget {
  static const routeName = ('/main-screen');

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
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
