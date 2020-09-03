import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:image_fade/image_fade.dart';
import 'package:soap_app/config/const.dart';
import 'package:soap_app/model/user.dart';
import 'package:soap_app/ui/widget/avatar.dart';
import 'package:soap_app/ui/widget/large_custom_header.dart';
import 'package:soap_app/ui/widget/touchable_opacity.dart';
import 'package:soap_app/ui/widget/transparent_image.dart';
import 'package:soap_app/utils/picture.dart';

class UserView extends StatefulWidget {
  const UserView({
    Key key,
    @required this.user,
  }) : super(key: key);

  final User user;

  @override
  _UserViewState createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  User user;

  @override
  void initState() {
    user = widget.user;
    super.initState();
  }

  Widget _userCount({
    @required int count,
    @required String title,
  }) {
    final ThemeData theme = Theme.of(context);
    return Expanded(
      flex: 1,
      child: TouchableOpacity(
        onPressed: () {},
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
          child: Column(
            children: <Widget>[
              Text(
                count != null ? count.toString() : '--',
                style: theme.textTheme.bodyText2.copyWith(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                title,
                style: theme.textTheme.bodyText2.copyWith(
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
        barCenterTitle: false,
        backgroundImage: getPictureUrl(
          key: user.cover ?? user.avatar,
          style: user.cover != null ? PictureStyle.small : PictureStyle.blur,
        ),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 36,
        ),
        children: <Widget>[
          Container(
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
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              user.fullName,
              style: theme.textTheme.headline4.copyWith(
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
                  style: theme.textTheme.bodyText2.copyWith(
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
    return Material(
      child: Container(
          color: Colors.white,
          child: EasyRefresh.custom(
            // physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            slivers: <Widget>[
              _buildSliverHead(),
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 1000,
                ),
              )
            ],
            // onRefresh: () async{
            // },
            onLoad: () async {},
          )
          // Container(
          //   width: double.infinity,
          //   height: 260,
          //   child: Stack(
          //     children: <Widget>[
          //       ImageFade(
          //         width: double.infinity,
          //         fadeDuration: const Duration(milliseconds: 100),
          //         placeholder: Image.memory(
          //           transparentImage,
          //           fit: BoxFit.cover,
          //           gaplessPlayback: true,
          //         ),
          //         image: CachedNetworkImageProvider(
          //           getPictureUrl(key: user.cover ?? user.avatar),
          //         ),
          //         fit: BoxFit.cover,
          //       ),
          //     ],
          //   ),
          // ),
          ),
    );
  }
}
