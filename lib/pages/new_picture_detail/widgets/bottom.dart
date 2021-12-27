import 'dart:ui';

import 'package:decorated_icon/decorated_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:ionicons/ionicons.dart';
import 'package:jiffy/jiffy.dart';
import 'package:soap_app/config/config.dart';
import 'package:soap_app/model/picture.dart';
import 'package:soap_app/model/tag.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

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
  late Animation<Offset> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _bottomAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, 1),
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
                alignment: WrapAlignment.start,
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
                          children: [
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
              children: [
                DecoratedIcon(
                  FeatherIcons.mapPin,
                  size: 12,
                  color: Colors.white.withOpacity(.6),
                  shadows: shadow,
                ),
                const SizedBox(width: 4),
                Text(
                  widget.picture.location!['name'],
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
            children: [
              DecoratedIcon(
                FeatherIcons.clock,
                size: 12,
                color: Colors.white.withOpacity(.6),
                shadows: shadow,
              ),
              const SizedBox(width: 4),
              Text(
                '发布于 ${Jiffy(widget.picture.createTime.toString()).fromNow()}',
                style: TextStyle(
                  color: Colors.white.withOpacity(.6),
                  fontSize: 12,
                  shadows: shadow,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: const BorderRadius.all(
              Radius.circular(100.0),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 16,
                sigmaY: 16,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.1),
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 2,
                ),
                child: Text(
                  '查看原图',
                  style: TextStyle(
                    color: Colors.white.withOpacity(.9),
                    fontSize: 11,
                    shadows: shadow,
                  ),
                ),
              ),
            ),
          ),
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
      child: SlideTransition(
        position: _bottomAnimation,
        child: Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: [
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
    );
  }
}
