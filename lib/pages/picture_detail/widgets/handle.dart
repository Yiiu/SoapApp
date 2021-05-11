import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:like_button/like_button.dart';
import 'package:soap_app/config/const.dart';
import 'package:soap_app/graphql/query.dart';
import 'package:soap_app/model/picture.dart';
import 'package:soap_app/pages/picture_detail/stores/handle_store.dart';
import 'package:soap_app/repository/comment_repository.dart';
import 'package:soap_app/repository/picture_repository.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

const double pictureDetailHandleHeight = 62;

class PictureDetailHandle extends StatefulWidget {
  PictureDetailHandle({
    Key? key,
    required this.picture,
  }) : super(key: key);
  final Picture picture;

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
          height: _store.isComment ? null : pictureDetailHandleHeight,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Positioned(
                top: 0,
                left: 0,
                bottom: pictureDetailHandleHeight,
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
                      height: pictureDetailHandleHeight,
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 16,
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
                              picture: widget.picture,
                            ),
                          ),
                        ],
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
  }) : super(key: key);

  PictureRepository pictureRepository = PictureRepository();

  HandleStore store;
  FocusNode focusNode;
  Picture picture;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Container(
        child: Flex(
          direction: Axis.horizontal,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
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
                    children: [
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
            const SizedBox(width: 12),
            SizedBox(
              height: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  LikeButton(
                    isLiked: picture.isLike,
                    size: 28,
                    onTap: (bool like) async {
                      if (!like) {
                        pictureRepository.liked(picture.id);
                      } else {
                        pictureRepository.unLike(picture.id);
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
                        return SvgPicture.asset(
                          'assets/remix/heart-3-fill.svg',
                          color: const Color(0xfffe2341),
                        );
                      }
                      return SvgPicture.asset(
                        'assets/remix/heart-3-line.svg',
                        color:
                            theme.textTheme.bodyText2!.color!.withOpacity(.6),
                      );
                    },
                    countBuilder: (int? count, bool isLiked, String text) =>
                        Text(
                      text,
                      style: GoogleFonts.rubik(
                        textStyle: TextStyle(
                          color: theme.textTheme.bodyText2!.color,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    likeCount: picture.likedCount,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PictureDetailHandleComment extends StatefulWidget {
  PictureDetailHandleComment({
    Key? key,
    required this.focusNode,
    required this.store,
  }) : super(key: key);

  HandleStore store;
  FocusNode focusNode;

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
        children: [
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
