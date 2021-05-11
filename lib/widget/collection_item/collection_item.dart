import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:octo_image/octo_image.dart';
import 'package:soap_app/model/collection.dart';

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

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.8,
      child: Container(
        color: Colors.red,
        child: Row(
          children: [
            if (collection.preview != null && collection.preview!.length > 0)
              Expanded(
                child: OctoImage(
                  width: double.infinity,
                  height: double.infinity,
                  placeholderBuilder: OctoPlaceholder.blurHash(
                    collection.preview![0].blurhash,
                  ),
                  image:
                      ExtendedImage.network(collection.preview![0].pictureUrl())
                          .image,
                  fit: BoxFit.cover,
                ),
              ),
            // Text(collection.name),
          ],
        ),
      ),
    );
  }
}
