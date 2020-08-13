import 'dart:ui';

import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:soap_app/screens/account/login.dart';
import 'package:soap_app/screens/animtetest/index.dart';
import 'package:soap_app/screens/home/search.dart';
import 'package:soap_app/screens/home/user.dart';

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
    tabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: _selectedIndex,
    );
  }

  void handleTabChange(int index) {
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
      if (index == _loginIndex) {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (BuildContext context) {
              return const LoginView();
            },
          ),
        );
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
                    const ProfileView(),
                    const Text('4'),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: theme.backgroundColor,
              boxShadow: [
                BoxShadow(
                  blurRadius: 5,
                  color: const Color(0xFFE1E7EF).withOpacity(0.6),
                )
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(10).add(
                  const EdgeInsets.only(top: 5),
                ),
                child: GNav(
                  gap: gap,
                  activeColor: Colors.white,
                  color: Colors.grey[400],
                  iconSize: 18,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
                  duration: const Duration(milliseconds: 400),
                  tabBackgroundColor: Colors.grey[800],
                  tabs: bottomBar
                      .map<GButton>(
                          (SoapBottomNavigationBarItem bar) => GButton(
                                icon: bar.icon,
                                text: bar.title,
                                iconActiveColor: Colors.white,
                                iconColor: Colors.black87,
                                textStyle: const TextStyle(
                                  color: Colors.white,
                                  letterSpacing: 2,
                                ),
                                backgroundColor: Colors.black87,
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
