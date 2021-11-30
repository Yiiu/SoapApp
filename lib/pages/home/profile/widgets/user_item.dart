import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:soap_app/config/config.dart';
import 'package:soap_app/store/index.dart';
import 'package:soap_app/utils/picture.dart';
import 'package:soap_app/widget/widgets.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

class ProfileUserItem extends StatelessWidget {
  const ProfileUserItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      color: theme.cardColor,
      child: TouchableOpacity(
        activeOpacity: activeOpacity,
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (accountStore.isLogin) {
            Navigator.of(context).pushNamed(
              RouteName.user,
              arguments: {
                'user': accountStore.userInfo,
                'heroId': 'profile',
              },
            );
          } else {
            Navigator.of(context).pushNamed(RouteName.login);
          }
        },
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: <Widget>[
                SizedBox(
                  child: Observer(
                    builder: (_) {
                      if (accountStore.isLogin) {
                        return Hero(
                          tag:
                              'user-${accountStore.userInfo!.username}-profile',
                          child: Avatar(
                            size: 64,
                            image: accountStore.userInfo!.avatarUrl,
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Observer(
                      builder: (_) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            accountStore.userInfo?.fullName ?? '登录',
                            style: theme.textTheme.headline5,
                          ),
                          if (accountStore.isLogin) ...<Widget>[
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              accountStore.userInfo?.bio ?? '未填写简介',
                              style: theme.textTheme.bodyText2,
                            ),
                          ]
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  child: Icon(
                    FeatherIcons.chevronRight,
                    color: theme.textTheme.bodyText2!.color!.withOpacity(.6),
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
