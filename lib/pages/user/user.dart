import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:graphql/src/core/query_result.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:soap_app/config/const.dart';
import 'package:soap_app/model/user.dart';
import 'package:soap_app/store/index.dart';
import 'package:soap_app/utils/picture.dart';
import 'package:soap_app/utils/storage.dart';
import 'package:soap_app/widget/app_bar.dart';
import 'package:soap_app/widget/avatar.dart';
import 'package:soap_app/widget/large_custom_header.dart';
import 'package:touchable_opacity/touchable_opacity.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as extended;

class UserPage extends StatefulWidget {
  const UserPage({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage>
    with SingleTickerProviderStateMixin {
  late User user;
  late TabController tabController;
  final int _selectedIndex = 0;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  int _tabIndex = 0;

  final double _tabBarHeight = 55;

  @override
  void initState() {
    user = widget.user;
    tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: _selectedIndex,
    );
    super.initState();
    getDetail();
  }

  bool get isMe {
    if (accountStore.userInfo?.username == user.username) {
      return true;
    }
    return false;
  }

  Future<void> getDetail() async {
    // final String _cacheUser =
    //     StorageUtil.getString('user.${widget.user.username}');
    // if (_cacheUser != null) {
    //   user = User.fromJson(json.decode(_cacheUser) as Map<String, dynamic>);
    // }
    // final QueryResult data = await UserRepository.user(widget.user.username);
    // final Map<String, dynamic> userMap =
    //     data.data['user'] as Map<String, dynamic>;
    // setState(() {});
    // if (userMap != null) {
    //   user = User.fromJson(userMap);
    //   StorageUtil.setString(
    //       'user.${widget.user.username}', json.encode(userMap));
    // }
    setState(() {});
  }

  Widget _userCount({
    int? count,
    required String title,
  }) {
    final ThemeData theme = Theme.of(context);
    return Expanded(
      flex: 1,
      child: TouchableOpacity(
        activeOpacity: activeOpacity,
        onTap: () {
          print('test');
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
          child: Column(
            children: <Widget>[
              Text(
                count != null ? count.toString() : '--',
                style: theme.textTheme.bodyText2!.copyWith(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                title,
                style: theme.textTheme.bodyText2!.copyWith(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSliverHead() {
    final ThemeData theme = Theme.of(context);
    return SliverPersistentHeader(
      // floating: true,
      pinned: true,
      delegate: LargeCustomHeader(
        navBarHeight: appBarHeight + MediaQuery.of(context).padding.top,
        titleHeight: 220,
        tabBarHeight: _tabBarHeight,
        barCenterTitle: false,
        backgroundImage: getPictureUrl(
          key: user.cover ?? user.avatar,
          style: user.cover != null ? PictureStyle.small : PictureStyle.blur,
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
                    Avatar(
                      size: 68,
                      image: getPictureUrl(key: user.avatar),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                user.fullName,
                style: theme.textTheme.headline4!.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              child: Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  _userCount(
                    title: '照片',
                    count: user.pictureCount,
                  ),
                  _userCount(
                    title: '关注',
                    count: user.followedCount,
                  ),
                  _userCount(
                    title: '粉丝',
                    count: user.followerCount,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            )
          ],
        ),
        tabBar: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: theme.textTheme.bodyText2!.color!.withOpacity(.4),
                      width: .2,
                    ),
                    bottom: BorderSide(
                      color: theme.textTheme.bodyText2!.color!.withOpacity(.4),
                      width: .2,
                    ),
                  ),
                ),
                child: TabBar(
                  controller: tabController,
                  tabs: [
                    Tab(
                      text: '照片',
                    ),
                    Tab(
                      text: '喜欢',
                    ),
                    Tab(
                      text: '收藏夹',
                    ),
                  ],
                  onTap: (index) {
                    setState(() {
                      _tabIndex = index;
                    });
                  },
                  labelColor: theme.textTheme.bodyText2!.color,
                  indicator: MaterialIndicator(
                    height: 2,
                    topLeftRadius: 4,
                    topRightRadius: 4,
                    horizontalPadding: 50,
                    tabPosition: TabPosition.bottom,
                  ),
                ),
              ),
            ),
          ],
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
                  style: theme.textTheme.bodyText2!.copyWith(
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
    return Material(
      child: Container(
        color: theme.cardColor,
        child: extended.NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return <Widget>[
              _buildSliverHead(),
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
          body: Column(
            children: <Widget>[
              Expanded(
                child: TabBarView(
                  physics: const BouncingScrollPhysics(),
                  controller: tabController,
                  children: <Widget>[
                    extended.NestedScrollViewInnerScrollPositionKeyWidget(
                      Key('Tab0'),
                      SmartRefresher(
                        controller: _refreshController,
                        physics: const BouncingScrollPhysics(),
                        header: const ClassicHeader(
                          releaseText: '松开刷新',
                          idleText: '下拉刷新',
                          refreshingText: '刷新中',
                          completeText: '刷新成功',
                          failedText: '刷新失败',
                          refreshingIcon: CupertinoActivityIndicator(),
                          idleIcon: Icon(FeatherIcons.arrowDown),
                          releaseIcon: Icon(FeatherIcons.arrowDown),
                          refreshStyle: RefreshStyle.UnFollow,
                        ),
                        child: ListView.builder(
                          padding: EdgeInsets.all(0.0),
                          itemBuilder: (context, index) {
                            return Text('123123');
                          },
                          itemCount: 10,
                        ),
                      ),
                    ),
                    extended.NestedScrollViewInnerScrollPositionKeyWidget(
                      Key('Tab1'),
                      EasyRefresh(
                        topBouncing: false,
                        child: ListView.builder(
                          padding: EdgeInsets.all(0.0),
                          itemBuilder: (context, index) {
                            return Text('111');
                          },
                          itemCount: 20,
                        ),
                      ),
                    ),
                    extended.NestedScrollViewInnerScrollPositionKeyWidget(
                      Key('Tab2'),
                      ListView.builder(
                        padding: EdgeInsets.all(0.0),
                        itemBuilder: (context, index) {
                          return Text('3333');
                        },
                        itemCount: 30,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
