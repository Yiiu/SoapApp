import 'dart:ui';

import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../graphql/query/picture.dart';
import '../../model/picture.dart';
import '../../ui/widget/header.dart';
import '../../ui/widget/picture_item.dart';

List<int> products = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Picture> list = [];
  int _selectedIndex = 0;

  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: 4,
      vsync: ScrollableState(),
      initialIndex: _selectedIndex,
    );
  }

  handleTabChange(int index) {
    setState(() {
      _selectedIndex = index;
      tabController.index = index;
    });
  }

  Widget _buildItem(Picture picture) {
    return PictureItem(picture: picture);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          appBar(),
          // TabBarView(
          //   controller: tabController,
          //   children: <Widget>[
          Expanded(child: container()),
          // Text('Search'),
          // Text('Add'),
          // Text('User'),
          //   ],
          // )
        ],
      ),
      bottomNavigationBar: navigationBar(),
    );
  }

  Widget appBar() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color.fromRGBO(243, 243, 244, 1), width: 1),
        ),
      ),
      child: SizedBox(
        height: 60,
        child: Row(
          children: <Widget>[
            // Padding(
            //   padding: const EdgeInsets.only(top: 4),
            //   child: Container(
            //     width: AppBar().preferredSize.height - 8,
            //     height: AppBar().preferredSize.height - 8,
            //   ),
            // ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Text(
                  'Home',
                  style: GoogleFonts.rubik(
                    textStyle: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 0, right: 8),
              child: Container(
                width: AppBar().preferredSize.height - 8,
                height: AppBar().preferredSize.height - 8,
                color: Colors.white,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(
                      AppBar().preferredSize.height,
                    ),
                    child: Icon(
                      FeatherIcons.bell,
                    ),
                    onTap: () {},
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget container() {
    return TabBarView(
      physics: NeverScrollableScrollPhysics(),
      controller: tabController,
      children: <Widget>[
        SafeArea(
          child: CustomScrollView(
            physics: BouncingScrollPhysics(),
            semanticChildCount: products.length,
            slivers: <Widget>[
              SliverToBoxAdapter(),
              Query(
                options: QueryOptions(
                  documentNode: gql(pictures),
                  fetchPolicy: FetchPolicy.cacheAndNetwork,
                  // pollInterval: 15,
                  variables: {
                    'query': {
                      'page': 1,
                      'pageSize': 30,
                    }
                  },
                ),
                builder: (QueryResult result,
                    {VoidCallback refetch, FetchMore fetchMore}) {
                  if (result.hasException) {
                    return Text(result.exception.toString());
                  }
                  if (result.loading) {
                    return SliverFillRemaining(
                      child: Container(
                        padding: EdgeInsets.all(24.0),
                        child: CupertinoActivityIndicator(),
                      ),
                    );
                  }
                  List pictures =
                      Picture.fromListJson(result.data['pictures']['data']);
                  return SliverList(
                    delegate: SliverChildListDelegate(
                      pictures.map((picture) {
                        return _buildItem(picture);
                      }).toList(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        Text('2'),
        Text('3'),
        Text('4'),
      ],
    );
  }

  Widget navigationBar() {
    double gap = 8.5;
    return Container(
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
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
                backgroundColor: Colors.purple.withOpacity(.2),
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
                backgroundColor: Colors.pink.withOpacity(.2),
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
                backgroundColor: Colors.amber[600].withOpacity(.2),
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
                backgroundColor: Colors.teal.withOpacity(.2),
              ),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: handleTabChange,
          ),
        ),
      ),
    );
  }
}
