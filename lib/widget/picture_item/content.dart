import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:keframe/frame_separate_widget.dart';
import 'package:octo_image/octo_image.dart';

import '../../model/picture.dart';
import '../../pages/new_picture_detail/new_picture_detail.dart';
import '../../repository/picture_repository.dart';
import '../../store/index.dart';
import '../../utils/utils.dart';
import '../widgets.dart';

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
    final Widget content = AspectRatio(
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
            onLike: (doubleLike! && accountStore.isLogin)
                ? () {
                    _pictureRepository.liked(picture.id);
                  }
                : null,
            onTap: () {
              Navigator.of(context).push<dynamic>(
                HeroDetailRoute<void>(
                  builder: (_) => NewPictureDetail(
                    heroLabel: heroLabel,
                    picture: picture,
                    pictureStyle: pictureStyle,
                  ),
                ),
              );
            },
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
                  ).image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ),
    );
    if (doubleLike != null && doubleLike!) {
      return content;
    }
    return Bounceable(
      curve: Curves.easeInOut,
      reverseCurve: Curves.easeInOut,
      // reverseCurve: Curves.easeOutCubic,
      onTap: () {},
      child: content,
    );
  }
}
