import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:soap_app/config/router.dart';
import 'package:soap_app/store/index.dart';

import 'new/index.dart';
import 'profile/profile.dart';

class SoapBottomNavigationBarItem {
  const SoapBottomNavigationBarItem({
    required this.icon,
    required this.title,
    IconData? activeIcon,
  }) : activeIcon = activeIcon ?? icon;

  final IconData icon;
  final String title;
  final IconData activeIcon;
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

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
        const SoapBottomNavigationBarItem(
          icon: FeatherIcons.plus,
          title: 'Add',
        ),
        const SoapBottomNavigationBarItem(
          icon: FeatherIcons.user,
          title: 'Profile',
        ),
      ];

  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: _selectedIndex,
    );
  }

  void handleTabChange(int index) {
    if (index == _addIndex) {
      if (!accountStore.isLogin) {
        Navigator.pushNamed(context, RouteName.login);
        return;
      }
    }
    if (index == _loginIndex && !accountStore.isLogin) {
      Navigator.pushNamed(context, RouteName.login);
      return;
    }
    setState(() {
      _selectedIndex = index;
      tabController.index = index;
    });
  }

  void signup() {
    tabController.animateTo(0);
    setState(() {
      _selectedIndex = 0;
      tabController.index = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    const double gap = 8.5;
    final ThemeData theme = Theme.of(context);
    return Material(
      child: Stack(
        children: [
          Column(
            children: <Widget>[
              Expanded(
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: tabController,
                  children: <Widget>[
                    NewView(),
                    const Text(''),
                    ProfileView(
                      controller: tabController,
                      signupCb: signup,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 12,
                  sigmaY: 12,
                ),
                child: Container(
                  color: Colors.white.withOpacity(.85),
                  height: 64,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: bottomBar
                        .map<Widget>(
                          (SoapBottomNavigationBarItem bar) => GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              handleTabChange(bottomBar.indexOf(bar));
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 22),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    bar.icon,
                                    size: 28,
                                    color:
                                        _selectedIndex == bottomBar.indexOf(bar)
                                            ? theme.primaryColor
                                            : theme.textTheme.bodyText1!.color!
                                                .withOpacity(.4),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      // bottomNavigationBar: SafeArea(
      //   top: false,
      //   child: ,
      // ),
    );
  }
}
