import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:soap_app/model/picture.dart';
import 'package:soap_app/utils/picture.dart';
import 'package:soap_app/widget/like_gesture.dart';
import 'package:soap_app/widget/picture_item/content.dart';
import 'package:soap_app/widget/picture_item/header.dart';

class PictureInfoWidget {
  PictureInfoWidget({
    required this.icon,
    required this.color,
    required this.text,
  });

  String icon;
  Color color;
  String text;
}

class PictureItem extends StatelessWidget {
  const PictureItem({
    Key? key,
    required this.picture,
    this.pictureStyle = PictureStyle.small,
    this.heroLabel = 'list',
    this.header = true,
    this.doubleLike = false,
    this.crossAxisSpacing = 16,
    this.mainAxisSpacing = 20,
  }) : super(key: key);

  final Picture picture;
  final bool header;
  final String heroLabel;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final PictureStyle? pictureStyle;
  final bool? doubleLike;

  Widget bottom(BuildContext context) {
    final List<PictureInfoWidget> list = [
      PictureInfoWidget(
        icon: 'assets/svg/view.svg',
        color: Colors.blue[300]!,
        text: picture.views.toString(),
      ),
      // PictureInfoWidget(
      //   icon: FeatherIcons.messageSquare,
      //   color: Colors.pink[300]!,
      //   text: picture.commentCount.toString(),
      // ),
      PictureInfoWidget(
        icon: 'assets/svg/like.svg',
        color: Colors.red[300]!,
        text: picture.likedCount.toString(),
      ),
    ];
    return Padding(
      padding: EdgeInsets.only(
        top: mainAxisSpacing,
        left: crossAxisSpacing,
        right: crossAxisSpacing,
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: list.map((PictureInfoWidget data) {
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: SvgPicture.asset(
                          data.icon,
                          color: data.color,
                        ),
                      ),
                      // child: Icon(
                      //   data.icon,
                      //   color: data.color,
                      //   size: 20,
                      // ),
                    ),
                    Text(
                      data.text,
                      style: TextStyle(
                        color: Theme.of(context)
                            .textTheme
                            .bodyText2!
                            .color!
                            .withOpacity(.6),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (header)
            PictureItemHeader(
              mainAxisSpacing: mainAxisSpacing,
              crossAxisSpacing: crossAxisSpacing,
              picture: picture,
            ),
          Stack(
            children: [
              PictureItemContent(
                heroLabel: heroLabel,
                crossAxisSpacing: crossAxisSpacing,
                picture: picture,
                pictureStyle: pictureStyle,
                doubleLike: doubleLike,
              ),
              if (picture.isChoice)
                Positioned(
                  top: 8,
                  right: 8 + crossAxisSpacing,
                  child: SizedBox(
                    width: 34,
                    height: 34,
                    child: Stack(
                      children: [
                        SizedBox(
                          width: 34,
                          height: 34,
                          child: ShaderMask(
                            child: SvgPicture.asset('assets/svg/hexagon.svg'),
                            blendMode: BlendMode.srcATop,
                            shaderCallback: (Rect bounds) =>
                                const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: <Color>[
                                Color(0xffF5C164),
                                Color(0xffFF9500),
                              ],
                            ).createShader(bounds),
                          ),
                        ),
                        Center(
                          child: SizedBox(
                            width: 22,
                            height: 22,
                            child: SvgPicture.asset(
                              'assets/svg/planet.svg',
                              color: Colors.white.withOpacity(.8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // ClipOval(
                  //   child: Container(
                  //     decoration: const BoxDecoration(
                  //       gradient: LinearGradient(
                  //         colors: <Color>[Color(0xFFff9500), Color(0xFFf5c164)],
                  //         begin: Alignment.topCenter,
                  //         end: Alignment.bottomCenter,
                  //       ),
                  //     ),
                  //     width: 32,
                  //     height: 32,
                  //     child: Align(
                  //       child: SizedBox(
                  //         width: 22,
                  //         height: 22,
                  //         child: SvgPicture.asset(
                  //           'assets/svg/planet.svg',
                  //           color: Colors.white,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ),
              if (picture.isPrivate != null && picture.isPrivate!)
                Positioned(
                  bottom: 8,
                  right: 8 + crossAxisSpacing,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 6,
                        sigmaY: 6,
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 3, horizontal: 5),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(.3),
                        ),
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              height: 10,
                              width: 10,
                              child: SvgPicture.asset(
                                'assets/remix/lock-fill.svg',
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              '私密',
                              style: TextStyle(
                                fontSize: 10,
                                height: 1.2,
                                color: Colors.white,
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
          if (header) bottom(context),
        ],
      ),
    );
  }
}
