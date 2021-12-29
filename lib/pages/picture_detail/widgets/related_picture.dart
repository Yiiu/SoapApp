import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

import '../../../graphql/fragments.dart';
import '../../../graphql/gql.dart';
import '../../../graphql/query.dart';
import '../../../model/picture.dart';
import '../../../utils/picture.dart';
import '../../../widget/picture_item/picture_item.dart';

class RelatedPicture extends StatefulWidget {
  const RelatedPicture({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  _RelatedPictureState createState() => _RelatedPictureState();
}

class _RelatedPictureState extends State<RelatedPicture> {
  @override
  Widget build(BuildContext context) {
    final Map<String, int> variables = {
      'id': widget.id,
      'limit': 10,
    };
    return Query(
      options: QueryOptions(
        document: addFragments(
          pictureRelatedPictures,
          [...relatedPicturesFragmentDocumentNode],
        ),
        variables: variables,
      ),
      // Just like in apollo refetch() could be used to manually trigger a refetch
      // while fetchMore() can be used for pagination purpose
      builder: (QueryResult result,
          {VoidCallback? refetch, FetchMore? fetchMore}) {
        if (result.hasException) {
          return Text(result.exception.toString());
        }

        if (result.isLoading) {
          return const Text('Loading');
        }

        final List<Picture> listData = Picture.fromListJson(
            result.data!['pictureRelatedPictures'] as List<dynamic>);
        // return Text('test');
        return WaterfallFlow.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.all(12),
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate:
              const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: listData.length,
          itemBuilder: (_, int i) => PictureItem(
            heroLabel: 'user-list',
            crossAxisSpacing: 0,
            mainAxisSpacing: 0,
            picture: listData[i],
            header: false,
            pictureStyle: PictureStyle.thumb,
          ),
        );
      },
    );
  }
}
