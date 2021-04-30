import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:soap_app/config/const.dart';
import 'package:soap_app/config/router.dart';
import 'package:soap_app/store/index.dart';
import 'package:soap_app/utils/picture.dart';
import 'package:soap_app/widget/avatar.dart';
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
            Navigator.pushNamed(
              context,
              RouteName.user,
              arguments: {
                'user': accountStore.userInfo,
                'heroId': 'profile',
              },
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
                        return Hero(
                          tag:
                              'user-${accountStore.userInfo!.username}-profile',
                          child: Avatar(
                            size: 64,
                            image: getPictureUrl(
                                key: accountStore.userInfo!.avatar),
                          ),
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
