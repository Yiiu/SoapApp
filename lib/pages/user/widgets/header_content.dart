import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:soap_app/config/config.dart';
import 'package:soap_app/utils/utils.dart';
import 'package:soap_app/widget/widgets.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

import '../stores/user_store.dart';
import 'header_follow_btn.dart';

class UserHeaderContent extends StatefulWidget {
  const UserHeaderContent({
    Key? key,
    required this.store,
    required this.onHeightChanged,
    this.heroId,
  }) : super(key: key);

  final UserPageStore store;
  final String? heroId;
  final void Function(double) onHeightChanged;

  @override
  _UserHeaderContentState createState() => _UserHeaderContentState();
}

class _UserHeaderContentState extends State<UserHeaderContent> {
  final GlobalKey _bioKey = GlobalKey();
  late final Timer _timer;

  double? _height;

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
    int? count,
    Function? onTap,
  }) {
    final Widget content = Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
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
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: <Widget>[
              TouchableOpacity(
                onTap: () {
                  Navigator.of(context).push<dynamic>(
                    HeroDialogRoute<void>(
                      builder: (_) => HeroPhotoGallery(
                        radius: const Radius.circular(64),
                        heroLabel: 'user_detail-${widget.store.user!.username}',
                        url: getPictureUrl(
                          key: widget.store.user!.avatar,
                          style: PictureStyle.avatarRegular,
                        ),
                      ),
                    ),
                  );
                },
                child: Observer(builder: (_) {
                  return Avatar(
                    heroTag: 'user_detail-${widget.store.user!.username}',
                    size: 64,
                    radius: 64,
                    image: widget.store.user!.avatarUrl,
                  );
                }),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: [
                          Observer(builder: (_) {
                            return Text(
                              widget.store.user!.fullName,
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                            );
                          }),
                          if (widget.store.user!.isVip) ...[
                            const SizedBox(width: 6),
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: Image.asset('assets/images/vip.png'),
                            ),
                          ]
                        ],
                      ),
                      const SizedBox(height: 4),
                      Observer(builder: (_) {
                        return Row(
                          children: [
                            if (widget.store.user!.gender >= 0)
                              Container(
                                height: 22,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(.1),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                child: SizedBox(
                                  width: 12,
                                  height: 12,
                                  child: SvgPicture.asset(
                                    widget.store.user!.gender == 0
                                        ? 'assets/svg/male.svg'
                                        : 'assets/svg/female.svg',
                                    // color: Color(0xffdd8d99),
                                    color: widget.store.user!.gender == 0
                                        ? const Color(0xff84c0f6)
                                        : const Color(0xffdd8d99),
                                  ),
                                ),
                              ),
                            const SizedBox(width: 8),
                            if (widget.store.user!.birthday != null)
                              Container(
                                height: 22,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(.1),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 2),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: 12,
                                        height: 12,
                                        child: SvgPicture.asset(
                                          'assets/svg/constellation/${constellationEng[widget.store.user!.constellation!]}.svg',
                                          color: const Color(0xffff85c0),
                                        ),
                                      ),
                                      const SizedBox(width: 2),
                                      Text(
                                        widget.store.user!.constellation!,
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(.8),
                                          fontSize: 10,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.only(left: 16, top: 2, right: 16),
          key: _bioKey,
          child: Observer(builder: (_) {
            return Text(
              widget.store.user!.bio != null &&
                      widget.store.user!.bio!.isNotEmpty
                  ? widget.store.user!.bio!
                  : '这个人很懒，什么都没留下。',
              maxLines: 4,
              overflow: TextOverflow.fade,
              style: TextStyle(
                color: Colors.white.withOpacity(.6),
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            );
          }),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 0,
          ),
          child: Flex(
            direction: Axis.horizontal,
            children: [
              Expanded(
                flex: 1,
                child: Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Observer(builder: (_) {
                      return _userCount(
                        title: FlutterI18n.translate(
                            context, 'common.label.following'),
                        count: widget.store.user!.followedCount,
                        onTap: () {
                          showSoapBottomSheet<void>(
                            context,
                            isScrollControlled: true,
                            child: FollowModal(
                              key: const ValueKey('followedModal'),
                              type: FollowModalType.followed,
                              scrollController:
                                  ModalScrollController.of(context),
                              id: widget.store.user!.id,
                            ),
                          );
                        },
                      );
                    }),
                    Observer(builder: (_) {
                      return _userCount(
                        title: FlutterI18n.translate(
                            context, 'common.label.followers'),
                        count: widget.store.user!.followerCount,
                        onTap: () {
                          showSoapBottomSheet<void>(
                            context,
                            isScrollControlled: true,
                            child: FollowModal(
                              key: const ValueKey('followerModal'),
                              scrollController:
                                  ModalScrollController.of(context),
                              id: widget.store.user!.id,
                              type: FollowModalType.follower,
                            ),
                          );
                        },
                      );
                    }),
                    Observer(builder: (_) {
                      return _userCount(
                        title: FlutterI18n.translate(
                            context, 'common.label.popularity'),
                        count: widget.store.user!.likesCount,
                      );
                    }),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: SizedBox(
                  height: 32,
                  child: UserHeaderFollowBtn(store: widget.store),
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
