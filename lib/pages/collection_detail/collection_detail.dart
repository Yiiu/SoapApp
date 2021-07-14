import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as extended;
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:octo_image/octo_image.dart';
import 'package:soap_app/config/const.dart';
import 'package:soap_app/config/theme.dart';
import 'package:soap_app/graphql/fragments.dart';
import 'package:soap_app/graphql/gql.dart';
import 'package:soap_app/graphql/query.dart';
import 'package:soap_app/model/collection.dart';
import 'package:soap_app/utils/picture.dart';
import 'package:soap_app/widget/avatar.dart';
import 'package:soap_app/widget/collection/collection_more_handle.dart';
import 'package:soap_app/widget/large_custom_header.dart';
import 'package:soap_app/widget/modal_bottom_sheet.dart';
import 'package:soap_app/widget/picture_list.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

class CollectionDetailPage extends StatefulWidget {
  const CollectionDetailPage({
    Key? key,
    required this.collection,
  }) : super(key: key);

  final Collection collection;

  @override
  _CollectionDetailPageState createState() => _CollectionDetailPageState();
}

class _CollectionDetailPageState extends State<CollectionDetailPage> {
  late Collection collection;
  @override
  void initState() {
    collection = widget.collection;
    super.initState();
  }

  Widget _buildSliverHead() {
    final ThemeData theme = Theme.of(context);
    return SliverPersistentHeader(
      // floating: true,
      pinned: true,
      delegate: LargeCustomHeader(
        navBarHeight: appBarHeight + MediaQuery.of(context).padding.top,
        titleHeight: 110,
        barCenterTitle: false,
        backgroundImageMaskColor: const Color.fromRGBO(0, 0, 0, 0.4),
        backgroundImageWidget: OctoPlaceholder.blurHash(
          collection.pictureCount == 0
              ? 'LKO2?U%2Tw=w]~RBVZRi};RPxuwH'
              : collection.preview![0].blurhash,
        )(context),
        titleTextStyle: TextStyle(
          color: theme.cardColor,
          fontSize: 36,
        ),
        title: Container(
          width: double.infinity,
          height: 110,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Text(
                        collection.name,
                        softWrap: false,
                        overflow: TextOverflow.fade,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        children: <Widget>[
                          Avatar(
                            image: collection.user!.avatarUrl,
                            size: 24,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            collection.user!.fullName,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              if (collection.pictureCount! > 0)
                SizedBox(
                  height: double.infinity,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: OctoImage(
                        placeholderBuilder: OctoPlaceholder.blurHash(
                          collection.preview![0].blurhash,
                        ),
                        image: ExtendedImage.network(
                          collection.preview![0]
                              .pictureUrl(style: PictureStyle.small),
                        ).image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              if (collection.pictureCount == 0)
                Container(
                  decoration: BoxDecoration(
                    color: theme.backgroundColor.withOpacity(.4),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  height: double.infinity,
                  child: const AspectRatio(
                    aspectRatio: 1,
                  ),
                )
            ],
          ),
        ),
        bar: Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Text(
            collection.name,
            overflow: TextOverflow.fade,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        actions: [
          TouchableOpacity(
            activeOpacity: activeOpacity,
            onTap: () {
              showBasicModalBottomSheet(
                enableDrag: true,
                context: context,
                builder: (BuildContext context) => CollectionMoreHandle(
                  collection: collection,
                  onRefresh: () {},
                ),
              );
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(
                FeatherIcons.moreHorizontal,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: extended.NestedScrollView(
        physics: const BouncingScrollPhysics(),
        headerSliverBuilder: (BuildContext context, bool? innerBoxIsScrolled) {
          return <Widget>[
            _buildSliverHead(),
          ];
        },
        pinnedHeaderSliverHeightBuilder: () {
          return MediaQuery.of(context).padding.top + appBarHeight;
        },
        innerScrollPositionKeyBuilder: () {
          const String index = 'Tab';
          return const Key(index);
        },
        body: PictureList(
          enablePullDown: false,
          document: addFragments(
            collectionPictures,
            [...pictureListFragmentDocumentNode],
          ),
          label: 'collectionPictures',
          variables: {
            'id': collection.id,
          },
        ),
      ),
    );
  }
}
