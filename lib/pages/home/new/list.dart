import 'package:extended_list/extended_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:soap_app/model/picture.dart';
import 'package:soap_app/widget/picture_item.dart';

class NewList extends StatefulWidget {
  NewList({
    Key? key,
    required this.refetch,
    required this.loading,
    required this.pictureList,
    required this.morePage,
    required this.page,
  }) : super(key: key);

  Future<void> Function() refetch;
  Future<void> Function(int) loading;
  List<Picture> pictureList;
  int morePage;
  int page;

  @override
  _NewListState createState() => _NewListState();
}

class _NewListState extends State<NewList> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<void> _onRefresh() async {
    await widget.refetch();
    _refreshController.refreshCompleted();
  }

  Future<void> _onLoading() async {
    if (widget.page + 1 >= widget.morePage) {
      _refreshController.loadNoData();
      return;
    }
    await widget.loading(widget.page + 1);
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
              enablePullUp: true,
              enablePullDown: true,
              controller: _refreshController,
              physics: const BouncingScrollPhysics(),
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: ExtendedListView.builder(
                extendedListDelegate: ExtendedListDelegate(),
                itemBuilder: (c, i) => PictureItem(
                  picture: widget.pictureList[i],
                ),
                itemCount: widget.pictureList.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
