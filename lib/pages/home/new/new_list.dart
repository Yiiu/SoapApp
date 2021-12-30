import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../config/config.dart';
import '../../../store/index.dart';
import '../../../widget/widgets.dart';

import 'stores/new_list_store.dart';
import 'widgets/list.dart';

class NewListPageView extends StatefulWidget {
  const NewListPageView({
    Key? key,
    required this.store,
    required this.refreshController,
  }) : super(key: key);

  final NewListStore store;
  final RefreshController refreshController;

  @override
  _NewListPageViewState createState() => _NewListPageViewState();
}

class _NewListPageViewState extends State<NewListPageView>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Observer(builder: (context) {
      return Container(
        color:
            appStore.homeStyle == 2 ? theme.cardColor : theme.backgroundColor,
        child: widget.store.pictureList == null
            ? ListView(
                children: const <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: appBarHeight + 42),
                    child: Center(
                      child: Text('loading'),
                    ),
                  )
                ],
              )
            : LoadMoreListener(
                onLoadMore: () async {
                  await widget.store.fetchMore();
                },
                child: NewList(
                  controller: widget.refreshController,
                  onRefresh: () async {
                    await widget.store.refresh();
                    widget.refreshController.refreshCompleted();
                  },
                  loading: (int page) async {
                    await widget.store.fetchMore();
                  },
                ),
              ),
      );
    });
  }
}
