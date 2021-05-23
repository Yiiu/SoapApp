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

  Widget _userCount({
    int? count,
    required String title,
    Function? onTap,
  }) {
    final ThemeData theme = Theme.of(context);
    final Widget content = Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
      child: Column(
        children: <Widget>[
          Text(
            count != null ? count.toString() : '--',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(.8),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
    if (onTap == null) {
      return Expanded(
        flex: 1,
        child: content,
      );
    }
    return Expanded(
      flex: 1,
      child: TouchableOpacity(
        activeOpacity: activeOpacity,
        behavior: HitTestBehavior.translucent,
        onTap: () {
          onTap();
        },
        child: content,
      ),
    );
  }

  Widget _buildSliverHead(User user) {
    final ThemeData theme = Theme.of(context);
    return SliverPersistentHeader(
      // floating: true,
      pinned: true,
      delegate: LargeCustomHeader(
        navBarHeight: appBarHeight + MediaQuery.of(context).padding.top,
        titleHeight: 150,
        tabBarHeight: _tabBarHeight,
        barCenterTitle: false,
        backgroundImage: getPictureUrl(
          key: user.cover ?? user.avatar,
          style: user.cover != null ? PictureStyle.blur : PictureStyle.blur,
        ),
        titleTextStyle: TextStyle(
          color: theme.cardColor,
          fontSize: 36,
        ),
        title: UserHeaderContent(user: user),
        tabBar: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Color(0x0d000000),
                blurRadius: 0.2 * 1.0,
                offset: Offset(0, 0.2 * 2.0),
              )
            ],
          ),
          child: TabBar(
            controller: tabController,
            tabs: const <Widget>[
              Tab(
                text: '照片',
              ),
              Tab(
                text: '收藏夹',
              ),
            ],
            onTap: (int index) {
              // setState(() {
              //   _tabIndex = index;
              // });
            },
            labelColor: theme.textTheme.bodyText2!.color,
            indicator: MaterialIndicator(
              height: 2,
              topLeftRadius: 4,
              topRightRadius: 4,
              horizontalPadding: 80,
              tabPosition: TabPosition.bottom,
              color: theme.primaryColor.withOpacity(.8),
            ),
          ),
        ),
        bar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Row(
            children: <Widget>[
              Avatar(
                size: 38,
                image: user.avatarUrl,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  user.fullName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 17,
                  ),
                ),
              )
            ],
          ),
        ),
        actions: [
          TouchableOpacity(
            activeOpacity: activeOpacity,
            onTap: () {
              // showBasicModalBottomSheet(
              //   enableDrag: true,
              //   context: context,
              //   builder: (BuildContext context) =>
              //       PictureDetailMoreHandle(
              //     picture: data,
              //   ),
              // );
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(
                FeatherIcons.moreHorizontal,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
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
                  _buildSliverHead(data),
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
