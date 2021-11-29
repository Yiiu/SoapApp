// ignore_for_file: unnecessary_brace_in_string_interps

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:octo_image/octo_image.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class HeroPhotoGallery extends StatelessWidget {
  const HeroPhotoGallery({
    Key? key,
    required this.url,
    required this.id,
    this.heroLabel,
  }) : super(key: key);

  final String url;

  final int id;

  final String? heroLabel;

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
      begin: const BorderRadius.all(Radius.circular(6)),
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

  Widget _heroBuilder(
    int index,
    Widget child,
  ) {
    if (heroLabel == null) {
      return child;
    } else {
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
        tag: 'picture-${heroLabel}-${id}',
        child: child,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PhotoViewGallery.builder(
      itemCount: 1,
      pageController: PageController(initialPage: 0),
      backgroundDecoration: const BoxDecoration(color: Colors.transparent),
      builder: (BuildContext context, int index) {
        return PhotoViewGalleryPageOptions.customChild(
          // heroAttributes: PhotoViewHeroAttributes(
          //   tag:
          //       'picture-${widget.heroLabel}-${_pageStore.picture!.id}',
          // ),
          initialScale: PhotoViewComputedScale.covered,
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered * 3,
          gestureDetectorBehavior: HitTestBehavior.opaque,
          child: Container(
            color: Colors.transparent,
            child: Stack(
              children: [
                GestureDetector(
                  onTap: Navigator.of(context).pop,
                ),
                Center(
                  // child: _heroBuilder(
                  //   index,
                  //   ExtendedImage.network(
                  //     url,
                  //   ),
                  // ),
                  child: OctoImage(
                    placeholderBuilder: (BuildContext context) {
                      return _heroBuilder(
                        index,
                        OctoImage(
                          image: ExtendedImage.network(
                            url,
                          ).image,
                          errorBuilder: OctoError.icon(),
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                    image: ExtendedImage.network(
                      url,
                    ).image,
                    fit: BoxFit.cover,
                    imageBuilder: (_, w) {
                      return _heroBuilder(index, w);
                    },
                    errorBuilder: OctoError.icon(),
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
