import 'package:decorated_icon/decorated_icon.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:like_button/like_button.dart';
import 'package:soap_app/config/config.dart';
import 'package:soap_app/model/picture.dart';
import 'package:soap_app/pages/picture_detail/widgets/widgets.dart';
import 'package:soap_app/repository/repository.dart';
import 'package:soap_app/store/index.dart';
import 'package:soap_app/widget/comment_bottom/comment_bottom.dart';
import 'package:soap_app/widget/widgets.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

import '../constants.dart';
import 'picture_info.dart';

class NewPictureDetailHandle extends StatefulWidget {
  const NewPictureDetailHandle({
    Key? key,
    this.onInfo,
    required this.controller,
    required this.picture,
  }) : super(key: key);

  final AnimationController controller;
  final Picture picture;
  final void Function()? onInfo;

  @override
  _NewPictureDetailHandleState createState() => _NewPictureDetailHandleState();
}

class _NewPictureDetailHandleState extends State<NewPictureDetailHandle> {
  final PictureRepository _pictureRepository = PictureRepository();

  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _opacityAnimation = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(
      CurvedAnimation(parent: widget.controller, curve: Curves.easeInOut),
    );
  }

  Widget _handleItem(
      {required IconData icon, String? text, void Function()? onTap}) {
    return TouchableOpacity(
      activeOpacity: activeOpacity,
      onTap: onTap,
      child: Column(
        children: <Widget>[
          Column(
            children: <Widget>[
              DecoratedIcon(
                icon,
                size: 26,
                color: Colors.white,
                shadows: const <Shadow>[
                  Shadow(
                    offset: Offset(0.0, 0.5),
                    blurRadius: 5,
                    color: Colors.black38,
                  ),
                ],
              ),
            ],
          ),
          if (text != null)
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                shadows: shadow,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
    );
  }

  Widget _likeItem(BuildContext context) {
    return Column(
      children: <Widget>[
        LikeButton(
          isLiked: widget.picture.isLike,
          size: 26,
          onTap: (bool like) async {
            if (!accountStore.isLogin) {
              SoapToast.error('请登录后再操作！');
              return like;
            }
            if (!like) {
              await _pictureRepository.liked(widget.picture.id);
            } else {
              await _pictureRepository.unLike(widget.picture.id);
            }
            return !like;
          },
          animationDuration: const Duration(milliseconds: 600),
          circleColor: const CircleColor(
              start: Color(0xff00ddff), end: Color(0xff0099cc)),
          bubblesColor: const BubblesColor(
            dotPrimaryColor: Color(0xff33b5e5),
            dotSecondaryColor: Color(0xff0099cc),
          ),
          likeBuilder: (bool isLiked) {
            if (isLiked) {
              return const DecoratedIcon(
                Ionicons.heart,
                size: 26,
                color: Colors.red,
                shadows: <Shadow>[
                  Shadow(
                    offset: Offset(0.0, 1.0),
                    blurRadius: 10,
                    color: Colors.red,
                  ),
                ],
              );
            }
            return const DecoratedIcon(
              Ionicons.heart,
              size: 26,
              color: Colors.white,
              shadows: <Shadow>[
                Shadow(
                  offset: Offset(0.0, 1.0),
                  blurRadius: 10,
                  color: Colors.black12,
                ),
              ],
            );
          },
          likeCount: widget.picture.likedCount,
          countBuilder: (int? count, bool isLiked, String text) =>
              const SizedBox(),
        ),
        IntrinsicWidth(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                child: AnimatedNumber(
                  number: widget.picture.likedCount,
                  textStyle: const TextStyle(
                    color: Colors.white,
                    shadows: shadow,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0,
      bottom: 0,
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: Padding(
          padding: EdgeInsets.only(
            right: 18,
            bottom: MediaQuery.of(context).padding.bottom + 20,
          ),
          child: Column(
            children: <Widget>[
              _likeItem(context),
              const SizedBox(height: 24),
              _handleItem(
                icon: Ionicons.chatbubble,
                text: (widget.picture.commentCount ?? 0).toString(),
                onTap: () {
                  showSoapBottomSheet<dynamic>(
                    context,
                    // backgroundColor:
                    isScrollControlled: true,
                    height: MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.top -
                        24,
                    child: CommentBottomModal(
                      id: widget.picture.id,
                      picture: widget.picture,
                      handle: false,
                      commentCount: widget.picture.commentCount,
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              _handleItem(
                icon: Ionicons.bookmark,
                onTap: () {
                  showSoapBottomSheet<dynamic>(
                    context,
                    child: AddToCollection(
                      current: widget.picture.currentCollections,
                      pictureId: widget.picture.id,
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              TouchableOpacity(
                activeOpacity: activeOpacity,
                onTap: () {
                  showSoapBottomSheet<dynamic>(
                    context,
                    isScrollControlled: true,
                    child: PictureInfoModal(picture: widget.picture),
                  );
                  // if (widget.onInfo != null) {
                  //   widget.onInfo!();
                  // }
                },
                child: const DecoratedIcon(
                  Ionicons.alert_circle_outline,
                  size: 22,
                  color: Colors.white70,
                  shadows: <Shadow>[
                    Shadow(
                      offset: Offset(0.0, 0.5),
                      blurRadius: 4,
                      color: Colors.black38,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
