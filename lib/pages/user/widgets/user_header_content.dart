import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:soap_app/config/const.dart';
import 'package:soap_app/config/router.dart';
import 'package:soap_app/model/user.dart';
import 'package:soap_app/repository/user_repository.dart';
import 'package:soap_app/store/index.dart';
import 'package:soap_app/utils/picture.dart';
import 'package:soap_app/widget/avatar.dart';
import 'package:soap_app/widget/follow_modal.dart';
import 'package:soap_app/widget/modal_bottom_sheet.dart';
import 'package:throttling/throttling.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

class UserHeaderContent extends StatelessWidget {
  UserHeaderContent({
    Key? key,
    required this.user,
    this.heroId,
  }) : super(key: key);

  final User user;
  final String? heroId;

  final Throttling _followThr =
      Throttling(duration: const Duration(seconds: 2));
  final Throttling _unfollowThr =
      Throttling(duration: const Duration(seconds: 2));

  final UserRepository _userRepository = UserRepository();

  bool get isOwner {
    if (accountStore.isLogin &&
        accountStore.userInfo!.username == user.username) {
      return true;
    }
    return false;
  }

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
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(.8),
              fontSize: 12,
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

  Widget _btn(BuildContext context) {
    if (isOwner) {
      return OutlinedButton(
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(
            0,
          ),
          padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 0,
            ),
          ),
          backgroundColor: MaterialStateProperty.all(
            Colors.white.withOpacity(.1),
          ),
          overlayColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.focused) ||
                  states.contains(MaterialState.pressed))
                return Colors.black.withOpacity(.1);
              return Colors.transparent; // Defer to the widget's default.
            },
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              side: const BorderSide(color: Colors.red, width: 10),
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          side: MaterialStateProperty.all(
            const BorderSide(
              color: Colors.white,
              width: 1,
            ),
          ),
        ),
        onPressed: () {
          Navigator.of(context).pushNamed(RouteName.edit_profile);
        },
        child: const Text(
          '编辑资料',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      );
    } else {
      if (user.isFollowing != null && user.isFollowing! > 0) {
        return SizedBox(
          width: 46,
          child: OutlinedButton(
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(
                0,
              ),
              padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(
                  // horizontal: 6,
                  vertical: 0,
                ),
              ),
              backgroundColor: MaterialStateProperty.all(
                Colors.white.withOpacity(.1),
              ),
              overlayColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.focused) ||
                      states.contains(MaterialState.pressed))
                    return Colors.black.withOpacity(.1);
                  return Colors.transparent; // Defer to the widget's default.
                },
              ),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.red, width: 10),
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              side: MaterialStateProperty.all(
                const BorderSide(
                  color: Colors.white,
                  width: 1,
                ),
              ),
            ),
            onPressed: () {
              _unfollowThr.throttle(() {
                _userRepository.unFollowUser(user.id, user.username);
              });
            },
            child: const Icon(
              FeatherIcons.userCheck,
              color: Colors.white,
              size: 18,
            ),
          ),
        );
      } else {
        return OutlinedButton(
          style: ButtonStyle(
            elevation: MaterialStateProperty.all(
              0,
            ),
            padding: MaterialStateProperty.all(
              const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 0,
              ),
            ),
            backgroundColor: MaterialStateProperty.all(
              Theme.of(context).primaryColor,
            ),
            overlayColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.focused) ||
                    states.contains(MaterialState.pressed))
                  return Colors.black.withOpacity(.1);
                return Colors.transparent; // Defer to the widget's default.
              },
            ),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                side: const BorderSide(color: Colors.red, width: 10),
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            side: MaterialStateProperty.all(
              BorderSide(
                color: Theme.of(context).primaryColor,
                width: 0,
              ),
            ),
          ),
          onPressed: () {
            _followThr.throttle(() {
              _userRepository.followUser(user.id, user.username);
            });
          },
          child: const Text(
            '关 注',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        );
      }
    }
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
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.fullName,
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (user.bio != null && user.bio!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              user.bio!,
                              maxLines: 2,
                              overflow: TextOverflow.fade,
                              style: TextStyle(
                                color: Colors.white.withOpacity(.6),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 0,
          ),
          child: Flex(
            direction: Axis.horizontal,
            children: [
              Expanded(
                child: Row(
                  children: <Widget>[
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
                    _userCount(
                      title: '人气',
                      count: user.likesCount,
                      context: context,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: SizedBox(
                  height: 32,
                  child: _btn(context),
                ),
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
