import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:soap_app/model/picture.dart';
import 'package:soap_app/provider/home.dart';
import 'package:soap_app/ui/widget/picture_item.dart';

class HomeView extends StatefulWidget {
  @override
  HomeViewState createState() {
    return HomeViewState();
  }
}

class HomeViewState extends State<HomeView> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  RefreshController _refreshController = RefreshController(
    initialRefresh: false,
    // initialRefreshStatus: RefreshStatus.completed,
  );
  ScrollController _controller = new ScrollController();

  int page = 1;

  bool isCompleted = false;

  didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<HomeProvider>(context, listen: false).getPictureList();
  }

  completed() {
    if (!isCompleted) {
      setState(() {
        isCompleted = true;
      });
    }
  }

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
    final theme = Theme.of(context);
    return Container(
      color: theme.backgroundColor,
      child: Column(
        children: <Widget>[
          AppBar(
            centerTitle: false,
            title: Text(
              'Home',
              style: GoogleFonts.rubik(
                textStyle: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          Expanded(
            child: Consumer<HomeProvider>(
              builder: (BuildContext context, HomeProvider home, child) =>
                  SmartRefresher(
                enablePullDown: true,
                enablePullUp: false,
                controller: _refreshController,
                header: refresherHeader,
                footer: refresherFooter,
                child: CustomScrollView(
                  controller: _controller,
                  physics: BouncingScrollPhysics(),
                  slivers: <Widget>[
                    SliverToBoxAdapter(),
                    SliverList(
                      delegate: SliverChildListDelegate(
                        home.pictureList.map((picture) {
                          return _buildItem(picture);
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
