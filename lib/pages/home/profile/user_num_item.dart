import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:soap_app/config/const.dart';
import 'package:soap_app/store/index.dart';
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
  }) {
    final ThemeData theme = Theme.of(context);
    return Expanded(
      flex: 1,
      child: TouchableOpacity(
        activeOpacity: activeOpacity,
        behavior: HitTestBehavior.opaque,
        onTap: () async {
          return showCustomModalBottomSheet<dynamic>(
            containerWidget: (
              BuildContext _,
              Animation<double> animation,
              Widget child,
            ) =>
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
                  color: theme.textTheme.bodyText2!.color,
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
    return Container(
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
    );
  }
}
