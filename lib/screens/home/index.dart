import 'dart:ui';

import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:soap_app/config/router.dart';
import 'package:soap_app/provider/account.dart';
import 'package:soap_app/screens/animtetest/index.dart';
import 'package:soap_app/screens/home/search.dart';
import 'package:soap_app/screens/home/user/user.dart';

import '../../model/picture.dart';
import 'home.dart';

class SoapBottomNavigationBarItem {
  const SoapBottomNavigationBarItem({
    @required this.icon,
    this.title,
    IconData activeIcon,
  }) : activeIcon = activeIcon ?? icon;

  final IconData icon;
  final String title;
  final IconData activeIcon;
}

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  List<Picture> list = [];
  int _selectedIndex = 0;
  final int _addIndex = 1;
  final int _loginIndex = 2;

  static List<SoapBottomNavigationBarItem> get bottomBar => [
        const SoapBottomNavigationBarItem(
          icon: FeatherIcons.home,
          title: 'Home',
        ),
        // SoapBottomNavigationBarItem(
        //   icon: FeatherIcons.search,
        //   title: 'Search',
        // ),
        const SoapBottomNavigationBarItem(
          icon: FeatherIcons.plus,
          title: 'Add',
        ),
        const SoapBottomNavigationBarItem(
          icon: FeatherIcons.user,
          title: 'Profile',
        ),
      ];

  TabController tabController;

  @override
  void initState() {
    super.initState();
    Provider.of<AccountProvider>(context, listen: false);
    tabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: _selectedIndex,
    );
  }

  void handleTabChange(int index) {
    final account = Provider.of<AccountProvider>(context, listen: false);
    setState(() {
      if (index == _addIndex) {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (BuildContext context) {
              return SharedAxisTransitionDemo();
            },
          ),
        );
        return;
      }
      if (index == _loginIndex && !account.isAccount) {
        Navigator.pushNamed(context, RouteName.login);
        return;
      }
      _selectedIndex = index;
      tabController.index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    const double gap = 8.5;
    final ThemeData theme = Theme.of(context);
    return Material(
      child: CupertinoPageScaffold(
        child: Scaffold(
          body: Column(
            children: <Widget>[
              Expanded(
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: tabController,
                  children: <Widget>[
                    HomeView(),
                    const SearchView(),
                    ProfileView(
                        controller: tabController,
                        logout: () {
                          handleTabChange(0);
                        }),
                    const Text('4'),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: theme.cardColor,
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(10).add(
                  const EdgeInsets.only(top: 5),
                ),
                child: GNav(
                  gap: gap,
                  activeColor: theme.cardColor,
                  color: Colors.grey[400],
                  iconSize: 18,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
                  duration: const Duration(milliseconds: 400),
                  tabBackgroundColor: Colors.grey[800],
                  tabs: bottomBar
                      .map<GButton>((SoapBottomNavigationBarItem bar) =>
                          GButton(
                            icon: bar.icon,
                            text: bar.title,
                            iconActiveColor: theme.cardColor,
                            iconColor: theme.textTheme.bodyText2.color,
                            textStyle: TextStyle(
                              color: theme.cardColor,
                              letterSpacing: 2,
                            ),
                            backgroundColor: theme.textTheme.bodyText2.color,
                          ))
                      .toList(),
                  selectedIndex: _selectedIndex,
                  onTabChange: handleTabChange,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
