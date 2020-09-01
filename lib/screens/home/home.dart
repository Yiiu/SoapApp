import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql/internal.dart';
import 'package:provider/provider.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
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

  ObservableQuery observableQuery;

  final EasyRefreshController _controller = EasyRefreshController();

  final ScrollController _scrollController = ScrollController();

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
    // _controller.callLoad();
    // Provider.of<HomeProvider>(context, listen: false).init();
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
    await Provider.of<HomeProvider>(context, listen: false).init();
    _controller.finishRefresh();
  }

  Future<void> _onLoading() async {
    final HomeProvider home = Provider.of<HomeProvider>(context, listen: false);
    await home.onLoading();

    _controller.finishLoad(
      success: true,
      noMore: home.pictureList.length >= home.count,
    );
  }

  Widget _buildItem(Picture picture) {
    return PictureItem(picture: picture);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return FixedAppBarWrapper(
      appBar: const SoapAppBar(
        centerTitle: false,
        elevation: 0.2,
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Home',
          ),
        ),
      ),
      body: Container(
        color: theme.backgroundColor,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Consumer<HomeProvider>(
                builder: (
                  BuildContext context,
                  HomeProvider home,
                  Widget child,
                ) =>
                    home.error == ''
                        ? EasyRefresh.custom(
                            key: home.key,
                            firstRefresh: true,
                            enableControlFinishRefresh: true,
                            enableControlFinishLoad: true,
                            header: ClassicalHeader(
                              refreshedText: '刷新完成！',
                              refreshingText: '正在加载...',
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
                            onRefresh: _onRefresh,
                            onLoad: _onLoading,
                            slivers: [
                              const SliverToBoxAdapter(),
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                    final Picture picture =
                                        home.pictureList[index];
                                    return _buildItem(picture);
                                  },
                                  childCount: home.pictureList.length,
                                ),
                              ),
                            ],
                          )
                        : Text(home.error),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
