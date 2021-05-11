import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:octo_image/octo_image.dart';
import 'package:soap_app/model/collection.dart';
import 'package:soap_app/model/picture.dart';
import 'package:soap_app/repository/comment_repository.dart';

class CollectionItem extends StatefulWidget {
  CollectionItem({Key? key, required this.collection}) : super(key: key);

  Collection collection;

  @override
  _CollectionItemState createState() => _CollectionItemState();
}

class _CollectionItemState extends State<CollectionItem> {
  late Collection collection;

  @override
  void initState() {
    collection = widget.collection;
    super.initState();
  }

  Widget _preview(int index) {
    final ThemeData theme = Theme.of(context);
    print(collection.preview!.length);
    print(index);
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
                image: ExtendedImage.network(
                        collection.preview![index].pictureUrl())
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

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      color: theme.cardColor,
      margin: const EdgeInsets.only(top: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(collection.name),
            Padding(
              padding: const EdgeInsets.only(top: 6, bottom: 6),
              child: Flex(
                direction: Axis.horizontal,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '照片',
                    style: TextStyle(
                      height: 1,
                      fontSize: 12,
                      color: theme.textTheme.bodyText2!.color!.withOpacity(.8),
                    ),
                  ),
                  Center(
                    widthFactor: 4,
                    child: ClipOval(
                      child: Container(
                        width: 2.5,
                        height: 2.5,
                        color:
                            theme.textTheme.bodyText2!.color!.withOpacity(.6),
                      ),
                    ),
                  ),
                  Text(
                    collection.pictureCount.toString(),
                    style: TextStyle(
                      height: 1,
                      fontSize: 12,
                      color: theme.textTheme.bodyText2!.color!.withOpacity(.8),
                    ),
                  ),
                ],
              ),
            ),
            Flex(
              direction: Axis.horizontal,
              children: [
                _preview(0),
                SizedBox(
                  width: 12,
                ),
                _preview(1),
                SizedBox(
                  width: 12,
                ),
                _preview(2),
              ],
            ),
          ],
        ),
      ),
      // children: [
      //   if (collection.preview != null && collection.preview!.length > 0)
      //     Expanded(
      //       child: OctoImage(
      //         width: double.infinity,
      //         height: double.infinity,
      //         placeholderBuilder: OctoPlaceholder.blurHash(
      //           collection.preview![0].blurhash,
      //         ),
      //         image:
      //             ExtendedImage.network(collection.preview![0].pictureUrl())
      //                 .image,
      //         fit: BoxFit.cover,
      //       ),
      //     ),
      //   // Text(collection.name),
      // ],
    );
  }
}
