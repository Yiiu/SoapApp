import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:soap_app/model/picture.dart';

const double pictureDetailHandleHeight = 54;

class PictureDetailHandle extends StatefulWidget {
  const PictureDetailHandle({
    Key? key,
    required this.picture,
  }) : super(key: key);

  final Picture picture;

  @override
  _PictureDetailHandleState createState() => _PictureDetailHandleState();
}

class _PictureDetailHandleState extends State<PictureDetailHandle> {
  FocusNode focusNode = FocusNode();
  bool isComment = false;

  Widget _box(Widget child) {
    final ThemeData theme = Theme.of(context);
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 16,
          sigmaY: 16,
        ),
        child: Container(
          color: theme.cardColor.withOpacity(.85),
          width: double.infinity,
          height: pictureDetailHandleHeight,
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: child,
        ),
      ),
    );
  }

  Widget _defaultBuild() {
    final ThemeData theme = Theme.of(context);
    return _box(
      Flex(
        direction: Axis.horizontal,
        children: [
          Expanded(
            flex: 1,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                focusNode.requestFocus();
                setState(() {
                  isComment = true;
                });
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
                        color:
                            theme.textTheme.bodyText2!.color!.withOpacity(.7),
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
                Text(widget.picture.likedCount.toString())
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _commentBuild() {
    return Stack(
      children: [
        Positioned(
          bottom: pictureDetailHandleHeight,
          left: 0,
          right: 0,
          top: 0,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            child: Container(
              color: Colors.black.withOpacity(.2),
            ),
            onTap: () {
              focusNode.unfocus();
              setState(() {
                isComment = false;
              });
            },
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: _box(TextField(
              // focusNode: focusNode,
              )),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    print('是：$isComment');
    return Positioned(
      bottom: MediaQuery.of(context).viewInsets.bottom,
      left: 0,
      right: 0,
      top: isComment ? 0 : null,
      child: Container(
        height: isComment ? null : pictureDetailHandleHeight,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              height: double.infinity,
              color: Colors.red,
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _box(Stack(
                children: [
                  TextField(focusNode: focusNode),
                  GestureDetector(
                    child: Container(
                      color: Colors.green,
                    ),
                    onTap: () {
                      setState(() {
                        isComment = true;
                      });
                      focusNode.requestFocus();
                    },
                  ),
                ],
              )),
            )
          ],
        ),
      ),
    );
  }
}
