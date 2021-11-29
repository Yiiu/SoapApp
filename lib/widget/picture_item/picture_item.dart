import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jiffy/jiffy.dart';
import 'package:like_button/like_button.dart';
import 'package:soap_app/config/config.dart';

import 'package:soap_app/model/picture.dart';
import 'package:soap_app/repository/repository.dart';
import 'package:soap_app/store/index.dart';
import 'package:soap_app/utils/picture.dart';
import 'package:soap_app/widget/like_gesture.dart';
import 'package:soap_app/widget/medal.dart';
import 'package:soap_app/widget/picture_item/content.dart';
import 'package:soap_app/widget/picture_item/header.dart';
import 'package:soap_app/widget/widgets.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

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
  PictureItem({
    Key? key,
    required this.picture,
    this.pictureStyle = PictureStyle.small,
    this.heroLabel = 'list',
    this.header = true,
    this.fall = false,
    this.doubleLike = false,
    this.crossAxisSpacing = 16,
    this.mainAxisSpacing = 20,
  }) : super(key: key);

  final Picture picture;
  final bool header;
  final String heroLabel;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final bool fall;
  final PictureStyle? pictureStyle;
  final bool? doubleLike;

  final PictureRepository _pictureRepository = PictureRepository();

  Widget _bottomBuilder(BuildContext context) {
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

  Widget _fallBuilder(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                TouchableOpacity(
                  activeOpacity: activeOpacity,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      RouteName.user,
                      arguments: {
                        'user': picture.user,
                        'heroId': picture.id.toString(),
                      },
                    );
                  },
                  child: Hero(
                    tag:
                        'user-${picture.user!.username}-${picture.id.toString()}',
                    child: Avatar(
                      size: 24,
                      image: picture.user!.avatarUrl,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Flex(
                    direction: Axis.vertical,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TouchableOpacity(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            RouteName.user,
                            arguments: {
                              'user': picture.user,
                              'heroId': picture.id.toString(),
                            },
                          );
                        },
                        child: Text(
                          picture.user!.fullName,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: theme.textTheme.bodyText2!.color,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SoapLikeButton(
              isLike: picture.isLike!,
              likedCount: picture.likedCount!,
              id: picture.id,
              iconSize: 18,
              textStyle: const TextStyle(fontSize: 13),
            )
          ],
        ),
        const SizedBox(
          height: 16,
        ),
      ],
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
                  child: Medal(
                    type: MedalType.choice,
                    size: header ? null : 24,
                  ),
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
          if (fall) _fallBuilder(context),
          if (header) _bottomBuilder(context),
        ],
      ),
    );
  }
}
