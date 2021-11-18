import 'package:flutter/material.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as extended;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:octo_image/octo_image.dart';
import 'package:soap_app/config/theme.dart';
import 'package:soap_app/graphql/fragments.dart';
import 'package:soap_app/graphql/gql.dart';
import 'package:soap_app/model/tag.dart';
import 'package:soap_app/utils/exception.dart';
import 'package:soap_app/widget/large_custom_header.dart';
import 'package:soap_app/graphql/query.dart' as query;
import 'package:soap_app/widget/picture_list.dart';

class TagDetailPage extends StatefulWidget {
  const TagDetailPage({
    Key? key,
    required this.tag,
  }) : super(key: key);

  final Tag tag;

  @override
  _TagDetailPageState createState() => _TagDetailPageState();
}

class _TagDetailPageState extends State<TagDetailPage> {
  late Tag tag;
  @override
  void initState() {
    tag = widget.tag;
    super.initState();
  }

  Widget _buildSliverHead(Tag tag) {
    final ThemeData theme = Theme.of(context);
    return SliverPersistentHeader(
      // floating: true,
      pinned: true,
      delegate: LargeCustomHeader(
        navBarHeight: appBarHeight + MediaQuery.of(context).padding.top,
        titleHeight: 80,
        barCenterTitle: false,
        backgroundImageMaskColor: const Color.fromRGBO(0, 0, 0, 0.4),
        backgroundImageWidget: OctoPlaceholder.blurHash(
          'LKO2?U%2Tw=w]~RBVZRi};RPxuwH',
        )(context),
        titleTextStyle: TextStyle(
          color: theme.cardColor,
          fontSize: 36,
        ),
        title: Container(
          width: double.infinity,
          height: 95,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          child: Flex(
            direction: Axis.vertical,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 22,
                    height: 22,
                    child: SvgPicture.asset(
                      'assets/remix/tag.svg',
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    tag.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                '${tag.pictureCount} 张图片',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        bar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Row(
            children: <Widget>[
              SizedBox(
                height: 22,
                width: 22,
                child: SvgPicture.asset(
                  'assets/remix/tag.svg',
                  color: Colors.white,
                ),
              ),
              Text(
                tag.name,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Query(
        options: QueryOptions(
          document: addFragments(
            query.tag,
            [tagFragment],
          ),
          fetchPolicy: FetchPolicy.cacheFirst,
          variables: {
            'name': tag.name,
          } as Map<String, dynamic>,
        ),
        builder: (
          QueryResult result, {
          Refetch? refetch,
          FetchMore? fetchMore,
        }) {
          Tag data = tag;

          if (result.hasException) {
            captureException(result.exception);
          }
          if (result.data != null && result.data!['tag'] != null) {
            data = Tag.fromJson(result.data!['tag'] as Map<String, dynamic>);
          }
          return extended.ExtendedNestedScrollView(
            physics: const BouncingScrollPhysics(),
            headerSliverBuilder:
                (BuildContext context, bool? innerBoxIsScrolled) {
              return <Widget>[
                _buildSliverHead(data),
              ];
            },
            pinnedHeaderSliverHeightBuilder: () {
              return MediaQuery.of(context).padding.top + appBarHeight;
            },
            body: PictureList(
              enablePullDown: false,
              document: addFragments(
                query.tagPictures,
                [...pictureListFragmentDocumentNode],
              ),
              label: 'tagPictures',
              variables: {
                'name': data.name,
              },
            ),
          );
        },
      ),
    );
  }
}
