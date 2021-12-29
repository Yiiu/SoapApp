import 'package:flutter/material.dart';
import 'package:gql/ast.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

import '../model/picture.dart';
import '../utils/exception.dart';
import '../utils/list.dart';
import '../utils/picture.dart';
import '../utils/query.dart';
import 'list/empty.dart';
import 'list/error.dart';
import 'list/loading.dart';
import 'picture_item/picture_item.dart';

class PictureList extends StatefulWidget {
  const PictureList({
    Key? key,
    required this.document,
    required this.label,
    required this.variables,
    this.heroLabel,
    this.enablePullUp = true,
    this.enablePullDown = true,
  }) : super(key: key);

  final DocumentNode document;
  final String label;
  final Map<String, Object> variables;
  final bool enablePullUp;
  final bool enablePullDown;
  final String? heroLabel;

  @override
  _PictureListState createState() => _PictureListState();
}

class _PictureListState extends State<PictureList>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  final RefreshController _loadingRefreshController =
      RefreshController(initialRefresh: false);

  final RefreshController _errorRefreshController =
      RefreshController(initialRefresh: false);

  int page = 1;
  int pageSize = 30;

  Future<void> _onRefresh(Refetch refetch) async {
    final QueryResult? data = await refetch();
    if (data != null && data.hasException) {
      _refreshController.refreshFailed();
      return;
    }
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
      'query': {
        'page': page + 1,
        'pageSize': pageSize,
      },
      ...widget.variables,
    };
    await fetchMore(
      listFetchMoreOptions(
        variables: fetchMoreVariables,
        label: widget.label,
      ),
    );
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    const double padding = 8;
    final Map<String, Object> variables = {
      'query': {
        'page': 1,
        'pageSize': pageSize,
      },
      ...widget.variables,
    };
    return Query(
      options: QueryOptions(
        document: widget.document,
        variables: variables,
        fetchPolicy: FetchPolicy.cacheFirst,
      ),
      builder: (
        QueryResult result, {
        Refetch? refetch,
        FetchMore? fetchMore,
      }) {
        if (result.hasException) {
          captureException(result.exception);
        }
        if (result.hasException && result.data == null) {
          return SoapListError(
            notScrollView: true,
            controller: _errorRefreshController,
            onRefresh: () async {
              _onRefresh(refetch!);
            },
          );
        }

        if (result.isLoading && result.data == null) {
          return SoapListLoading(
            notScrollView: true,
            controller: _loadingRefreshController,
          );
        }

        final ListData<Picture> listData = pictureListDataFormat(
          result.data!,
          label: widget.label,
        );

        if (listData.count == 0) {
          return const SoapListEmpty();
          // return ;
        }
        return SmartRefresher(
          enablePullUp: widget.enablePullUp,
          enablePullDown: widget.enablePullDown,
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
            itemBuilder: (_, int i) => PictureItem(
              heroLabel: widget.heroLabel,
              crossAxisSpacing: 0,
              mainAxisSpacing: padding,
              picture: listData.list[i],
              header: false,
              pictureStyle: PictureStyle.thumb,
            ),
          ),
          onRefresh: () {
            _onRefresh(refetch!);
          },
          onLoading: () => _onLoading(fetchMore!, listData.count),
        );
      },
    );
  }
}
