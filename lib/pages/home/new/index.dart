import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:soap_app/graphql/fragments.dart';
import 'package:soap_app/graphql/gql.dart';
import 'package:soap_app/graphql/query.dart';
import 'package:soap_app/model/picture.dart';
import 'package:soap_app/widget/app_bar.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:soap_app/widget/picture_item.dart';

class NewView extends StatefulWidget {
  @override
  NewViewState createState() {
    return NewViewState();
  }
}

class NewViewState extends State<NewView>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  final ScrollController _scrollController = ScrollController();
  final EasyRefreshController _controller = EasyRefreshController();

  int page = 1;

  bool isCompleted = false;

  static List<String> get tabs => ['最新', '热门'];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller.callLoad();
    // Provider.of<HomeProvider>(context, listen: false).init();
  }

  void completed() {
    if (!isCompleted) {
      setState(() {
        isCompleted = true;
      });
    }
  }

  Future<void> Function() onRefresh(Refetch refetch) {
    return () async {
      await refetch();
      _controller.resetLoadState();
      _controller.finishRefresh();
    };
  }

  Widget _buildItem(Picture picture) {
    return PictureItem(picture: picture);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Map<String, Map<String, int>> variables = {
      'query': {'page': 1, 'pageSize': 30}
    };
    return FixedAppBarWrapper(
      appBar: const SoapAppBar(
        centerTitle: false,
        elevation: 0.2,
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            '首页',
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: Query(
        options: QueryOptions(
          document: addFragments(
            pictures,
            [...pictureListFragmentDocumentNode],
          ),
          variables: variables,
        ),
        builder: (
          QueryResult result, {
          Refetch? refetch,
          FetchMore? fetchMore,
        }) {
          if (result.hasException) {
            return Text(result.exception.toString());
          }

          if (result.isLoading && result.data == null) {
            return const Text('加载中');
          }

          final List repositories = result.data!['pictures']['data'] as List;

          final List<Picture> pictureList = Picture.fromListJson(repositories);

          return Container(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: EasyRefresh.custom(
                    enableControlFinishRefresh: true,
                    enableControlFinishLoad: true,
                    header: ClassicalHeader(
                      refreshedText: '刷新完成！',
                      refreshingText: '正在刷新...',
                      refreshText: '下拉刷新',
                      refreshReadyText: '松手刷新',
                      showInfo: false,
                    ),
                    footer: ClassicalFooter(
                      loadedText: '加载完成！',
                      loadingText: '正在加载...',
                      loadReadyText: '松手加载',
                      loadText: '上拉加载',
                      noMoreText: '我是有底线的！',
                      showInfo: false,
                    ),
                    controller: _controller,
                    scrollController: _scrollController,
                    onRefresh: onRefresh(refetch!),
                    slivers: <Widget>[
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return _buildItem(pictureList[index]);
                          },
                          childCount: pictureList.length,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
