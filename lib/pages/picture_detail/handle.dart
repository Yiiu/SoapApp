import 'dart:ffi';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:soap_app/model/picture.dart';
import 'package:soap_app/pages/picture_detail/handle_store.dart';

const double pictureDetailHandleHeight = 54;

class PictureDetailHandle extends StatelessWidget {
  PictureDetailHandle({
    Key? key,
    required this.picture,
  });
  Picture picture;
  FocusNode focusNode = FocusNode();

  final _store = HandleStore();

  final _key = UniqueKey();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Observer(
      builder: (_) => Positioned(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 0,
        right: 0,
        top: _store.isComment ? 0 : null,
        child: Container(
          height: _store.isComment ? null : pictureDetailHandleHeight,
          child: Stack(
            fit: StackFit.expand,
            children: [
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
                      color: theme.cardColor.withOpacity(.85),
                      width: double.infinity,
                      height: pictureDetailHandleHeight,
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: Stack(
                        children: [
                          PictureDetailHandleComment(
                            key: ValueKey('comment'),
                            focusNode: focusNode,
                          ),
                          PictureDetailHandleBasic(
                            focusNode: focusNode,
                            store: _store,
                          )
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
  }) : super(key: key);

  final HandleStore store;

  FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Flex(
      direction: Axis.horizontal,
      children: [
        Expanded(
          flex: 1,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              focusNode.requestFocus();
              store.openComment();
              // setState(() {
              //   isComment = true;
              // });
            },
            // child: TextField(),
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
                    color: theme.textTheme.bodyText2!.color!.withOpacity(.7),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Text(
                    '说点什么吧',
                    style: TextStyle(
                      color: theme.textTheme.bodyText2!.color!.withOpacity(.7),
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(
                    width: 0,
                    height: 0,
                    child: TextField(
                      focusNode: focusNode,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 12),
        Container(
          height: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 26,
                width: 26,
                child: SvgPicture.asset(
                  'assets/remix/heart-3-line.svg',
                  color: theme.errorColor,
                ),
              ),
              const SizedBox(
                width: 4,
              ),
              // Text(picture.likedCount.toString())
            ],
          ),
        )
      ],
    );
  }
}

class PictureDetailHandleComment extends StatelessWidget {
  PictureDetailHandleComment({
    Key? key,
    required this.focusNode,
  }) : super(key: key);

  final _controller = TextEditingController();

  FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    print(key);
    final ThemeData theme = Theme.of(context);
    return TextField(
      controller: _controller,
      focusNode: focusNode,
    );
  }
}
