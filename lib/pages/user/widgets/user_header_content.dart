import 'dart:async';
import 'dart:ffi';

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

class UserHeaderContent extends StatefulWidget {
  UserHeaderContent({
    Key? key,
    required this.user,
    required this.onHeightChanged,
    this.heroId,
  }) : super(key: key);

  final User user;
  final String? heroId;
  final void Function(double) onHeightChanged;

  @override
  _UserHeaderContentState createState() => _UserHeaderContentState();
}

class _UserHeaderContentState extends State<UserHeaderContent> {
  final GlobalKey _bioKey = GlobalKey();
  late final Timer _timer;

  double? _height;

  final Throttling _followThr =
      Throttling(duration: const Duration(seconds: 2));

  final Throttling _unfollowThr =
      Throttling(duration: const Duration(seconds: 2));

  final UserRepository _userRepository = UserRepository();

  bool get isOwner {
    if (accountStore.isLogin &&
        accountStore.userInfo!.username == widget.user.username) {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(milliseconds: 0), () {
      setHeight();
    });
    _timer = Timer.periodic(const Duration(milliseconds: 2000), (Timer timer) {
      setHeight();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
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
      if (widget.user.isFollowing != null && widget.user.isFollowing! > 0) {
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
                _userRepository.unFollowUser(
                    widget.user.id, widget.user.username);
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
              _userRepository.followUser(widget.user.id, widget.user.username);
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

  void setHeight() {
    if (_bioKey.currentContext != null) {
      final RenderBox getBox =
          _bioKey.currentContext!.findRenderObject() as RenderBox;
      if (getBox.hasSize) {
        if (_height != getBox.size.height) {
          _height = getBox.size.height;
          widget.onHeightChanged(_height!);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TouchableOpacity(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: <Widget>[
                if (widget.heroId == null)
                  Avatar(
                    size: 56,
                    image: getPictureUrl(key: widget.user.avatar),
                  )
                else
                  Hero(
                    tag: 'user-${widget.user.username}-${widget.heroId}',
                    child: Avatar(
                      size: 56,
                      image: getPictureUrl(key: widget.user.avatar),
                    ),
                  ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: [
                            if (widget.user.isVip)
                              SizedBox(
                                width: 22,
                                height: 22,
                                child: Image.asset('assets/images/vip.png'),
                              ),
                            const SizedBox(width: 6),
                            Text(
                              widget.user.fullName,
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
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
          padding: const EdgeInsets.only(left: 16, top: 2, right: 16),
          key: _bioKey,
          child: Text(
            widget.user.bio != null && widget.user.bio!.isNotEmpty
                ? widget.user.bio!
                : '这个人很懒，什么都没留下。',
            maxLines: 4,
            overflow: TextOverflow.fade,
            style: TextStyle(
              color: Colors.white.withOpacity(.6),
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
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
                      count: widget.user.followedCount,
                      context: context,
                      onTap: () {
                        showBasicModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) => FollowModal(
                            key: ValueKey('followedModal'),
                            type: FollowModalType.followed,
                            scrollController: ModalScrollController.of(context),
                            id: widget.user.id,
                          ),
                        );
                      },
                    ),
                    _userCount(
                      title: '粉丝',
                      count: widget.user.followerCount,
                      context: context,
                      onTap: () {
                        showBasicModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) => FollowModal(
                            key: ValueKey('followerModal'),
                            scrollController: ModalScrollController.of(context),
                            id: widget.user.id,
                            type: FollowModalType.follower,
                          ),
                        );
                      },
                    ),
                    _userCount(
                      title: '人气',
                      count: widget.user.likesCount,
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
