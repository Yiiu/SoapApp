import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:soap_app/model/picture.dart';
import 'package:soap_app/pages/new_picture_detail/widgets/bottom.dart';
import 'package:soap_app/pages/new_picture_detail/widgets/handle.dart';
import 'package:soap_app/pages/new_picture_detail/widgets/image.dart';
import 'package:soap_app/pages/new_picture_detail/widgets/top.dart';

import 'package:soap_app/pages/picture_detail/stores/picture_detail_store.dart';
import 'package:soap_app/utils/utils.dart';

class NewPictureDetail extends StatefulWidget {
  const NewPictureDetail({
    Key? key,
    required this.picture,
    this.pictureStyle = PictureStyle.small,
  }) : super(key: key);

  final Picture picture;
  final PictureStyle? pictureStyle;

  @override
  _NewPictureDetailState createState() => _NewPictureDetailState();
}

class _NewPictureDetailState extends State<NewPictureDetail>
    with SingleTickerProviderStateMixin<NewPictureDetail>, RouteAware {
  late AnimationController _controller;

  final PictureDetailPageStore _pageStore = PictureDetailPageStore();

  bool full = false;

  double height = 0;

  @override
  void initState() {
    super.initState();
    _pageStore.init(widget.picture);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    // TODO(pictureDetail): 因为 hero 或者挡住其他的层级，所以等hero动画完成再开始动画.
    _controller.value = 1;
    Timer(const Duration(milliseconds: 250), () {
      _controller.reverse(from: 1);
      _pageStore.watchQuery();
    });
  }

  @override
  void didPop() {
    _controller.forward();
  }

  @override
  void dispose() {
    _pageStore.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) => Stack(
          children: [
            GestureDetector(
              onTap: () {
                if (!full) {
                  _controller.forward();
                } else {
                  _controller.reverse(from: 1);
                }
                setState(() {
                  full = !full;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: double.infinity,
                height: double.infinity,
                margin: EdgeInsets.only(bottom: height),
                color: HexColor.fromHex(widget.picture.color),
                child: Observer(builder: (_) {
                  return NewPictureDetailImage(
                    picture: _pageStore.picture ?? widget.picture,
                    pictureStyle: widget.pictureStyle!,
                  );
                }),
              ),
            ),
            Observer(builder: (_) {
              return NewPictureDetailTop(
                controller: _controller,
                picture: _pageStore.picture ?? widget.picture,
              );
            }),
            Observer(builder: (_) {
              return NewPictureDetailBottom(
                controller: _controller,
                picture: _pageStore.picture ?? widget.picture,
              );
            }),
            Observer(builder: (_) {
              return NewPictureDetailHandle(
                controller: _controller,
                picture: _pageStore.picture!,
                onInfo: () {
                  // print('info');
                  // if (height == 0) {
                  //   setState(() {
                  //     height = 420;
                  //   });
                  // } else {
                  //   setState(() {
                  //     height = 0;
                  //   });
                  // }
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
