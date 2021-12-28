import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:octo_image/octo_image.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:soap_app/model/picture.dart';
import 'package:soap_app/utils/utils.dart';

typedef DoubleClickAnimationListener = void Function();

class NewPictureDetailImage extends StatefulWidget {
  const NewPictureDetailImage({
    Key? key,
    required this.picture,
    required this.pictureStyle,
  }) : super(key: key);

  final PictureStyle pictureStyle;

  final Picture picture;

  @override
  _NewPictureDetailImageState createState() => _NewPictureDetailImageState();
}

class _NewPictureDetailImageState extends State<NewPictureDetailImage>
    with TickerProviderStateMixin {
  GlobalKey<ExtendedImageSlidePageState> slidePagekey =
      GlobalKey<ExtendedImageSlidePageState>();

  List<double> doubleTapScales = <double>[1.0, 2.0];

  @override
  void initState() {
    super.initState();
  }

  Widget _heroBuilder(
    int index,
    Widget child,
  ) {
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
      tag: 'new-picture-detail-${widget.picture.id}',
      child: child,
    );
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
        borderRadius: tween.evaluate(animation),
        child: hero.child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PhotoViewGallery.builder(
      itemCount: 1,
      pageController: PageController(initialPage: 0),
      backgroundDecoration: const BoxDecoration(color: Colors.transparent),
      scrollPhysics: const BouncingScrollPhysics(),
      builder: (BuildContext context, int index) {
        return PhotoViewGalleryPageOptions.customChild(
          initialScale: PhotoViewComputedScale.covered,
          minScale: PhotoViewComputedScale.contained,
          // tightMode: true,
          maxScale: PhotoViewComputedScale.covered * 3,
          gestureDetectorBehavior: HitTestBehavior.opaque,
          child: Container(
            color: Colors.transparent,
            child: Stack(
              children: [
                Center(
                  child: ExtendedImage.network(
                    getPictureUrl(
                      key: widget.picture.key,
                      style: PictureStyle.regular,
                    ),
                    fit: BoxFit.contain,
                    cache: true,
                    loadStateChanged: (ExtendedImageState state) {
                      switch (state.extendedImageLoadState) {
                        case LoadState.loading:
                          return Center(
                            child: AspectRatio(
                              aspectRatio:
                                  widget.picture.width / widget.picture.height,
                              child: _heroBuilder(
                                index,
                                OctoImage(
                                  fit: BoxFit.contain,
                                  image: ExtendedImage.network(
                                    getPictureUrl(
                                      key: widget.picture.key,
                                      style: widget.pictureStyle,
                                    ),
                                    cache: true,
                                  ).image,
                                  placeholderBuilder: (BuildContext context) {
                                    return Container(
                                      color: HexColor.fromHex(
                                          widget.picture.color),
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        case LoadState.completed:
                          return _heroBuilder(
                            index,
                            ExtendedImage.network(
                              getPictureUrl(
                                key: widget.picture.key,
                                style: PictureStyle.regular,
                              ),
                              fit: BoxFit.contain,
                              cache: true,
                            ),
                          );
                        case LoadState.failed:
                          // TODO: Handle this case.
                          break;
                      }
                    },
                  ),
                  // child: OctoImage(
                  //   placeholderBuilder: (BuildContext context) {
                  //     return _heroBuilder(
                  //       index,
                  //       AspectRatio(
                  //         aspectRatio:
                  //             widget.picture.width / widget.picture.height,
                  //         child: ExtendedImage.network(
                  //           widget.picture.pictureUrl(
                  //             style: widget.pictureStyle,
                  //           ),
                  //         ),
                  //       ),
                  //     );
                  //   },
                  //   image: ExtendedImage.network(
                  //     widget.picture.pictureUrl(
                  //       style: PictureStyle.regular,
                  //     ),
                  //   ).image,
                  //   fit: BoxFit.cover,
                  //   imageBuilder: (_, w) {
                  //     return _heroBuilder(index, w);
                  //   },
                  // ),
                ),
              ],
            ),
          ),
          // _heroBuilder(
          //   index,
          //   ExtendedImage.network(
          //     getPictureUrl(
          //       key: widget.picture.key,
          //       style: PictureStyle.full,
          //     ),
          //     cache: true,
          //     loadStateChanged: (ExtendedImageState state) {
          //       switch (state.extendedImageLoadState) {
          //         case LoadState.loading:
          //           // TODO: 第一次获取会闪烁，为了更平滑加上一个placeholder
          //           return Center(
          //             child: AspectRatio(
          //               aspectRatio:
          //                   widget.picture.width / widget.picture.height,
          //               child: OctoImage(
          //                 fit: BoxFit.contain,
          //                 image: ExtendedImage.network(
          //                   getPictureUrl(
          //                     key: widget.picture.key,
          //                     style: widget.pictureStyle,
          //                   ),
          //                   cache: true,
          //                 ).image,
          //                 placeholderBuilder: (BuildContext context) {
          //                   return Container(
          //                     color: HexColor.fromHex(widget.picture.color),
          //                   );
          //                 },
          //               ),
          //             ),
          //           );
          //         case LoadState.completed:
          //           // TODO: Handle this case.
          //           break;
          //         case LoadState.failed:
          //           return ExtendedImage.network(
          //             getPictureUrl(
          //               key: widget.picture.key,
          //               style: widget.pictureStyle,
          //             ),
          //             cache: true,
          //           );
          //           break;
          //       }
          //     },
          //   ),
          // ),
        );
      },
    );
    // return ExtendedImageSlidePage(
    //   key: slidePagekey,
    //   child: HeroWidget(
    //     tag: 'new-picture-detail-${widget.picture.id}',
    //     slideType: SlideType.onlyImage,
    //     slidePagekey: slidePagekey,
    //     child: ExtendedImage.network(
    //       getPictureUrl(
    //         key: widget.picture.key,
    //         style: PictureStyle.regular,
    //       ),
    //       fit: BoxFit.contain,
    //       mode: ExtendedImageMode.gesture,
    //       imageCacheName: 'CropImage',
    //       initGestureConfigHandler: (ExtendedImageState state) {
    //         double? initialScale = 1.0;
    //         // if (state.extendedImageInfo != null) {
    //         //   initialScale = initScale(
    //         //       size: size,
    //         //       initialScale: initialScale,
    //         //       imageSize: Size(
    //         //           state.extendedImageInfo!.image.width.toDouble(),
    //         //           state.extendedImageInfo!.image.height
    //         //               .toDouble()));
    //         // }
    //         return GestureConfig(
    //           minScale: 1,
    //           animationMinScale: 0.7,
    //           maxScale: 3.0,
    //           animationMaxScale: 3.5,
    //           speed: 1.0,
    //           inertialSpeed: 100.0,
    //           initialScale: 1.0,
    //           inPageView: true,
    //           initialAlignment: InitialAlignment.center,
    //         );
    //       },
    //       onDoubleTap: (ExtendedImageGestureState state) {
    //         ///you can use define pointerDownPosition as you can,
    //         ///default value is double tap pointer down postion.
    //         final Offset? pointerDownPosition = state.pointerDownPosition;
    //         final double? begin = state.gestureDetails!.totalScale;
    //         double end;

    //         //remove old
    //         _doubleClickAnimation
    //             ?.removeListener(_doubleClickAnimationListener);

    //         //stop pre
    //         _doubleClickAnimationController.stop();

    //         //reset to use
    //         _doubleClickAnimationController.reset();

    //         if (begin == doubleTapScales[0]) {
    //           end = doubleTapScales[1];
    //         } else {
    //           end = doubleTapScales[0];
    //         }

    //         _doubleClickAnimationListener = () {
    //           //print(_animation.value);
    //           state.handleDoubleTap(
    //               scale: _doubleClickAnimation!.value,
    //               doubleTapPosition: pointerDownPosition);
    //         };
    //         _doubleClickAnimation = _doubleClickAnimationController
    //             .drive(Tween<double>(begin: begin, end: end));

    //         _doubleClickAnimation!.addListener(_doubleClickAnimationListener);

    //         _doubleClickAnimationController.forward();
    //       },
    //     ),
    //   ),
    //   slideAxis: SlideAxis.vertical,
    //   slideType: SlideType.onlyImage,
    // );
  }
}
