import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:keframe/frame_separate_widget.dart';
import 'package:octo_image/octo_image.dart';
import 'package:soap_app/config/router.dart';
import 'package:soap_app/model/picture.dart';
import 'package:soap_app/pages/new_picture_detail/new_picture_detail.dart';
import 'package:soap_app/repository/picture_repository.dart';
import 'package:soap_app/store/index.dart';
import 'package:soap_app/utils/utils.dart';
import 'package:soap_app/widget/widgets.dart';

import 'picture_item.dart';

class PictureItemContent extends StatelessWidget {
  PictureItemContent({
    Key? key,
    required this.crossAxisSpacing,
    required this.picture,
    required this.gallery,
    this.heroLabel,
    this.pictureStyle,
    this.doubleLike = false,
    this.pictureType,
  }) : super(key: key);

  final double crossAxisSpacing;
  final String? heroLabel;
  final Picture picture;
  final PictureStyle? pictureStyle;
  final bool? doubleLike;
  final pictureItemType? pictureType;
  final bool gallery;

  final PictureRepository _pictureRepository = PictureRepository();

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: picture.width / picture.height,
      child: ClipRRect(
        borderRadius: pictureType == pictureItemType.single
            ? BorderRadius.zero
            : BorderRadius.circular(8),
        child: FrameSeparateWidget(
          placeHolder: Container(
            color: HexColor.fromHex(picture.color),
          ),
          child: LikeGesture(
            onTap: () {
              // if (gallery) {
              //   Navigator.of(context).push<dynamic>(
              //     HeroDetailRoute<void>(
              //       builder: (_) => NewPictureDetail(
              //         picture: picture,
              //       ),
              //     ),
              //   );
              // } else {
              Navigator.of(context).pushNamed(
                RouteName.picture_detail,
                arguments: {
                  'picture': picture,
                  'heroLabel': heroLabel,
                },
              );
              // }
            },
            onLike: (doubleLike! && accountStore.isLogin)
                ? () {
                    _pictureRepository.liked(picture.id);
                  }
                : null,
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Hero(
                tag: '$heroLabel-${picture.id}',
                child: OctoImage(
                  placeholderBuilder: (BuildContext context) {
                    return Container(
                      color: HexColor.fromHex(picture.color),
                    );
                  },
                  errorBuilder: OctoError.blurHash(
                    picture.blurhash,
                    iconColor: Colors.white,
                  ),
                  image: ExtendedImage.network(
                    picture.pictureUrl(
                      style: pictureStyle,
                    ),
                    cache: true,
                  ).image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
