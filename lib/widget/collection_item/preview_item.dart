import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:octo_image/octo_image.dart';
import '../../model/collection.dart';
import '../../utils/picture.dart';

class CollectionPreiewItem extends StatelessWidget {
  const CollectionPreiewItem({
    Key? key,
    required this.collection,
    required this.index,
  }) : super(key: key);

  final Collection collection;
  final int index;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    if (collection.preview!.length > index) {
      return Expanded(
        child: AspectRatio(
          aspectRatio: 1.5,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: theme.backgroundColor,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: OctoImage(
                width: double.infinity,
                height: double.infinity,
                placeholderBuilder: OctoPlaceholder.blurHash(
                  collection.preview![0].blurhash,
                ),
                image: ExtendedImage.network(collection.preview![index]
                        .pictureUrl(style: PictureStyle.small))
                    .image,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      );
    }
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1.5,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            color: theme.backgroundColor,
          ),
        ),
      ),
    );
  }
}
