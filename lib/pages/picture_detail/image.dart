import 'dart:convert';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:octo_image/octo_image.dart';
import 'package:soap_app/config/theme.dart';
import 'package:soap_app/model/picture.dart';

class PictureDetailImage extends StatelessWidget {
  PictureDetailImage({required this.picture, this.heroLabel});

  Picture picture;
  String? heroLabel;

  @override
  Widget build(BuildContext context) {
    final double imgMaxHeight = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).size.height / 4) -
        MediaQuery.of(context).padding.bottom -
        MediaQuery.of(context).padding.top -
        appBarHeight;
    final double minFactor = MediaQuery.of(context).size.width / imgMaxHeight;
    final _content = Hero(
        tag: 'picture-$heroLabel-${picture.id}',
        child: OctoImage(
          placeholderBuilder: OctoPlaceholder.blurHash(
            picture.blurhash,
          ),
          image: ExtendedImage.network(picture.pictureUrl()).image,
          fit: BoxFit.cover,
        ));
    final double num = picture.width / picture.height;
    if (num < minFactor && num < 1) {
      return Container(
        color: Theme.of(context).cardColor,
        height: imgMaxHeight,
        child: FractionallySizedBox(
          widthFactor: picture.width / picture.height,
          child: _content,
        ),
      );
    } else {
      return AspectRatio(
        aspectRatio: picture.width / picture.height,
        child: _content,
      );
    }
  }
}
