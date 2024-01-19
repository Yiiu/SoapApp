import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../config/config.dart';
import '../../../widget/app_bar.dart';
import 'new_list.dart';
import 'stores/new_list_store.dart';

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
  late TabController tabController;

  @override
  bool get wantKeepAlive => true;

  Map<String, int> query = {
    'page': 1,
    'pageSize': 30,
  };

  int tabIndex = 0;

  String type = 'NEW';

  static List<String> get tabs => <String>['最新', '热门'];

  @override
  void initState() {
    newListStore.init();
    super.initState();
    tabController = TabController(
      length: 1,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return DefaultTabController(
      length: 1,
      child: FixedAppBarWrapper(
        appBar: SoapAppBar(
          centerTitle: false,
          elevation: 0,
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              FlutterI18n.translate(context, 'nav.home'),
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          controller: tabController,
          children: <Widget>[
            NewListPageView(
              store: newListStore,
              refreshController: widget.refreshController,
            ),
          ],
        ),
      ),
    );
  }
}
