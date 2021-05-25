import 'package:extended_list/extended_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:soap_app/config/theme.dart';
import 'package:soap_app/model/picture.dart';
import 'package:soap_app/utils/list.dart';
import 'package:soap_app/widget/picture_item/picture_item.dart';

class NewList extends StatelessWidget {
  NewList({
    Key? key,
    required this.loading,
    required this.listData,
    required this.controller,
    required this.onRefresh,
  }) : super(key: key);

  final RefreshController controller;
  final Future<void> Function() onRefresh;

  final Future<void> Function(int) loading;
  final ListData<Picture> listData;

  Future<void> _onLoading() async {
    if (listData.noMore) {
      controller.loadNoData();
      return;
    }
    await loading(listData.page + 1);
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
      body: SmartRefresher(
        enablePullUp: true,
        enablePullDown: true,
        controller: controller,
        physics: const BouncingScrollPhysics(),
        onRefresh: onRefresh,
        onLoading: _onLoading,
        child: ExtendedListView.builder(
          extendedListDelegate: const ExtendedListDelegate(),
          itemBuilder: (BuildContext _, int i) => PictureItem(
            doubleLike: true,
            picture: listData.list[i],
          ),
          itemCount: listData.list.length,
        ),
      ),
    );
  }
}
