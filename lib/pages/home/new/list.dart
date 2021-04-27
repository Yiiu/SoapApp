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
    required this.pictureList,
  }) : super(key: key);

  Refetch refetch;
  List<Picture> pictureList;

  @override
  _NewListState createState() => _NewListState();
}

class _NewListState extends State<NewList> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<void> onRefresh() async {
    await widget.refetch();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      child: Column(
        children: <Widget>[
          Expanded(
            child: SmartRefresher(
              controller: _refreshController,
              physics: const BouncingScrollPhysics(),
              child: ListView.builder(
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
