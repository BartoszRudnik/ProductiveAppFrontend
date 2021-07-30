import 'package:flutter/material.dart';
import '../widget/appBar/login_appbar.dart';
import '../widget/login_widget.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/sign-in-screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LoginAppBar(),
      backgroundColor: Theme.of(context).accentColor,
      body: LoginWidget(),
    );
  }
}