import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:soap_app/model/picture.dart';
import 'package:soap_app/provider/home.dart';
import 'package:soap_app/ui/widget/app_bar.dart';
import 'package:soap_app/ui/widget/picture/picture_item.dart';

class HomeView extends StatefulWidget {
  @override
  HomeViewState createState() {
    return HomeViewState();
  }
}

class HomeViewState extends State<HomeView>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  final RefreshController _refreshController = RefreshController(
    initialRefresh: false,
    // initialRefreshStatus: RefreshStatus.completed,
  );
  final ScrollController _controller = ScrollController();

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
    Provider.of<HomeProvider>(context, listen: false).getPictureList();
  }

  void completed() {
    if (!isCompleted) {
      setState(() {
        isCompleted = true;
      });
    }
  }

  // 下拉刷新
  Future<void> _onRefresh() async {
    await Provider.of<HomeProvider>(context, listen: false).getPictureList();
    _refreshController.refreshCompleted();
  }

  Widget _buildItem(Picture picture) {
    return PictureItem(picture: picture);
  }

  @override
  Widget build(BuildContext context) {
    const Widget refresherHeader = ClassicHeader(
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
    final Widget refresherFooter = CustomFooter(
      builder: (BuildContext context, LoadStatus mode) {
        Widget body;
        if (mode == LoadStatus.idle) {
          body = const Text('上拉加载');
        } else if (mode == LoadStatus.loading) {
          body = const CupertinoActivityIndicator();
        } else if (mode == LoadStatus.failed) {
          body = const Text('加载失败！点击重试！');
        } else if (mode == LoadStatus.canLoading) {
          body = const Text('松手,加载更多!');
        } else {
          body = const Text('没有更多数据了!');
        }
        return Container(
          height: 55.0,
          child: Center(child: body),
        );
      },
    );
    final ThemeData theme = Theme.of(context);
    return FixedAppBarWrapper(
      appBar: const SoapAppBar(
        centerTitle: false,
        elevation: 0.1,
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Home',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
      body: Container(
        color: theme.backgroundColor,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Consumer<HomeProvider>(
                builder:
                    (BuildContext context, HomeProvider home, Widget child) =>
                        SmartRefresher(
                  enablePullDown: true,
                  enablePullUp: false,
                  controller: _refreshController,
                  header: refresherHeader,
                  footer: refresherFooter,
                  onRefresh: _onRefresh,
                  child: CustomScrollView(
                    controller: _controller,
                    physics: const BouncingScrollPhysics(),
                    slivers: <Widget>[
                      const SliverToBoxAdapter(),
                      SliverList(
                        delegate: SliverChildListDelegate(
                          home.pictureList.map((Picture picture) {
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
      ),
    );
  }
}
