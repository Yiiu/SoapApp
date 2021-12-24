import 'package:decorated_icon/decorated_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:jiffy/jiffy.dart';
import 'package:soap_app/model/picture.dart';
import 'package:soap_app/model/tag.dart';

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
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              widget.picture.title,
              style: TextStyle(
                color: Colors.white,
                fontSize: theme.textTheme.bodyText2!.fontSize! + 2,
                shadows: shadow,
              ),
            ),
            if (widget.picture.tags != null && widget.picture.tags!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: SizedBox(
                  width: double.infinity,
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    alignment: WrapAlignment.start,
                    runAlignment: WrapAlignment.end,
                    children: widget.picture.tags!
                        .map(
                          (Tag tag) => Row(
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
                        )
                        .toList(),
                  ),
                ),
              ),
            const SizedBox(height: 4),
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
          ],
        ),
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
          children: [
            Positioned(
              // bottom: 0,
              child: Container(
                height: 160,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black38,
                      Colors.transparent,
                    ],
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
