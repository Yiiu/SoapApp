import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:like_button/like_button.dart';
import 'package:soap_app/config/config.dart';
import 'package:soap_app/model/picture.dart';
import 'package:soap_app/pages/picture_detail/stores/handle_store.dart';
import 'package:soap_app/pages/picture_detail/widgets/add_to_collection.dart';
import 'package:soap_app/repository/picture_repository.dart';
import 'package:soap_app/store/index.dart';
import 'package:soap_app/widget/widgets.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

const double pictureDetailHandleHeight = 62;

class PictureDetailHandle extends StatefulWidget {
  const PictureDetailHandle({
    Key? key,
    required this.picture,
    this.handle = true,
  }) : super(key: key);
  final Picture picture;
  final bool? handle;

  @override
  _PictureDetailHandleState createState() => _PictureDetailHandleState();
}

class _PictureDetailHandleState extends State<PictureDetailHandle> {
  final FocusNode focusNode = FocusNode();

  late HandleStore _store;
  @override
  void initState() {
    super.initState();
    _store = HandleStore(picture: widget.picture);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Observer(
      builder: (_) => Positioned(
        // curve: Curves.ease,
        // duration: const Duration(milliseconds: 250),
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 0,
        right: 0,
        top: _store.isComment ? 0 : null,
        child: SizedBox(
          height: _store.isComment
              ? null
              : pictureDetailHandleHeight +
                  MediaQuery.of(context).padding.bottom,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Positioned(
                top: 0,
                left: 0,
                bottom: pictureDetailHandleHeight +
                    MediaQuery.of(context).padding.bottom,
                right: 0,
                child: GestureDetector(
                  child: Container(color: Colors.black.withOpacity(.2)),
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    _store.closeComment();
                  },
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 16,
                      sigmaY: 16,
                    ),
                    child: Container(
                      color: theme.cardColor,
                      width: double.infinity,
                      height: pictureDetailHandleHeight +
                          MediaQuery.of(context).padding.bottom,
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 16,
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).padding.bottom,
                        ),
                        child: Stack(
                          children: <Widget>[
                            PictureDetailHandleComment(
                              focusNode: focusNode,
                              store: _store,
                            ),
                            Offstage(
                              offstage: _store.isComment,
                              child: PictureDetailHandleBasic(
                                focusNode: focusNode,
                                store: _store,
                                handle: widget.handle!,
                                picture: widget.picture,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PictureDetailHandleBasic extends StatelessWidget {
  PictureDetailHandleBasic({
    Key? key,
    required this.focusNode,
    required this.store,
    required this.picture,
    required this.handle,
  }) : super(key: key);

  final PictureRepository _pictureRepository = PictureRepository();

  final HandleStore store;
  final FocusNode focusNode;
  final Picture picture;

  final bool handle;

  bool get isCollected {
    if (picture.currentCollections != null &&
        picture.currentCollections!.isNotEmpty) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        child: Flex(
          direction: Axis.horizontal,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  if (!accountStore.isLogin) {
                    SoapToast.error('请登录后再操作！');
                    return;
                  }
                  FocusScope.of(context).requestFocus(focusNode);
                  store.openComment();
                },
                child: Container(
                  height: double.infinity,
                  padding: const EdgeInsets.only(left: 12),
                  decoration: BoxDecoration(
                    color: theme.backgroundColor,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(100),
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        FeatherIcons.edit3,
                        size: 16,
                        color:
                            theme.textTheme.bodyText2!.color!.withOpacity(.7),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '说点什么吧',
                        style: TextStyle(
                          color:
                              theme.textTheme.bodyText2!.color!.withOpacity(.7),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (handle) ...[
              const SizedBox(width: 12),
              SizedBox(
                height: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    LikeButton(
                      isLiked: picture.isLike,
                      size: 26,
                      onTap: (bool like) async {
                        if (!accountStore.isLogin) {
                          SoapToast.error('请登录后再操作！');
                          return like;
                        }
                        if (!like) {
                          await _pictureRepository.liked(picture.id);
                        } else {
                          await _pictureRepository.unLike(picture.id);
                        }
                        return !like;
                      },
                      animationDuration: const Duration(milliseconds: 800),
                      likeCountAnimationDuration:
                          const Duration(milliseconds: 250),
                      circleColor: const CircleColor(
                          start: Color(0xff00ddff), end: Color(0xff0099cc)),
                      bubblesColor: const BubblesColor(
                        dotPrimaryColor: Color(0xff33b5e5),
                        dotSecondaryColor: Color(0xff0099cc),
                      ),
                      likeBuilder: (bool isLiked) {
                        if (isLiked) {
                          return ShaderMask(
                            child: SvgPicture.asset(
                              'assets/remix/heart-3-fill.svg',
                              color: const Color(0xfffe2341),
                            ),
                            blendMode: BlendMode.srcATop,
                            shaderCallback: (Rect bounds) => RadialGradient(
                              center: Alignment.topLeft
                                  .add(const Alignment(0.66, 0.66)),
                              colors: const [
                                Color(0xffEF6F6F),
                                Color(0xffF03E3E),
                              ],
                            ).createShader(bounds),
                          );
                        }
                        return SvgPicture.asset(
                          'assets/remix/heart-3-line.svg',
                          color:
                              theme.textTheme.bodyText2!.color!.withOpacity(.6),
                        );
                      },
                      likeCount: picture.likedCount,
                      countBuilder: (int? count, bool isLiked, String text) =>
                          count == 0
                              ? Text(
                                  '点个赞吧~',
                                  style: TextStyle(
                                    color: theme.textTheme.bodyText2!.color!
                                        .withOpacity(.6),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              : IntrinsicWidth(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Expanded(
                                        child: AnimatedNumber(
                                          number: count,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                    ),
                    const SizedBox(width: 14),
                    TouchableOpacity(
                      onTap: () {
                        if (!accountStore.isLogin) {
                          SoapToast.error('请登录后再操作！');
                          return;
                        }
                        showSoapBottomSheet<dynamic>(
                          context,
                          child: AddToCollection(
                            current: picture.currentCollections,
                            pictureId: picture.id,
                          ),
                        );
                      },
                      child: SizedBox(
                        width: 26,
                        height: 26,
                        child: isCollected
                            ? ShaderMask(
                                child: SvgPicture.asset(
                                  'assets/feather/star-fill.svg',
                                  color: const Color(0xff47B881),
                                ),
                                blendMode: BlendMode.srcATop,
                                shaderCallback: (Rect bounds) => RadialGradient(
                                  center: Alignment.topLeft
                                      .add(const Alignment(0.66, 0.66)),
                                  colors: const <Color>[
                                    Color(0xff82c1a4),
                                    Color(0xff47b881),
                                  ],
                                ).createShader(bounds),
                              )
                            : Icon(
                                FeatherIcons.star,
                                color: theme.textTheme.bodyText2!.color!
                                    .withOpacity(.6),
                                size: 25,
                              ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class PictureDetailHandleComment extends StatefulWidget {
  const PictureDetailHandleComment({
    Key? key,
    required this.focusNode,
    required this.store,
  }) : super(key: key);

  final HandleStore store;
  final FocusNode focusNode;

  @override
  _PictureDetailHandleCommentState createState() =>
      _PictureDetailHandleCommentState();
}

class _PictureDetailHandleCommentState
    extends State<PictureDetailHandleComment> {
  final TextEditingController _inputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _inputController.addListener(() {
      widget.store.setComment(_inputController.text.trim());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Opacity(
      opacity: widget.store.isComment ? 1 : 0,
      child: Flex(
        direction: Axis.horizontal,
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _inputController,
              focusNode: widget.focusNode,
              cursorColor: theme.primaryColor,
              textInputAction: TextInputAction.send,
              onSubmitted: (String value) {
                if (value.trim().isEmpty) {
                  FocusScope.of(context).requestFocus(widget.focusNode);
                } else {
                  widget.store.addComment();
                  widget.store.closeComment();
                  _inputController.text = '';
                  FocusScope.of(context).unfocus();
                }
              },
              style: const TextStyle(
                fontSize: 16,
                height: 1,
              ),
              decoration: InputDecoration(
                fillColor: theme.backgroundColor,
                filled: true,
                border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(
                    Radius.circular(100),
                  ),
                ),
                hintStyle: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .color!
                      .withOpacity(0.5),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 0,
                ),
              ),
            ),
          ),
          if (widget.store.isComment)
            AnimatedOpacity(
              curve: Curves.ease,
              opacity: widget.store.comment.trim().isEmpty ? 0 : 1,
              duration: const Duration(milliseconds: 250),
              child: AnimatedContainer(
                curve: Curves.ease,
                width: widget.store.comment.trim().isEmpty ? 0 : 52,
                duration: const Duration(milliseconds: 250),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: 0,
                      bottom: 0,
                      top: 0,
                      child: TouchableOpacity(
                        activeOpacity: activeOpacity,
                        onTap: () {
                          widget.store.addComment();
                          widget.store.closeComment();
                          _inputController.text = '';
                          FocusScope.of(context).unfocus();
                        },
                        child: Container(
                          margin: const EdgeInsets.only(left: 12),
                          width: 40,
                          child: Center(
                            child: Text(
                              '评论',
                              style: TextStyle(
                                color: theme.primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
