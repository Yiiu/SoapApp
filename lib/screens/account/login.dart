import 'package:flutter/material.dart';
import 'package:soap_app/ui/widget/app_bar.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      color: theme.backgroundColor,
      child: Column(
        children: [
          Text('登录'),
        ],
      ),
    );
  }
}
