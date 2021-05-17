import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

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
    return Container(
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
        ],
      ),
    );
  }
}
