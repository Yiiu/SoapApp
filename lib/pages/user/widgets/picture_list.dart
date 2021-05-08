import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:soap_app/graphql/fragments.dart';
import 'package:soap_app/graphql/gql.dart';
import 'package:soap_app/graphql/query.dart';
import 'package:soap_app/model/picture.dart';
import 'package:soap_app/utils/list.dart';
import 'package:soap_app/utils/query.dart';
import 'package:soap_app/widget/picture_item.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

class UserPictureList extends StatefulWidget {
  UserPictureList({
    Key? key,
    required this.username,
  }) : super(key: key);
  String username;

  @override
  _UserPictureListState createState() => _UserPictureListState();
}

class _UserPictureListState extends State<UserPictureList> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  int page = 1;
  int pageSize = 30;

  Future<void> _onRefresh(Refetch refetch) async {
    await refetch();
    _refreshController.refreshCompleted();
  }

  Future<void> _onLoading(
    FetchMore fetchMore,
    int count,
  ) async {
    final int morePage = (count / pageSize).ceil();

    final bool noMore = page + 1 >= morePage;

    if (noMore) {
      _refreshController.loadNoData();
      return;
    }
    setState(() {
      page++;
    });
    final Map<String, Object> fetchMoreVariables = {
      'username': widget.username,
      'query': {
        'page': page + 1,
        'pageSize': pageSize,
      }
    };
    await fetchMore(
      listFetchMoreOptions(
        variables: fetchMoreVariables,
        label: 'userPicturesByName',
      ),
    );
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    const double padding = 16;
    final Map<String, Object> variables = {
      'username': widget.username,
      'query': {
        'page': 1,
        'pageSize': pageSize,
      }
    };
    return Container(
      child: Query(
        options: QueryOptions(
          document: addFragments(
            userPictures,
            [...pictureListFragmentDocumentNode],
          ),
          variables: variables,
        ),
        builder: (
          QueryResult result, {
          Refetch? refetch,
          FetchMore? fetchMore,
        }) {
          if (result.hasException && result.data == null) {
            return Text(result.exception.toString());
          }

          if (result.isLoading && result.data == null) {
            return const Text('加载中');
          }
          final ListData<Picture> listData = pictureListDataFormat(
            result.data!,
            label: 'userPicturesByName',
          );

          return SmartRefresher(
            enablePullUp: true,
            enablePullDown: true,
            controller: _refreshController,
            physics: const BouncingScrollPhysics(),
            child: WaterfallFlow.builder(
              padding: const EdgeInsets.all(padding),
              gridDelegate:
                  const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: padding,
                mainAxisSpacing: padding,
              ),
              itemCount: listData.list.length,
              itemBuilder: (_, i) => PictureItem(
                heroLabel: 'user-list',
                crossAxisSpacing: 0,
                picture: listData.list[i],
                header: false,
              ),
            ),
            onRefresh: () {
              _onRefresh(refetch!);
            },
            onLoading: () => _onLoading(fetchMore!, listData.count),
          );
        },
      ),
    );
  }
}
