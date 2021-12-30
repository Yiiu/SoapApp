import 'package:flutter/material.dart';
import 'package:soap_app/model/picture.dart';

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

class PictureDetailState extends State<PictureDetail> {
  late PageController controller;

  int initialIndex = 0;

  late int currentIndex;

  @override
  void initState() {
    initialIndex = widget.store.pictureList!.indexWhere(
        (Picture picture) => picture.id == widget.initialPicture.id);
    currentIndex = initialIndex;
    controller = PageController(initialPage: initialIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: widget.store.count,
      controller: controller,
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      allowImplicitScrolling: true,
      onPageChanged: (int index) {
        setState(() {
          currentIndex = index;
        });
      },
      itemBuilder: (BuildContext context, int index) {
        return KeepAlive(
          child: NewPictureDetail(
            key: Key(widget.store.pictureList![index].id.toString()),
            picture: widget.store.pictureList![index],
            heroLabel: currentIndex == index ? 'new-picture-detail' : null,
            initialAnimation: false,
            pictureStyle: widget.pictureStyle,
          ),
        );
      },
    );
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
