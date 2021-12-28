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
                    ),
                    fit: BoxFit.contain,
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
                              ),
                              fit: BoxFit.contain,
                            ),
                          );
                        case LoadState.failed:
                          // TODO: Handle this case.
                          break;
                      }
                    },
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
