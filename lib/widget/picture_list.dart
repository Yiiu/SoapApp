import 'package:flutter/material.dart';
import 'package:gql/ast.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:soap_app/model/picture.dart';
import 'package:soap_app/store/index.dart';
import 'package:soap_app/utils/list.dart';
import 'package:soap_app/utils/picture.dart';
import 'package:soap_app/utils/query.dart';
import 'package:soap_app/widget/list/error.dart';
import 'package:soap_app/widget/list/loading.dart';
import 'package:soap_app/widget/picture_item/picture_item.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

class PictureList extends StatefulWidget {
  const PictureList({
    Key? key,
    required this.document,
    required this.label,
    required this.variables,
    this.enablePullUp = true,
    this.enablePullDown = true,
  }) : super(key: key);
  final DocumentNode document;
  final String label;
  final Map<String, Object> variables;
  final bool enablePullUp;
  final bool enablePullDown;

  @override
  _PictureListState createState() => _PictureListState();
}

class _PictureListState extends State<PictureList>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  final RefreshController _refreshController =
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
    const double padding = 12;
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
        fetchPolicy: FetchPolicy.cacheAndNetwork,
      ),
      builder: (
        QueryResult result, {
        Refetch? refetch,
        FetchMore? fetchMore,
      }) {
        if (result.hasException && result.data == null) {
          return SoapListError(
            notScrollView: true,
            controller: _refreshController,
            onRefresh: () async {
              _onRefresh(refetch!);
            },
          );
        }

        if (result.isLoading && result.data == null) {
          return SoapListLoading(
            notScrollView: true,
            controller: _refreshController,
          );
        }

        final ListData<Picture> listData = pictureListDataFormat(
          result.data!,
          label: widget.label,
        );

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
              heroLabel: 'user-list',
              crossAxisSpacing: 0,
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
