import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as extended;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soap_app/config/theme.dart';
import 'package:soap_app/graphql/graphql.dart';
import 'package:soap_app/model/user.dart';
import 'package:soap_app/widget/picture_list.dart';

import 'stores/user_store.dart';
import 'widgets/collection_list.dart';
import 'widgets/sliver_head.dart';

class UserPage extends StatefulWidget {
  const UserPage({
    Key? key,
    required this.user,
    this.heroId,
  }) : super(key: key);

  final User user;

  final String? heroId;

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage>
    with SingleTickerProviderStateMixin {
  final UserPageStore _pageStore = UserPageStore();

  late User user;
  late TabController tabController;
  final int _selectedIndex = 0;

  final double _tabBarHeight = 55;
  final double titleHeight = 150;

  final GlobalKey<State<StatefulWidget>> _pictureListKey = GlobalKey();
  final GlobalKey<State<StatefulWidget>> _collectionListKey = GlobalKey();

  @override
  void initState() {
    user = widget.user;
    _pageStore.init(user);
    _pageStore.watchQuery();
    tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: _selectedIndex,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Material(
      child: Container(
        color: theme.cardColor,
        child: extended.ExtendedNestedScrollView(
          physics: const BouncingScrollPhysics(),
          headerSliverBuilder:
              (BuildContext context, bool? innerBoxIsScrolled) {
            return <Widget>[
              SliverHeader(
                tabBarHeight: _tabBarHeight,
                store: _pageStore,
                tabController: tabController,
              ),
            ];
          },
          pinnedHeaderSliverHeightBuilder: () {
            return MediaQuery.of(context).padding.top +
                appBarHeight +
                _tabBarHeight;
          },
          body: Container(
            color: theme.backgroundColor,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: TabBarView(
                    physics: const BouncingScrollPhysics(),
                    controller: tabController,
                    children: <Widget>[
                      RepaintBoundary(
                        key: _pictureListKey,
                        child: PictureList(
                          document: addFragments(
                            userPictures,
                            [...pictureListFragmentDocumentNode],
                          ),
                          label: 'userPicturesByName',
                          variables: {
                            'username': user.username,
                          },
                        ),
                      ),
                      RepaintBoundary(
                        key: _collectionListKey,
                        child: UserCollectionList(username: user.username),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
