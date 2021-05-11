import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:soap_app/config/const.dart';
import 'package:soap_app/config/theme.dart';
import 'package:soap_app/graphql/fragments.dart';
import 'package:soap_app/graphql/gql.dart';
import 'package:soap_app/graphql/query.dart';
import 'package:soap_app/model/user.dart';
import 'package:soap_app/pages/user/widgets/collection_list.dart';
import 'package:soap_app/widget/follow_modal.dart';
import 'package:soap_app/pages/user/widgets/picture_list.dart';
import 'package:soap_app/utils/picture.dart';
import 'package:soap_app/widget/app_bar.dart';
import 'package:soap_app/widget/avatar.dart';
import 'package:soap_app/widget/large_custom_header.dart';
import 'package:soap_app/widget/modal_bottom_sheet.dart';
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

  int _tabIndex = 0;

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
            style: GoogleFonts.rubik(
              textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            title,
            style: GoogleFonts.rubik(
              textStyle: TextStyle(
                color: Colors.white.withOpacity(.8),
                fontSize: 14,
              ),
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
        title: Column(
          children: <Widget>[
            TouchableOpacity(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: <Widget>[
                    if (widget.heroId == null)
                      Avatar(
                        size: 56,
                        image: getPictureUrl(key: user.avatar),
                      )
                    else
                      Hero(
                        tag: 'user-${user.username}-${widget.heroId}',
                        child: Avatar(
                          size: 56,
                          image: getPictureUrl(key: user.avatar),
                        ),
                      ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        user.fullName,
                        style: GoogleFonts.rubik(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              child: Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  _userCount(title: '赞', count: user.likesCount),
                  _userCount(
                    title: '关注',
                    count: user.followedCount,
                    onTap: () {
                      showBasicModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) => FollowModal(
                          key: ValueKey('followedModal'),
                          type: FollowModalType.followed,
                          scrollController: ModalScrollController.of(context),
                          id: user.id,
                        ),
                      );
                    },
                  ),
                  _userCount(
                    title: '粉丝',
                    count: user.followerCount,
                    onTap: () {
                      showBasicModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) => FollowModal(
                          key: ValueKey('followerModal'),
                          scrollController: ModalScrollController.of(context),
                          id: user.id,
                          type: FollowModalType.follower,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            )
          ],
        ),
        tabBar: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: theme.textTheme.overline!.color!.withOpacity(.1),
                width: .3,
              ),
            ),
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
              setState(() {
                _tabIndex = index;
              });
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
                            PictureList(
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
                          extended.NestedScrollViewInnerScrollPositionKeyWidget(
                            const Key('Tab1'),
                            UserCollectionList(username: user.username),
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
