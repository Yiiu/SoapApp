import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:soap_app/config/config.dart';

import 'package:soap_app/model/picture.dart';
import 'package:soap_app/repository/repository.dart';
import 'package:soap_app/utils/picture.dart';
import 'package:soap_app/widget/widgets.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

enum pictureItemType { single, waterfall }

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
    this.pictureType = pictureItemType.waterfall,
    this.pictureStyle = PictureStyle.small,
    this.heroLabel = 'list',
    this.header = true,
    this.fall = false,
    this.doubleLike = false,
    this.gallery = false,
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
  final pictureItemType? pictureType;
  final bool? doubleLike;
  final bool gallery;

  final PictureRepository _pictureRepository = PictureRepository();

  Widget _bottomBuilder(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final List<PictureInfoWidget> list = [
      // PictureInfoWidget(
      //   icon: FeatherIcons.messageSquare,
      //   color: Colors.pink[300]!,
      //   text: picture.commentCount.toString(),
      // ),
      PictureInfoWidget(
        icon: 'assets/svg/like.svg',
        color: theme.textTheme.bodyText2!.color!,
        text: picture.likedCount.toString(),
      ),
    ];
    return Padding(
      padding: EdgeInsets.only(
        top: 12,
        left: crossAxisSpacing,
        right: crossAxisSpacing,
        bottom: 12,
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: SoapLikeButton(
                  isLike: picture.isLike!,
                  likedCount: picture.likedCount!,
                  id: picture.id,
                  iconSize: 22,
                  textStyle: TextStyle(
                    fontSize: 14,
                    color: theme.textTheme.bodyText2!.color!.withOpacity(.6),
                  ),
                ),
              ),
            ],
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
        Text(
          picture.title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Flex(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  direction: Axis.horizontal,
                  children: [
                    Hero(
                      tag:
                          'user-${picture.user!.username}-${picture.id.toString()}',
                      child: Avatar(
                        size: 18,
                        image: picture.user!.avatarUrl,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
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
                                fontSize: 12,
                                color: theme.textTheme.bodyText2!.color!
                                    .withOpacity(.6),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SoapLikeButton(
              isLike: picture.isLike!,
              likedCount: picture.likedCount!,
              id: picture.id,
              iconSize: 18,
              textStyle: TextStyle(
                fontSize: 12,
                color: theme.textTheme.bodyText2!.color!.withOpacity(.6),
              ),
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
                pictureType: pictureType,
                gallery: gallery,
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
