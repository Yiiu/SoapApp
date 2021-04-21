import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soap_app/widget/app_bar.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

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

  Future<void> onRefresh() async {
    await Future.delayed(Duration(seconds: 2), () {
      _controller.resetLoadState();
      _controller.finishRefresh();
    });
  }

  Widget _buildItem() {
    return Text('test');
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
        child: Column(
          children: <Widget>[
            Expanded(
              child: EasyRefresh.custom(
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
                onRefresh: onRefresh,
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return _buildItem();
                      },
                      childCount: 10,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
