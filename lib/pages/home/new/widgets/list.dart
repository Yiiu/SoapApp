import 'package:extended_list/extended_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:soap_app/config/config.dart';
import 'package:soap_app/pages/home/new/stores/new_list_store.dart';
import 'package:soap_app/store/index.dart';
import 'package:soap_app/utils/utils.dart';
import 'package:soap_app/widget/widgets.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

class NewList extends StatelessWidget {
  NewList({
    Key? key,
    required this.loading,
    required this.controller,
    required this.onRefresh,
  }) : super(key: key);

  final RefreshController controller;
  final Future<void> Function() onRefresh;

  final Future<void> Function(int) loading;

  Future<void> _onLoading() async {
    if (newListStore.noMore) {
      controller.loadNoData();
      return;
    }
    await loading(newListStore.page + 1);
    controller.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            backgroundColor: Theme.of(context).backgroundColor,
            title: const Text(''),
            toolbarHeight: appBarHeight,
          )
        ];
      },
      body: Observer(
        builder: (_) => SmartRefresher(
          footer: CustomFooter(
            height: 56 + MediaQuery.of(context).padding.bottom + 50,
            builder: (BuildContext context, LoadStatus? mode) {
              return Column(
                children: <Widget>[
                  Container(
                    height: 50,
                    child: const Center(
                      child: Text('加载中'),
                    ),
                  ),
                  SizedBox(
                    height: 56 + MediaQuery.of(context).padding.bottom,
                  )
                ],
              );
            },
          ),
          enablePullUp: true,
          enablePullDown: true,
          controller: controller,
          physics: const BouncingScrollPhysics(),
          onRefresh: onRefresh,
          onLoading: () async {},
          child: appStore.homeStyle == 1
              ? ExtendedListView.builder(
                  extendedListDelegate: const ExtendedListDelegate(),
                  itemBuilder: (BuildContext _, int i) => PictureItem(
                    doubleLike: true,
                    picture: newListStore.pictureList![i],
                    pictureStyle: PictureStyle.thumb,
                  ),
                  itemCount: newListStore.pictureList!.length,
                )
              : WaterfallFlow.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate:
                      const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: newListStore.pictureList!.length,
                  itemBuilder: (_, int i) => PictureItem(
                    heroLabel: 'picture-list',
                    crossAxisSpacing: 0,
                    mainAxisSpacing: 8,
                    picture: newListStore.pictureList![i],
                    header: false,
                    fall: true,
                    pictureStyle: PictureStyle.thumb,
                  ),
                ),
        ),
      ),
    );
  }
}
