import 'dart:async';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../model/picture.dart';
import '../../utils/utils.dart';
import '../home/new/stores/new_list_store.dart';
import 'new_picture_detail.dart';

class KeepAlive extends StatefulWidget {
  const KeepAlive({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  _KeepAliveState createState() => _KeepAliveState();
}

class _KeepAliveState extends State<KeepAlive>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => false;
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class PictureDetail extends StatefulWidget {
  const PictureDetail({
    Key? key,
    required this.store,
    required this.initialPicture,
    this.pictureStyle = PictureStyle.small,
  }) : super(key: key);

  final ListStoreBase store;
  final PictureStyle? pictureStyle;
  final Picture initialPicture;

  @override
  PictureDetailState createState() => PictureDetailState();
}

class PictureDetailState extends State<PictureDetail>
    with TickerProviderStateMixin {
  late PageController controller;
  late RefreshController _refreshController;

  int initialIndex = 0;

  bool canScroll = true;

  late int currentIndex;

  @override
  void initState() {
    _refreshController = RefreshController();
    initialIndex = widget.store.pictureList!.indexWhere(
        (Picture picture) => picture.id == widget.initialPicture.id);
    currentIndex = initialIndex;
    controller = PageController(initialPage: initialIndex);
    super.initState();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) {
          if (notification.depth == 0 &&
              notification is ScrollUpdateNotification) {
            final PageMetrics metrics = notification.metrics as PageMetrics;
            final int currentPage = metrics.page!.round();
            if (currentPage != currentIndex) {
              setState(() {
                currentIndex = currentPage;
              });
              // Timer(const Duration(milliseconds: 400), () {
              //   setState(() {});
              // });
            }
          }
          return false;
        },
        child: SmartRefresher(
          enablePullUp: true,
          controller: _refreshController,
          onRefresh: () async {
            print('onRefresh');
            await Future<void>.delayed(const Duration(milliseconds: 4000));
            if (mounted) setState(() {});
            _refreshController.refreshFailed();
          },
          child: CustomScrollView(
            physics: canScroll
                ? const PageScrollPhysics(parent: BouncingScrollPhysics())
                : const NeverScrollableScrollPhysics(),
            controller: controller,
            slivers: <Widget>[
              SliverFillViewport(
                delegate: SliverChildListDelegate(
                  widget.store.pictureList!.map((Picture picture) {
                    final int idx = widget.store.pictureList!.indexOf(picture);
                    if (currentIndex + 2 <= idx || currentIndex - 2 >= idx) {
                      return Container();
                    }
                    return NewPictureDetail(
                      key: Key(widget.store.pictureList![idx].id.toString()),
                      picture: widget.store.pictureList![idx],
                      current: currentIndex == idx,
                      heroLabel:
                          currentIndex == idx ? 'new-picture-detail' : null,
                      initialAnimation: false,
                      pictureStyle: widget.pictureStyle,
                      photoViewListen: (PhotoViewControllerValue event) {
                        if (event.scale == 1.0 && !canScroll) {
                          setState(() {
                            canScroll = true;
                          });
                        }
                        if (event.scale != 1.0 && canScroll) {
                          setState(() {
                            canScroll = false;
                          });
                        }
                      },
                    );
                  }).toList(),
                ),
              )
            ],
          ),
          onLoading: () async {
            print('onload');
            await Future<void>.delayed(const Duration(milliseconds: 2000));
            if (mounted) setState(() {});
            _refreshController.loadFailed();
          },
        ),
      ),
    );
    // return PageView.builder(
    //   itemCount: widget.store.count,
    //   controller: controller,
    //   physics: const BouncingScrollPhysics(),
    //   scrollDirection: Axis.vertical,
    //   allowImplicitScrolling: true,
    //   onPageChanged: (int index) {
    //     setState(() {
    //       currentIndex = index;
    //     });
    //   },
    //   itemBuilder: (BuildContext context, int index) {
    //     return KeepAlive(
    //       child: NewPictureDetail(
    //         key: Key(widget.store.pictureList![index].id.toString()),
    //         picture: widget.store.pictureList![index],
    //         heroLabel: currentIndex == index ? 'new-picture-detail' : null,
    //         initialAnimation: false,
    //         pictureStyle: widget.pictureStyle,
    //       ),
    //     );
    //   },
    // );
    // TikTokStyleFullPageScroller(
    //   contentSize: widget.store.count,
    //   swipePositionThreshold: 0.1,
    //   swipeVelocityThreshold: 800,
    //   animationDuration: const Duration(milliseconds: 200),
    //   builder: (BuildContext context, int index) {
    //     return NewPictureDetail(
    //       key: Key(widget.store.pictureList![index].id.toString()),
    //       picture: widget.store.pictureList![index],
    //       heroLabel: 'new-picture-detail',
    //     );
    //   },
    // );
  }
}
