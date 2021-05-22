import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:soap_app/model/collection.dart';
import 'package:soap_app/widget/collection_item/preview_item.dart';
import 'package:styled_text/styled_text.dart';

class CollectionItem extends StatelessWidget {
  const CollectionItem({Key? key, required this.collection}) : super(key: key);

  final Collection collection;

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
            Row(
              children: <Widget>[
                if (collection.isPrivate == true)
                  Container(
                    margin: const EdgeInsets.only(top: 2, right: 6),
                    height: 18,
                    width: 18,
                    child: SvgPicture.asset(
                      'assets/remix/lock-fill.svg',
                      color: Colors.amber.shade800,
                    ),
                  ),
                Expanded(
                  child: Text(
                    collection.name,
                    overflow: TextOverflow.fade,
                    maxLines: 1,
                    softWrap: false,
                  ),
                )
              ],
            ),
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
              children: <Widget>[
                CollectionPreiewItem(collection: collection, index: 0),
                const SizedBox(width: 12),
                CollectionPreiewItem(collection: collection, index: 1),
                const SizedBox(width: 12),
                CollectionPreiewItem(collection: collection, index: 2),
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
