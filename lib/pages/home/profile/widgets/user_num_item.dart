import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:soap_app/config/const.dart';
import 'package:soap_app/store/index.dart';
import 'package:soap_app/widget/follow_modal.dart';
import 'package:soap_app/widget/modal_bottom_sheet.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

class ProfileUserNumItem extends StatefulWidget {
  const ProfileUserNumItem({Key? key}) : super(key: key);

  @override
  _ProfileUserNumItemState createState() => _ProfileUserNumItemState();
}

class _ProfileUserNumItemState extends State<ProfileUserNumItem> {
  Widget _userCount({
    int? count,
    required String title,
    void Function()? onTap,
  }) {
    final ThemeData theme = Theme.of(context);
    return Expanded(
      flex: 1,
      child: TouchableOpacity(
        activeOpacity: activeOpacity,
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
          child: Column(
            children: <Widget>[
              Text(
                count != null ? count.toString() : '--',
                style: theme.textTheme.bodyText2!.copyWith(
                  color: theme.textTheme.bodyText2!.color,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                title,
                style: TextStyle(
                  color: theme.textTheme.bodyText2!.color!.withOpacity(.6),
                  fontSize: 12,
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
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
      ),
      child: Observer(
        builder: (_) => Flex(
          direction: Axis.horizontal,
          children: <Widget>[
            _userCount(
              title: FlutterI18n.translate(context, 'common.label.following'),
              count: accountStore.userInfo?.followedCount,
              onTap: accountStore.isLogin
                  ? () {
                      showBasicModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) => FollowModal(
                          type: FollowModalType.followed,
                          scrollController: ModalScrollController.of(context),
                          id: accountStore.userInfo!.id,
                        ),
                      );
                    }
                  : null,
            ),
            _userCount(
              title: FlutterI18n.translate(context, 'common.label.followers'),
              count: accountStore.userInfo?.followerCount,
              onTap: accountStore.isLogin
                  ? () {
                      showBasicModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) => FollowModal(
                          type: FollowModalType.follower,
                          scrollController: ModalScrollController.of(context),
                          id: accountStore.userInfo!.id,
                        ),
                      );
                    }
                  : null,
            ),
            _userCount(
              title: FlutterI18n.translate(context, 'common.label.likes'),
              count: accountStore.userInfo?.likedCount,
            ),
          ],
        ),
      ),
    );
  }
}
