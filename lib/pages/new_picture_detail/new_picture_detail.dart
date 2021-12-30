import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:photo_view/photo_view.dart';
import 'package:tiktoklikescroller/tiktoklikescroller.dart';

import '../../model/picture.dart';
import '../../utils/utils.dart';
import '../picture_detail/stores/picture_detail_store.dart';
import 'widgets/bottom.dart';
import 'widgets/handle.dart';
import 'widgets/image.dart';
import 'widgets/top.dart';

class NewPictureDetail extends StatefulWidget {
  const NewPictureDetail({
    Key? key,
    required this.picture,
    this.current,
    this.initialAnimation = true,
    this.heroLabel,
    this.pictureStyle = PictureStyle.small,
    this.photoViewListen,
    // this.
  }) : super(key: key);

  final Picture picture;
  final PictureStyle? pictureStyle;
  final String? heroLabel;
  final bool initialAnimation;
  final bool? current;
  final void Function(PhotoViewControllerValue)? photoViewListen;

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
    _pageStore.init(widget.picture);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _pageStore.watchQuery();
    // if (widget.current != null && widget.current!) {
    // }
    if (widget.initialAnimation) {
      // TODO(pictureDetail): 因为 hero 或者挡住其他的层级，所以等hero动画完成再开始动画.
      _controller.value = 1;
      Timer(const Duration(milliseconds: 250), () {
        _controller.reverse(from: 1);
      });
    }
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (widget.current != null && widget.current!) {
      print('initState');
      print(widget.picture.title);
    }
    super.didChangeDependencies();
  }

  @override
  void didPop() {
    print('didPop');
    _controller.forward();
  }

  @override
  void dispose() {
    print('dispose');
    _pageStore.close();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) => Stack(
          children: <Widget>[
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
                    photoViewListen: widget.photoViewListen,
                    pictureStyle: widget.pictureStyle!,
                    heroLabel: widget.heroLabel,
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
