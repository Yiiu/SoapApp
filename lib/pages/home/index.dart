import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:soap_app/config/router.dart';
import 'package:soap_app/store/index.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'new/new.dart';
import 'profile/profile.dart';

class SoapBottomNavigationBarItem {
  const SoapBottomNavigationBarItem({
    required this.icon,
    required this.title,
  });

  final String icon;
  final String title;
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  List<Picture> list = <Picture>[];
  int _selectedIndex = 0;
  final int _addIndex = 1;
  final int _loginIndex = 2;

  static List<SoapBottomNavigationBarItem> get bottomBar =>
      <SoapBottomNavigationBarItem>[
        const SoapBottomNavigationBarItem(
          icon: 'assets/remix/home-2.svg',
          title: 'Home',
        ),
        const SoapBottomNavigationBarItem(
          icon: 'assets/remix/add-circle.svg',
          title: 'Add',
        ),
        const SoapBottomNavigationBarItem(
          icon: 'assets/remix/user.svg',
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
    // if (index == _loginIndex && !accountStore.isLogin) {
    //   Navigator.pushNamed(context, RouteName.login);
    //   return;
    // }
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
    final ThemeData theme = Theme.of(context);
    return Material(
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: tabController,
                  children: <Widget>[
                    const NewView(),
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
                  sigmaX: 16,
                  sigmaY: 16,
                ),
                child: Container(
                  color: theme.cardColor.withOpacity(.85),
                  height: 56,
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 22),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    height: 26,
                                    width: 26,
                                    child: SvgPicture.asset(
                                      bar.icon,
                                      color: _selectedIndex ==
                                              bottomBar.indexOf(bar)
                                          ? theme.primaryColor
                                          : theme.textTheme.bodyText2!.color!
                                              .withOpacity(.5),
                                    ),
                                  )
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
