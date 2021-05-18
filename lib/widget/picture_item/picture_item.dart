import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:soap_app/model/picture.dart';
import 'package:soap_app/utils/picture.dart';
import 'package:soap_app/widget/picture_item/content.dart';
import 'package:soap_app/widget/picture_item/header.dart';

class PictureInfoWidget {
  PictureInfoWidget({
    required this.icon,
    required this.color,
    required this.text,
  });

  IconData icon;
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
    this.crossAxisSpacing = 16,
    this.mainAxisSpacing = 20,
  }) : super(key: key);

  Picture picture;
  bool header;
  String heroLabel;
  double crossAxisSpacing;
  double mainAxisSpacing;
  PictureStyle? pictureStyle;

  Widget bottom() {
    final List<PictureInfoWidget> list = [
      PictureInfoWidget(
        icon: FeatherIcons.eye,
        color: Colors.blue[300]!,
        text: picture.views.toString(),
      ),
      PictureInfoWidget(
        icon: FeatherIcons.messageSquare,
        color: Colors.pink[300]!,
        text: picture.commentCount.toString(),
      ),
      PictureInfoWidget(
        icon: FeatherIcons.heart,
        color: Colors.red[300]!,
        text: picture.likedCount.toString(),
      ),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
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
                      child: Icon(
                        data.icon,
                        color: data.color,
                        size: 20,
                      ),
                    ),
                    Text(
                      data.text,
                      style: const TextStyle(color: Colors.black54),
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
      child: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (header)
                PictureItemHeader(
                  mainAxisSpacing: mainAxisSpacing,
                  crossAxisSpacing: crossAxisSpacing,
                  picture: picture,
                ),
              PictureItemContent(
                heroLabel: heroLabel,
                crossAxisSpacing: crossAxisSpacing,
                picture: picture,
                pictureStyle: pictureStyle,
              ),
              // bottom(),
            ],
          ),
          if (picture.isPrivate != null && picture.isPrivate!)
            Positioned(
              bottom: 8,
              right: 8,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 6,
                    sigmaY: 6,
                  ),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
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
    );
  }
}
