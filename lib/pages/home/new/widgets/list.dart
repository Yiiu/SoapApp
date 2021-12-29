import 'package:extended_list/extended_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

import '../../../../store/index.dart';
import '../../../../utils/utils.dart';
import '../../../../widget/widgets.dart';
import '../stores/new_list_store.dart';

class NewList extends StatelessWidget {
  const NewList({
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

  Widget _listBuilder(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    if (appStore.homeStyle == 1) {
      return ExtendedListView.builder(
        extendedListDelegate: const ExtendedListDelegate(),
        itemBuilder: (BuildContext _, int i) => Container(
          color: theme.cardColor,
          margin: const EdgeInsets.only(bottom: 12),
          child: Observer(builder: (_) {
            return PictureItem(
              doubleLike: true,
              heroLabel: 'new-picture-detail',
              picture: newListStore.pictureList![i],
              pictureStyle: PictureStyle.mediumLarge,
              gallery: true,
              pictureType: pictureItemType.single,
            );
          }),
        ),
        itemCount: newListStore.pictureList!.length,
      );
    } else {
      return WaterfallFlow.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: newListStore.pictureList!.length,
        itemBuilder: (_, int i) => Observer(builder: (BuildContext context) {
          return PictureItem(
            heroLabel: 'new-picture-detail',
            crossAxisSpacing: 0,
            mainAxisSpacing: 8,
            picture: newListStore.pictureList![i],
            header: false,
            fall: true,
            gallery: true,
            pictureStyle: PictureStyle.thumb,
          );
        }),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      physics: const BouncingScrollPhysics(),
      controller: controller,
      onRefresh: onRefresh,
      onLoading: () async {},
      child: _listBuilder(context),
    );
  }
}
