import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soap_app/config/router.dart';
import 'package:soap_app/provider/account.dart';
import 'package:soap_app/provider/home.dart';
import 'package:soap_app/ui/toast.dart';
import 'package:soap_app/ui/widget/app_bar.dart';
import 'package:soap_app/ui/widget/avatar.dart';
import 'package:soap_app/ui/widget/touchable_opacity.dart';
import 'package:soap_app/utils/picture.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key key, this.controller, this.logout}) : super(key: key);

  final TabController controller;

  final Function logout;

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  TabController controller;
  Function logoutCb;

  @override
  void initState() {
    super.initState();
    controller = widget.controller;
    logoutCb = widget.logout;
    if (Provider.of<AccountProvider>(context, listen: false).isAccount) {
      Provider.of<AccountProvider>(context, listen: false).getUserInfo();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void logout() {
    logoutCb();
    Provider.of<AccountProvider>(context, listen: false).logout();
    Provider.of<HomeProvider>(context, listen: false).reset();
    Toast.showText('退出成功');
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
                count.toString() ?? '--',
                style: theme.textTheme.bodyText2.copyWith(
                  color: theme.textTheme.bodyText1.color,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                title,
                style: theme.textTheme.bodyText2.copyWith(
                  color: theme.textTheme.bodyText2.color.withOpacity(.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return FixedAppBarWrapper(
      appBar: const SoapAppBar(
        centerTitle: false,
        elevation: 0.2,
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Profile',
          ),
        ),
      ),
      body: Container(
        color: theme.backgroundColor,
        child: ListView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          padding: const EdgeInsets.all(0),
          children: <Widget>[
            Container(
              color: Colors.white,
              child: TouchableOpacity(
                onPressed: () {
                  if (Provider.of<AccountProvider>(context, listen: false)
                      .isAccount) {
                    Navigator.pushNamed(
                      context,
                      RouteName.user,
                      arguments:
                          Provider.of<AccountProvider>(context, listen: false)
                              .user,
                    );
                  }
                },
                child: Container(
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: <Widget>[
                        Container(
                          child: Consumer<AccountProvider>(
                            builder: (
                              BuildContext context,
                              AccountProvider account,
                              Widget child,
                            ) {
                              if (account.user != null) {
                                return Avatar(
                                  size: 64,
                                  image:
                                      getPictureUrl(key: account.user.avatar),
                                );
                              }
                              return const SizedBox(
                                height: 64,
                                width: 64,
                              );
                            },
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: Consumer<AccountProvider>(
                                builder: (
                                  BuildContext context,
                                  AccountProvider account,
                                  Widget child,
                                ) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        account.user?.fullName ?? '',
                                        style: theme.textTheme.headline5,
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        account.user?.bio ?? '未填写简介',
                                        style: theme.textTheme.bodyText2,
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        Container(
                          child: Icon(
                            FeatherIcons.chevronRight,
                            color:
                                theme.textTheme.bodyText1.color.withOpacity(.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Consumer<AccountProvider>(
                builder: (
                  BuildContext context,
                  AccountProvider account,
                  Widget child,
                ) {
                  return Flex(
                    direction: Axis.horizontal,
                    children: <Widget>[
                      _userCount(
                        title: '关注',
                        count: account.user?.followedCount,
                      ),
                      _userCount(
                        title: '粉丝',
                        count: account.user?.followerCount,
                      ),
                      _userCount(
                        title: '喜欢',
                        count: account.user?.likedCount,
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Container(
              color: Colors.white,
              child: TouchableOpacity(
                onPressed: logout,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                  ),
                  child: Text(
                    '退出登录',
                    style: TextStyle(
                      color: theme.errorColor,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
