import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:octo_image/octo_image.dart';
import 'package:soap_app/config/theme.dart';
import 'package:soap_app/model/picture.dart';

class PictureDetailImage extends StatelessWidget {
  const PictureDetailImage({
    Key? key,
    required this.picture,
    this.heroLabel,
  }) : super(key: key);

  final Picture picture;
  final String? heroLabel;

  @override
  Widget build(BuildContext context) {
    final double imgMaxHeight = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).size.height / 4) -
        MediaQuery.of(context).padding.bottom -
        MediaQuery.of(context).padding.top -
        appBarHeight;
    final double minFactor = MediaQuery.of(context).size.width / imgMaxHeight;

    final Hero _content = Hero(
      tag: 'picture-$heroLabel-${picture.id}',
      child: OctoImage(
        placeholderBuilder: OctoPlaceholder.blurHash(
          picture.blurhash,
        ),
        image: ExtendedImage.network(picture.pictureUrl()).image,
        fit: BoxFit.cover,
      ),
    );
    final double num = picture.width / picture.height;
    if (num < minFactor && num < 1) {
      return SizedBox(
        height: imgMaxHeight,
        child: FractionallySizedBox(
          widthFactor: num / minFactor,
          heightFactor: 1,
          child: _content,
        ),
      );
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: AspectRatio(
          aspectRatio: picture.width / picture.height,
          child: _content,
        ),
      );
    }
  }
}
