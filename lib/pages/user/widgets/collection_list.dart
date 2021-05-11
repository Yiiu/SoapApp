import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:soap_app/config/const.dart';
import 'package:soap_app/config/router.dart';
import 'package:soap_app/graphql/fragments.dart';
import 'package:soap_app/graphql/gql.dart';
import 'package:soap_app/graphql/query.dart';
import 'package:soap_app/model/collection.dart';
import 'package:soap_app/widget/collection_item/collection_item.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

class UserCollectionList extends StatefulWidget {
  UserCollectionList({
    Key? key,
    required this.username,
  }) : super(key: key);

  String username;

  @override
  UserCollectionListState createState() => UserCollectionListState();
}

class UserCollectionListState extends State<UserCollectionList>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    final Map<String, String> variables = {
      'username': widget.username,
    };
    return Query(
      options: QueryOptions(
        fetchPolicy: FetchPolicy.cacheAndNetwork,
        document: addFragments(
          userCollectionsByName,
          [...collectionListFragmentDocumentNode],
        ),
        variables: variables,
      ),
      builder: (
        QueryResult result, {
        Refetch? refetch,
        FetchMore? fetchMore,
      }) {
        List<Collection> list = [];
        if (result.data != null) {
          list = Collection.fromListJson(
            result.data!['userCollectionsByName']['data'] as List,
          );
        }
        return SmartRefresher(
          enablePullUp: false,
          enablePullDown: false,
          controller: _refreshController,
          physics: const BouncingScrollPhysics(),
          child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (_, i) => TouchableOpacity(
              activeOpacity: activeOpacity,
              onTap: () {
                Navigator.of(context).pushNamed(
                  RouteName.collection_detail,
                  arguments: {
                    'collection': list[i],
                  },
                );
              },
              child: CollectionItem(
                collection: list[i],
              ),
            ),
          ),
        );
      },
    );
  }
}
