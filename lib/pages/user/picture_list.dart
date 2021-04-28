import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:soap_app/graphql/fragments.dart';
import 'package:soap_app/graphql/gql.dart';
import 'package:soap_app/graphql/query.dart';
import 'package:soap_app/model/picture.dart';
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

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<void> _onRefresh(Refetch refetch) async {
    await refetch();
    _refreshController.refreshCompleted();
  }

  Future<void> _onLoading(int count, FetchMore fetchMore) async {
    final Map<String, Object> fetchMoreVariables = {
      'query': {
        'page': page,
        'pageSize': pageSize,
      }
    };
    final int morePage = (count / pageSize).ceil();
    final FetchMoreOptions opts = FetchMoreOptions(
      variables: fetchMoreVariables,
      updateQuery: (Map<String, dynamic>? previousResultData,
          Map<String, dynamic>? fetchMoreResultData) {
        final List<dynamic> repos = <dynamic>[
          ...previousResultData!['userPicturesByName']['data'] as List<dynamic>,
          ...fetchMoreResultData!['userPicturesByName']['data'] as List<dynamic>
        ];
        fetchMoreResultData['userPicturesByName']['data'] = repos;

        return fetchMoreResultData;
      },
    );
    if (page + 1 >= morePage) {
      _refreshController.loadNoData();
      return;
    }
    await fetchMore(opts);
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    const double padding = 16;
    final variables = {
      'username': widget.username,
      'query': {
        'page': page,
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

          final List repositories =
              result.data!['userPicturesByName']['data'] as List;
          final int page = result.data!['userPicturesByName']['page'] as int;
          final int pageSize =
              result.data!['userPicturesByName']['pageSize'] as int;
          final int count = result.data!['userPicturesByName']['count'] as int;

          final List<Picture> pictureList = Picture.fromListJson(repositories);

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
              itemCount: pictureList.length,
              itemBuilder: (_, i) => PictureItem(
                heroLabel: 'user-list',
                crossAxisSpacing: 0,
                picture: pictureList[i],
                header: false,
              ),
            ),
            onRefresh: () {
              _onRefresh(refetch!);
            },
            onLoading: () {
              _onLoading(count, fetchMore!);
            },
            // onLoading: _onLoading,
            // child: ExtendedListView.builder(
            //   extendedListDelegate: ExtendedListDelegate(),
            //   itemBuilder: (c, i) => PictureItem(
            //     picture: widget.pictureList[i],
            //   ),
            //   itemCount: widget.pictureList.length,
            // ),
          );
        },
      ),
    );
  }
}
