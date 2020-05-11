import 'dart:ui';

import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
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
  HomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  List<Picture> list = [];
  int _selectedIndex = 0;
  int _addIndex = 1;

  static List<SoapBottomNavigationBarItem> get bottomBar => [
        SoapBottomNavigationBarItem(
          icon: FeatherIcons.home,
          title: 'Home',
        ),
        // SoapBottomNavigationBarItem(
        //   icon: FeatherIcons.search,
        //   title: 'Search',
        // ),
        SoapBottomNavigationBarItem(
          icon: FeatherIcons.plus,
          title: 'Add',
        ),
        SoapBottomNavigationBarItem(
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

  handleTabChange(int index) {
    setState(() {
      if (index == _addIndex) {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (BuildContext context) {
              return SharedAxisTransitionDemo();
            },
          ),
        );
        // showCupertinoModalBottomSheet(
        //   context: context,
        //   expand: true,
        //   builder: (context, scrollController) => Material(
        //     child: CupertinoPageScaffold(
        //       navigationBar: CupertinoNavigationBar(
        //         leading: Container(),
        //         middle: Text('添加图片'),
        //       ),
        //       child: SafeArea(
        //         child: ListView(
        //           shrinkWrap: true,
        //           controller: scrollController,
        //           physics: BouncingScrollPhysics(),
        //           children: <Widget>[
        //             Text('24124'),
        //           ],
        //         ),
        //       ),
        //     ),
        //   ),
        // );
        return;
      }
      _selectedIndex = index;
      tabController.index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    double gap = 8.5;
    final theme = Theme.of(context);
    return Material(
      child: CupertinoPageScaffold(
        child: Scaffold(
          body: Column(
            children: <Widget>[
              Expanded(
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: tabController,
                  children: <Widget>[
                    HomeView(),
                    SearchView(),
                    ProfileView(),
                    Text('4'),
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
                  color: Color(0xFFE1E7EF).withOpacity(0.6),
                )
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(10).add(EdgeInsets.only(top: 5)),
                child: GNav(
                  gap: gap,
                  activeColor: Colors.white,
                  color: Colors.grey[400],
                  iconSize: 18,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 6),
                  duration: Duration(milliseconds: 400),
                  tabBackgroundColor: Colors.grey[800],
                  tabs: bottomBar
                      .map<GButton>((bar) => GButton(
                            icon: bar.icon,
                            text: bar.title,
                            iconActiveColor: Colors.white,
                            iconColor: Colors.black87,
                            textStyle: TextStyle(
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
