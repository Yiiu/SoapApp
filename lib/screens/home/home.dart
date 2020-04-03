import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:soap_app/graphql/query/picture.dart';
import 'package:soap_app/model/picture.dart';
import 'package:soap_app/ui/widget/app_bar.dart';
import 'package:soap_app/ui/widget/picture_item.dart';

class HomeView extends StatefulWidget {
  @override
  HomeViewState createState() {
    return HomeViewState();
  }
}

class HomeViewState extends State<HomeView> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  ScrollController _controller = new ScrollController();

  int page = 1;

  _onRefresh(Function refresh) {
    return () async {
      await refresh();
      _refreshController.refreshCompleted();
    };
  }

  _onLoading(FetchMore more) {
    FetchMoreOptions opts = FetchMoreOptions(
      variables: {
        'query': {'page': page + 1}
      },
      updateQuery: (previousResultData, fetchMoreResultData) {
        // this function will be called so as to combine both the original and fetchMore results
        // it allows you to combine them as you would like
        print(fetchMoreResultData['pictures']['data']);
        final List<dynamic> repos = [
          ...previousResultData['pictures']['data'] as List<dynamic>,
          ...fetchMoreResultData['pictures']['data'] as List<dynamic>
        ];

        // to avoid a lot of work, lets just update the list of repos in returned
        // data with new data, this also ensures we have the endCursor already set
        // correctly
        fetchMoreResultData['pictures']['data'] = repos;

        return fetchMoreResultData;
      },
    );
    return () async {
      // setState(() => page += 1);
      await more(opts);
      await Future.delayed(Duration(milliseconds: 500));
      _refreshController.loadComplete();
    };
  }

  Widget _buildItem(Picture picture) {
    return PictureItem(picture: picture);
  }

  @override
  Widget build(BuildContext context) {
    Widget refresherHeader = ClassicHeader(
      refreshStyle: RefreshStyle.UnFollow,
      idleText: '',
      idleIcon: CupertinoActivityIndicator(
        animating: false,
      ),
      refreshingText: '',
      refreshingIcon: CupertinoActivityIndicator(),
      releaseText: '',
      releaseIcon: CupertinoActivityIndicator(),
      completeText: '',
    );
    Widget refresherFooter = CustomFooter(
      builder: (BuildContext context, LoadStatus mode) {
        Widget body;
        if (mode == LoadStatus.idle) {
          body = Text("上拉加载");
        } else if (mode == LoadStatus.loading) {
          body = CupertinoActivityIndicator();
        } else if (mode == LoadStatus.failed) {
          body = Text("加载失败！点击重试！");
        } else if (mode == LoadStatus.canLoading) {
          body = Text("松手,加载更多!");
        } else {
          body = Text("没有更多数据了!");
        }
        return Container(
          height: 55.0,
          child: Center(child: body),
        );
      },
    );
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          SoapAppBar(
            title: 'Home',
            controller: _controller,
          ),
          Expanded(
            child: Query(
              options: QueryOptions(
                documentNode: gql(pictures),
                fetchPolicy: FetchPolicy.cacheAndNetwork,
                // pollInterval: 15,
                variables: {
                  'query': {
                    'page': 1,
                    'pageSize': 5,
                  }
                },
              ),
              builder: (QueryResult result,
                  {VoidCallback refetch, FetchMore fetchMore}) {
                if (result.hasException) {
                  return SmartRefresher(
                    enablePullDown: true,
                    enablePullUp: false,
                    controller: _refreshController,
                    onRefresh: _onRefresh(refetch),
                    header: refresherHeader,
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(64.0),
                              child: Text(
                                '出错啦',
                                style: TextStyle(
                                  fontSize: 32,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                if (result.loading && result.data == null) {
                  return SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(64.0),
                            child: CupertinoActivityIndicator(),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                List pictures =
                    Picture.fromListJson(result.data['pictures']['data']);
                return SmartRefresher(
                  enablePullDown: true,
                  enablePullUp: true,
                  controller: _refreshController,
                  onRefresh: _onRefresh(refetch),
                  onLoading: _onLoading(fetchMore),
                  header: refresherHeader,
                  footer: refresherFooter,
                  child: CustomScrollView(
                    controller: _controller,
                    physics: BouncingScrollPhysics(),
                    slivers: <Widget>[
                      SliverToBoxAdapter(),
                      SliverList(
                        delegate: SliverChildListDelegate(
                          pictures.map((picture) {
                            return _buildItem(picture);
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
