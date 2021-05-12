import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:soap_app/config/const.dart';
import 'package:soap_app/model/user.dart';
import 'package:soap_app/utils/picture.dart';
import 'package:soap_app/widget/avatar.dart';
import 'package:soap_app/widget/follow_modal.dart';
import 'package:soap_app/widget/modal_bottom_sheet.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

class UserHeaderContent extends StatelessWidget {
  const UserHeaderContent({
    Key? key,
    required this.user,
    this.heroId,
  }) : super(key: key);

  final User user;
  final String? heroId;

  Widget _userCount({
    required String title,
    required BuildContext context,
    int? count,
    Function? onTap,
  }) {
    final ThemeData theme = Theme.of(context);
    final Widget content = Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
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
      return content;
    }
    return TouchableOpacity(
      activeOpacity: activeOpacity,
      behavior: HitTestBehavior.translucent,
      onTap: () {
        onTap();
      },
      child: content,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TouchableOpacity(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: <Widget>[
                if (heroId == null)
                  Avatar(
                    size: 56,
                    image: getPictureUrl(key: user.avatar),
                  )
                else
                  Hero(
                    tag: 'user-${user.username}-$heroId',
                    child: Avatar(
                      size: 56,
                      image: getPictureUrl(key: user.avatar),
                    ),
                  ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      Text(
                        user.fullName,
                        style: GoogleFonts.rubik(
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (user.bio != null && user.bio!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            user.bio!,
                            style: GoogleFonts.rubik(
                              textStyle: TextStyle(
                                color: Colors.white.withOpacity(.6),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 0,
          ),
          child: Row(
            children: <Widget>[
              _userCount(
                title: '赞',
                count: user.likesCount,
                context: context,
              ),
              _userCount(
                title: '关注',
                count: user.followedCount,
                context: context,
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
                context: context,
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
    );
  }
}
