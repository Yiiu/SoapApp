import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:soap_app/config/theme.dart';

class SoapListWidget extends StatelessWidget {
  const SoapListWidget({
    Key? key,
    this.onRefresh,
    this.notScrollView = false,
    required this.controller,
    required this.child,
  }) : super(key: key);

  final RefreshController controller;
  final VoidCallback? onRefresh;
  final Widget child;
  final bool notScrollView;

  @override
  Widget build(BuildContext context) {
    if (notScrollView) {
      return SmartRefresher(
        enablePullUp: false,
        enablePullDown: onRefresh != null,
        controller: controller,
        physics: const BouncingScrollPhysics(),
        onRefresh: onRefresh,
        child: child,
      );
    }
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
        enablePullUp: false,
        enablePullDown: onRefresh != null,
        controller: controller,
        physics: const BouncingScrollPhysics(),
        onRefresh: onRefresh,
        child: child,
      ),
    );
  }
}
