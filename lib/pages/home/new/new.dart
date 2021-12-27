import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:soap_app/config/config.dart';
import 'package:soap_app/pages/home/new/stores/new_list_store.dart';
import 'package:soap_app/pages/home/new/widgets/list.dart';
import 'package:soap_app/store/index.dart';
import 'package:soap_app/widget/app_bar.dart';
import 'package:soap_app/widget/list/load_more_listener.dart';

class NewView extends StatefulWidget {
  const NewView({
    Key? key,
    required this.refreshController,
  }) : super(key: key);

  final RefreshController refreshController;

  @override
  NewViewState createState() {
    return NewViewState();
  }
}

class NewViewState extends State<NewView>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  Map<String, int> query = {
    'page': 1,
    'pageSize': 30,
  };

  String type = 'NEW';

  static List<String> get tabs => <String>['最新', '热门'];

  final RefreshController _loadingRefreshController =
      RefreshController(initialRefresh: false);

  final RefreshController _errorRefreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    newListStore.init();
    super.initState();
    Future<void>.delayed(Duration(milliseconds: screenDelayTimer)).then(
      (dynamic value) async {
        newListStore.watchQuery();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Map<String, Object> variables = {'query': query, 'type': type};
    return FixedAppBarWrapper(
      backdropBar: false,
      appBar: SoapAppBar(
        centerTitle: false,
        border: false,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            FlutterI18n.translate(context, "nav.home"),
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: Observer(builder: (_) {
        return Container(
          color:
              appStore.homeStyle == 2 ? theme.cardColor : theme.backgroundColor,
          child: newListStore.pictureList == null
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
                    await newListStore.fetchMore();
                  },
                  child: NewList(
                    controller: widget.refreshController,
                    onRefresh: () async {
                      await newListStore.refresh();
                      widget.refreshController.refreshCompleted();
                    },
                    loading: (int page) async {
                      await newListStore.fetchMore();
                    },
                  ),
                ),
        );
      }),
    );
  }
}
