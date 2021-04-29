import 'package:extended_list/extended_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:soap_app/model/picture.dart';
import 'package:soap_app/utils/list.dart';
import 'package:soap_app/widget/picture_item.dart';

class NewList extends StatelessWidget {
  NewList({
    Key? key,
    required this.refetch,
    required this.loading,
    required this.listData,
  }) : super(key: key);

  Future<void> Function() refetch;
  Future<void> Function(int) loading;
  ListData<Picture> listData;

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  Future<void> _onRefresh() async {
    await refetch();
    _refreshController.refreshCompleted();
  }

  Future<void> _onLoading() async {
    if (listData.noMore) {
      _refreshController.loadNoData();
      return;
    }
    await loading(listData.page + 1);
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      child: Column(
        children: <Widget>[
          Expanded(
            child: SmartRefresher(
              // header: SizedBox(
              //   height: 10,
              // ),
              enablePullUp: true,
              enablePullDown: true,
              controller: _refreshController,
              physics: const BouncingScrollPhysics(),
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: ExtendedListView.builder(
                extendedListDelegate: const ExtendedListDelegate(),
                itemBuilder: (BuildContext _, int i) => PictureItem(
                  picture: listData.list[i],
                ),
                itemCount: listData.list.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
