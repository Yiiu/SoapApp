import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:octo_image/octo_image.dart';
import 'package:soap_app/config/router.dart';
import 'package:soap_app/model/picture.dart';
import 'package:soap_app/repository/picture_repository.dart';
import 'package:soap_app/store/index.dart';
import 'package:soap_app/utils/picture.dart';
import 'package:soap_app/widget/like_gesture.dart';

class PictureItemContent extends StatelessWidget {
  PictureItemContent({
    Key? key,
    this.heroLabel,
    this.pictureStyle,
    this.doubleLike = false,
    required this.crossAxisSpacing,
    required this.picture,
  }) : super(key: key);

  final double crossAxisSpacing;
  final String? heroLabel;
  final Picture picture;
  final PictureStyle? pictureStyle;
  final bool? doubleLike;

  final PictureRepository _pictureRepository = PictureRepository();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: crossAxisSpacing),
      child: AspectRatio(
        aspectRatio: picture.width / picture.height,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LikeGesture(
            onTap: () {
              Navigator.of(context).pushNamed(
                RouteName.picture_detail,
                arguments: {
                  'picture': picture,
                  'heroLabel': heroLabel,
                },
              );
            },
            onLike: (doubleLike! && accountStore.isLogin)
                ? () {
                    _pictureRepository.liked(picture.id);
                  }
                : null,
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: OctoImage(
                placeholderBuilder: OctoPlaceholder.blurHash(
                  picture.blurhash,
                ),
                errorBuilder: OctoError.blurHash(
                  picture.blurhash,
                  iconColor: Colors.white,
                ),
                image: ExtendedImage.network(picture.pictureUrl(
                  style: pictureStyle,
                )).image,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
