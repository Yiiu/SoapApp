import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soap_app/config/router.dart';
import 'package:soap_app/provider/account.dart';
import 'package:soap_app/provider/home.dart';
import 'package:soap_app/ui/widget/app_bar.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key key, this.controller, this.logout}) : super(key: key);

  final TabController controller;

  final Function logout;

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  TabController controller;
  Function logoutCb;

  @override
  void initState() {
    super.initState();
    controller = widget.controller;
    logoutCb = widget.logout;
  }

  void logout() {
    logoutCb();
    Provider.of<AccountProvider>(context, listen: false).logout();
    Provider.of<HomeProvider>(context, listen: false).reset();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return FixedAppBarWrapper(
      appBar: const SoapAppBar(
        centerTitle: false,
        elevation: 0.1,
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Home',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
      body: Container(
        color: theme.backgroundColor,
        child: Column(
          children: [
            Consumer<AccountProvider>(
              builder: (
                BuildContext context,
                AccountProvider account,
                Widget child,
              ) {
                return Text(account.user?.username ?? '');
              },
            ),
            FlatButton(
              onPressed: logout,
              child: const Text('退出登录'),
            )
          ],
        ),
      ),
    );
  }
}
