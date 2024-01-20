import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:octo_image/octo_image.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../../../model/picture.dart';
import '../../../utils/utils.dart';

typedef DoubleClickAnimationListener = void Function();

class NewPictureDetailImage extends StatefulWidget {
  const NewPictureDetailImage({
    Key? key,
    required this.picture,
    required this.pictureStyle,
    this.heroLabel,
    this.photoViewListen,
  }) : super(key: key);

  final PictureStyle pictureStyle;

  final Picture picture;

  final String? heroLabel;

  final void Function(PhotoViewControllerValue)? photoViewListen;

  @override
  _NewPictureDetailImageState createState() => _NewPictureDetailImageState();
}

class _NewPictureDetailImageState extends State<NewPictureDetailImage>
    with TickerProviderStateMixin {
  GlobalKey<ExtendedImageSlidePageState> slidePagekey =
      GlobalKey<ExtendedImageSlidePageState>();

  List<double> doubleTapScales = <double>[1.0, 2.0];

  final PhotoViewController _photoController = PhotoViewController();

  @override
  void initState() {
    _photoController.outputStateStream.listen(widget.photoViewListen);
    super.initState();
    precache();
  }

  Future<void> precache() async {
    await precacheImage(
      ExtendedNetworkImageProvider(
        getPictureUrl(
          key: widget.picture.key,
        ),
      ),
      context,
      onError: (Object o, StackTrace? err) {
        print(err);
      },
    );
    // print('ok');
  }

  Widget _heroBuilder(
    int index,
    Widget child,
  ) {
    if (widget.heroLabel != null) {
      return Hero(
        flightShuttleBuilder: (
          _,
          Animation<double> animation,
          HeroFlightDirection flightDirection,
          BuildContext fromHeroContext,
          BuildContext toHeroContext,
        ) =>
            _flightShuttleBuilder(
          index,
          animation,
          flightDirection,
          fromHeroContext,
          toHeroContext,
        ),
        tag: '${widget.heroLabel}-${widget.picture.id}',
        child: child,
      );
    }
    return child;
  }

  Widget _flightShuttleBuilder(
    int index,
    Animation<double> animation,
    HeroFlightDirection flightDirection,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  ) {
    final Hero hero = flightDirection == HeroFlightDirection.push
        ? fromHeroContext.widget as Hero
        : toHeroContext.widget as Hero;

    final BorderRadiusTween tween = BorderRadiusTween(
      begin: const BorderRadius.all(Radius.circular(8)),
      end: BorderRadius.zero,
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (_, __) => ClipRRect(
        clipBehavior: Clip.hardEdge,
        // borderRadius: tween.evaluate(animation),
        child: hero.child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PhotoViewGallery.builder(
      itemCount: 1,
      pageController: PageController(),
      backgroundDecoration: const BoxDecoration(color: Colors.transparent),
      scrollPhysics: const BouncingScrollPhysics(),
      builder: (BuildContext context, int index) {
        return PhotoViewGalleryPageOptions.customChild(
          controller: _photoController,
          initialScale: PhotoViewComputedScale.covered,
          minScale: PhotoViewComputedScale.contained,
          // tightMode: true,
          maxScale: PhotoViewComputedScale.covered * 3,
          gestureDetectorBehavior: HitTestBehavior.translucent,
          child: Container(
            color: Colors.transparent,
            child: Stack(
              children: <Widget>[
                Center(
                  // 防止 hero 动画的时候抖动
                  child: AspectRatio(
                    aspectRatio: widget.picture.width / widget.picture.height,
                    child: _heroBuilder(
                      index,
                      OctoImage(
                        fit: BoxFit.contain,
                        fadeInDuration: Duration.zero,
                        fadeOutDuration: Duration.zero,
                        image: ExtendedImage.network(
                          getPictureUrl(
                            key: widget.picture.key,
                          ),
                        ).image,
                        placeholderBuilder: (BuildContext context) {
                          return OctoImage(
                            fadeInDuration: Duration.zero,
                            fadeOutDuration: Duration.zero,
                            fit: BoxFit.contain,
                            image: ExtendedImage.network(
                              getPictureUrl(
                                key: widget.picture.key,
                                style: widget.pictureStyle,
                              ),
                            ).image,
                            placeholderBuilder: (BuildContext context) {
                              return AspectRatio(
                                aspectRatio: widget.picture.width /
                                    widget.picture.height,
                                child: Container(
                                  color: HexColor.fromHex(widget.picture.color),
                                ),
                              );
                            },
                          );
                        },
                      ),
                      // ExtendedImage.network(
                      //   getPictureUrl(
                      //     key: widget.picture.key,
                      //     style: widget.pictureStyle,
                      //   ),
                      //   fit: BoxFit.contain,
                      //   loadStateChanged: (ExtendedImageState state) {
                      //     switch (state.extendedImageLoadState) {
                      //       case LoadState.loading:
                      //         return AspectRatio(
                      //           aspectRatio:
                      //               widget.picture.width / widget.picture.height,
                      //           child: Container(
                      //             color: HexColor.fromHex(widget.picture.color),
                      //           ),
                      //         );
                      //       case LoadState.completed:
                      //       // return _heroBuilder(
                      //       //   index,
                      //       //   ExtendedImage.network(
                      //       //     getPictureUrl(
                      //       //       key: widget.picture.key,
                      //       //     ),
                      //       //     fit: BoxFit.contain,
                      //       //   ),
                      //       // );
                      //       case LoadState.failed:
                      //         SoapToast.error('图片加载失败！');
                      //         return AspectRatio(
                      //           aspectRatio:
                      //               widget.picture.width / widget.picture.height,
                      //           child: _heroBuilder(
                      //             index,
                      //             Container(
                      //               color: HexColor.fromHex(widget.picture.color),
                      //             ),
                      //           ),
                      //         );
                      //     }
                      //   },
                      // ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
