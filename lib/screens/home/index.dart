import 'dart:ui';

import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:soap_app/screens/home/search.dart';

import '../../model/picture.dart';
import 'home.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  List<Picture> list = [];
  int _selectedIndex = 0;

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
      if (index == 2) {
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
    return Scaffold(
      body: CupertinoScaffold(
        body: Column(
          children: <Widget>[
            Expanded(
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                controller: tabController,
                children: <Widget>[
                  HomeView(),
                  SearchView(),
                  Text(''),
                  Text('4'),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: theme.backgroundColor, boxShadow: [
          BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1))
        ]),
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
              tabs: [
                GButton(
                  icon: FeatherIcons.home,
                  text: 'Home',
                  iconActiveColor: Colors.purple,
                  iconColor: Colors.black26,
                  textStyle: GoogleFonts.rubik(
                    textStyle: TextStyle(
                      color: Colors.purple,
                      letterSpacing: 2,
                    ),
                  ),
                  backgroundColor: Colors.purple.withOpacity(0),
                ),
                GButton(
                  icon: FeatherIcons.search,
                  text: 'Search',
                  iconActiveColor: Colors.pink,
                  iconColor: Colors.black26,
                  textStyle: GoogleFonts.rubik(
                    textStyle: TextStyle(
                      color: Colors.pink,
                      letterSpacing: 2,
                    ),
                  ),
                  backgroundColor: Colors.pink.withOpacity(0),
                ),
                GButton(
                  icon: FeatherIcons.plus,
                  text: 'Add',
                  iconActiveColor: Colors.amber[600],
                  iconColor: Colors.black26,
                  textStyle: GoogleFonts.rubik(
                    textStyle: TextStyle(
                      color: Colors.amber[600],
                      letterSpacing: 2,
                    ),
                  ),
                  backgroundColor: Colors.amber[600].withOpacity(0),
                ),
                GButton(
                  icon: FeatherIcons.user,
                  text: 'User',
                  iconActiveColor: Colors.teal,
                  iconColor: Colors.black26,
                  textStyle: GoogleFonts.rubik(
                    textStyle: TextStyle(
                      color: Colors.teal,
                      letterSpacing: 2,
                    ),
                  ),
                  backgroundColor: Colors.teal.withOpacity(0),
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: handleTabChange,
            ),
          ),
        ),
      ),
    );
  }
}
