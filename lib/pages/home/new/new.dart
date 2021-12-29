import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
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
    Future<void>.delayed(Duration(milliseconds: screenDelayTimer)).then(
      (dynamic value) async {
        newListStore.watchQuery();
      },
    );
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
          // TabBar(
          //   indicatorColor: Colors.green,
          //   controller: tabController,
          //   onTap: (index) {
          //     setState(() {
          //       tabIndex = index;
          //     });
          //   },
          //   tabs: [
          //     Tab(
          //       child: Text(
          //         '最新',
          //         style: TextStyle(
          //           fontSize: tabIndex == 0 ? 20 : 16,
          //           fontWeight:
          //               tabIndex == 0 ? FontWeight.w500 : FontWeight.w400,
          //           fontFamily: '江城圆体',
          //         ),
          //       ),
          //     ),
          //     // Tab(
          //     //   child: Text(
          //     //     '热门',
          //     //     style: TextStyle(
          //     //       fontSize: tabIndex == 1 ? 20 : 16,
          //     //       fontWeight:
          //     //           tabIndex == 1 ? FontWeight.w500 : FontWeight.w400,
          //     //       fontFamily: '江城圆体',
          //     //     ),
          //     //   ),
          //     // ),
          //   ],
          //   labelStyle: theme.textTheme.bodyText2!.copyWith(),
          //   unselectedLabelStyle: theme.textTheme.bodyText2!.copyWith(),
          //   labelColor: theme.textTheme.bodyText2!.color,
          //   indicatorPadding: const EdgeInsets.only(left: 10, right: 10),
          //   indicatorSize: TabBarIndicatorSize.label,
          //   indicator: const BoxDecoration(),
          //   isScrollable: true,
          //   unselectedLabelColor:
          //       theme.textTheme.bodyText2!.color!.withOpacity(.6),
          // ),
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
