import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:soap_app/config/const.dart';
import 'package:soap_app/config/theme.dart';
import 'package:soap_app/graphql/fragments.dart';
import 'package:soap_app/graphql/gql.dart';
import 'package:soap_app/graphql/query.dart';
import 'package:soap_app/model/user.dart';
import 'package:soap_app/pages/user/widgets/collection_list.dart';
import 'package:soap_app/pages/user/widgets/sliver_head.dart';
import 'package:soap_app/pages/user/widgets/user_header_content.dart';
import 'package:soap_app/utils/picture.dart';
import 'package:soap_app/widget/avatar.dart';
import 'package:soap_app/widget/large_custom_header.dart';
import 'package:soap_app/widget/picture_list.dart';
import 'package:touchable_opacity/touchable_opacity.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as extended;

class UserPage extends StatefulWidget {
  UserPage({
    Key? key,
    required this.user,
    this.heroId,
  }) : super(key: key);

  final User user;

  String? heroId;

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage>
    with SingleTickerProviderStateMixin {
  late User user;
  late TabController tabController;
  final int _selectedIndex = 0;

  final double _tabBarHeight = 55;
  final double titleHeight = 150;

  final _pictureListKey = GlobalKey();
  final _collectionListKey = GlobalKey();

  @override
  void initState() {
    user = widget.user;
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
    final Map<String, String> variables = {
      'username': user.username,
    };
    return Material(
      child: Container(
        color: theme.cardColor,
        child: Query(
          options: QueryOptions(
            document: addFragments(
              userInfo,
              [...userDetailFragmentDocumentNode],
            ),
            variables: variables,
          ),
          builder: (
            QueryResult result, {
            Refetch? refetch,
            FetchMore? fetchMore,
          }) {
            User data = user;
            if (result.data != null && result.data!['user'] != null) {
              data =
                  User.fromJson(result.data!['user'] as Map<String, dynamic>);
            }
            return extended.NestedScrollView(
              physics: const BouncingScrollPhysics(),
              headerSliverBuilder:
                  (BuildContext context, bool? innerBoxIsScrolled) {
                return <Widget>[
                  SliverHeader(
                    tabBarHeight: _tabBarHeight,
                    user: data,
                    tabController: tabController,
                  ),
                ];
              },
              pinnedHeaderSliverHeightBuilder: () {
                return MediaQuery.of(context).padding.top +
                    appBarHeight +
                    _tabBarHeight;
              },
              innerScrollPositionKeyBuilder: () {
                final String index = 'Tab${tabController.index.toString()}';
                return Key(index);
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
                          extended.NestedScrollViewInnerScrollPositionKeyWidget(
                            const Key('Tab0'),
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
                          ),
                          RepaintBoundary(
                            key: _collectionListKey,
                            child: extended
                                .NestedScrollViewInnerScrollPositionKeyWidget(
                              const Key('Tab1'),
                              UserCollectionList(username: user.username),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
