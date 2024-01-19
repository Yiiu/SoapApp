import 'dart:ui';

import 'package:decorated_icon/decorated_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:jiffy/jiffy.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

import '../../../config/config.dart';
import '../../../model/picture.dart';
import '../../../model/tag.dart';
import '../constants.dart';

class NewPictureDetailBottom extends StatefulWidget {
  const NewPictureDetailBottom({
    Key? key,
    required this.controller,
    required this.picture,
  }) : super(key: key);

  final AnimationController controller;
  final Picture picture;

  @override
  _NewPictureDetailBottomState createState() => _NewPictureDetailBottomState();
}

class _NewPictureDetailBottomState extends State<NewPictureDetailBottom> {
  late Animation<Offset> _bottomAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _bottomAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, 1),
    ).animate(
      CurvedAnimation(parent: widget.controller, curve: Curves.easeInOut),
    );
    _opacityAnimation = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(
      CurvedAnimation(parent: widget.controller, curve: Curves.easeInOut),
    );
  }

  Widget _buildContent(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).padding.bottom + 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(
            widget.picture.title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.white,
              fontSize: theme.textTheme.bodyText2!.fontSize! + 2,
              shadows: shadow,
            ),
          ),
          const SizedBox(height: 4),
          if (widget.picture.tags != null &&
              widget.picture.tags!.isNotEmpty) ...[
            SizedBox(
              width: double.infinity,
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                runAlignment: WrapAlignment.end,
                children: widget.picture.tags!
                    .map(
                      (Tag tag) => TouchableOpacity(
                        activeOpacity: activeOpacity,
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            RouteName.tag_detail,
                            arguments: {
                              'tag': tag,
                            },
                          );
                        },
                        child: Row(
                          children: <Widget>[
                            const Icon(
                              FeatherIcons.hash,
                              size: 12,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              tag.name,
                              style: const TextStyle(
                                color: Colors.white,
                                shadows: shadow,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 4),
          ],
          if (widget.picture.location != null) ...[
            Row(
              children: <Widget>[
                DecoratedIcon(
                  FeatherIcons.mapPin,
                  size: 12,
                  color: Colors.white.withOpacity(.6),
                  shadows: shadow,
                ),
                const SizedBox(width: 4),
                Text(
                  widget.picture.location!.name,
                  style: TextStyle(
                    color: Colors.white.withOpacity(.9),
                    fontSize: 12,
                    shadows: shadow,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
          ],
          Row(
            children: <Widget>[
              DecoratedIcon(
                FeatherIcons.clock,
                size: 12,
                color: Colors.white.withOpacity(.6),
                shadows: shadow,
              ),
              const SizedBox(width: 4),
              Text(
                FlutterI18n.translate(
                    context, 'picture.label.form_now', translationParams: {
                  'time': Jiffy.parse(widget.picture.createTime.toString()).fromNow()
                }),
                // '发布于 ${Jiffy(widget.picture.createTime.toString()).fromNow()}',
                style: TextStyle(
                  color: Colors.white.withOpacity(.6),
                  fontSize: 12,
                  shadows: shadow,
                ),
              ),
            ],
          ),
          // const SizedBox(height: 6),
          // ClipRRect(
          //   borderRadius: const BorderRadius.all(
          //     Radius.circular(100.0),
          //   ),
          //   child: BackdropFilter(
          //     filter: ImageFilter.blur(
          //       sigmaX: 16,
          //       sigmaY: 16,
          //     ),
          //     child: Container(
          //       decoration: BoxDecoration(
          //         color: Colors.white.withOpacity(.1),
          //         borderRadius: BorderRadius.circular(25),
          //       ),
          //       padding: const EdgeInsets.symmetric(
          //         horizontal: 10,
          //         vertical: 2,
          //       ),
          //       child: Text(
          //         '查看原图',
          //         style: TextStyle(
          //           color: Colors.white.withOpacity(.9),
          //           fontSize: 11,
          //           shadows: shadow,
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: SlideTransition(
          position: _bottomAnimation,
          child: Stack(
            alignment: AlignmentDirectional.bottomStart,
            children: <Widget>[
              IgnorePointer(
                child: Container(
                  height: 200 + MediaQuery.of(context).padding.bottom,
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: IgnorePointer(
                  child: Container(
                    height: 160 + MediaQuery.of(context).padding.bottom,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black45,
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              _buildContent(context),
            ],
          ),
        ),
      ),
    );
  }
}
