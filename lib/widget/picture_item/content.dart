import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:octo_image/octo_image.dart';
import 'package:soap_app/config/const.dart';
import 'package:soap_app/config/router.dart';
import 'package:soap_app/model/picture.dart';
import 'package:soap_app/utils/picture.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

class PictureItemContent extends StatelessWidget {
  PictureItemContent({
    Key? key,
    this.heroLabel,
    this.pictureStyle,
    required this.crossAxisSpacing,
    required this.picture,
  }) : super(key: key);

  double crossAxisSpacing;
  String? heroLabel;
  Picture picture;
  PictureStyle? pictureStyle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: crossAxisSpacing),
      child: TouchableOpacity(
        activeOpacity: activeOpacity,
        onTap: () {
          Navigator.of(context).pushNamed(
            RouteName.picture_detail,
            arguments: {
              'picture': picture,
              'heroLabel': heroLabel,
            },
          );
        },
        child: AspectRatio(
          aspectRatio: picture.width / picture.height,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: OctoImage(
              placeholderBuilder: OctoPlaceholder.blurHash(
                picture.blurhash,
              ),
              image: ExtendedImage.network(picture.pictureUrl(
                style: pictureStyle,
              )).image,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
