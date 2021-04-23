import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:soap_app/config/router.dart';
import 'package:soap_app/store/index.dart';
import 'package:soap_app/utils/picture.dart';
import 'package:soap_app/widget/app_bar.dart';
import 'package:soap_app/widget/avatar.dart';
import 'package:touchable_opacity/touchable_opacity.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({
    Key? key,
    required this.controller,
    required this.signupCb,
  }) : super(key: key);

  final TabController controller;
  final Function signupCb;

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late TabController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<void> signup() async {
    await accountStore.signup();
    widget.signupCb();
    // controller.animateTo(0);
  }

  Widget _userCount({
    int? count,
    required String title,
  }) {
    final ThemeData theme = Theme.of(context);
    return Expanded(
      flex: 1,
      child: TouchableOpacity(
        onTap: () async {
          return showCustomModalBottomSheet<dynamic>(
            containerWidget:
                (BuildContext _, Animation<double> animation, Widget child) =>
                    Container(
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: child,
            ),
            duration: const Duration(milliseconds: 200),
            context: context,
            builder: (BuildContext context) => Container(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * .8,
                child: Text('Follow'),
              ),
            ),
          );
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
          child: Column(
            children: <Widget>[
              Text(
                count != null ? count.toString() : '--',
                style: theme.textTheme.bodyText2!.copyWith(
                  color: theme.textTheme.bodyText1!.color,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                title,
                style: theme.textTheme.bodyText2!.copyWith(
                  color: theme.textTheme.bodyText2!.color!.withOpacity(.6),
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
      appBar: SoapAppBar(
        centerTitle: false,
        elevation: 0.2,
        actionsPadding: const EdgeInsets.only(
          right: 16,
        ),
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            '个人中心',
          ),
        ),
        actions: <Widget>[
          TouchableOpacity(
            onTap: () {
              Navigator.pushNamed(context, RouteName.setting);
            },
            child: Icon(
              FeatherIcons.settings,
            ),
          ),
        ],
      ),
      body: Container(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(0),
          children: <Widget>[
            Container(
              color: theme.cardColor,
              child: TouchableOpacity(
                onTap: () {
                  if (accountStore.isLogin) {
                    Navigator.pushNamed(
                      context,
                      RouteName.user,
                      arguments: accountStore.userInfo,
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
                          child: Observer(
                            builder: (_) {
                              if (accountStore.isLogin) {
                                return Avatar(
                                  size: 64,
                                  image: getPictureUrl(
                                      key: accountStore.userInfo!.avatar),
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
                              child: Observer(
                                builder: (_) => Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      accountStore.userInfo?.fullName ?? '',
                                      style: theme.textTheme.headline5,
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      accountStore.userInfo?.bio ?? '未填写简介',
                                      style: theme.textTheme.bodyText2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          child: Icon(
                            FeatherIcons.chevronRight,
                            color: theme.textTheme.bodyText1!.color!
                                .withOpacity(.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: theme.cardColor,
              ),
              child: Observer(
                builder: (_) => Flex(
                  direction: Axis.horizontal,
                  children: <Widget>[
                    _userCount(
                      title: '关注',
                      count: accountStore.userInfo?.followedCount,
                    ),
                    _userCount(
                      title: '粉丝',
                      count: accountStore.userInfo?.followerCount,
                    ),
                    _userCount(
                      title: '喜欢',
                      count: accountStore.userInfo?.likedCount,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Container(
              color: theme.cardColor,
              child: TouchableOpacity(
                onTap: signup,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 12,
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
