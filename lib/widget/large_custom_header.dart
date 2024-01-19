import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:octo_image/octo_image.dart';

import 'app_bar.dart';

class LargeCustomHeader extends SliverPersistentHeaderDelegate {
  LargeCustomHeader({
    this.tabBar,
    this.tabBarHeight = 0,
    required this.title,
    this.actions,
    this.backgroundImage,
    this.backgroundImageMaskColor,
    this.backgroundImageWidget,
    this.titleHeight = 44,
    this.titleMaxLines = 1,
    this.navBarHeight = 75,
    required this.bar,
    this.barCenterTitle = true,
    this.titleTextStyle = const TextStyle(
      fontSize: 30,
      letterSpacing: 0.5,
      fontWeight: FontWeight.bold,
      height: 1.2,
      color: Colors.black,
    ),
  });

  final Widget bar;
  final bool barCenterTitle;
  final List<Widget>? actions;

  final Widget? tabBar;
  final double tabBarHeight;
  final Widget title;

  final double navBarHeight;

  final String? backgroundImage;
  final Widget? backgroundImageWidget;
  final Color? backgroundImageMaskColor;

  final int _fadeDuration = 150;
  final double titleHeight;
  final int titleMaxLines;

  final TextStyle titleTextStyle;

  double makeStickyHeaderBgColor(double shrinkOffset) {
    final double opacity = shrinkOffset / (maxExtent - minExtent);
    return opacity > 1 ? 1 : opacity;
  }

  double makeStickyTitleBgColor(double shrinkOffset) {
    final double opacity = shrinkOffset / (maxExtent - minExtent);
    return opacity > 1 ? 1 : opacity;
  }

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final ThemeData theme = Theme.of(context);
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.vertical(bottom: Radius.circular(35.0)),
        color: theme.cardColor,
      ),
      child: Stack(
        children: <Widget>[
          Container(
            color: theme.cardColor,
            height: double.infinity,
            padding: const EdgeInsets.only(),
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                if (backgroundImageWidget != null &&
                    backgroundImage == null) ...[
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: backgroundImageWidget!,
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      color: backgroundImageMaskColor ??
                          const Color.fromRGBO(0, 0, 0, 0.65),
                    ),
                  ),
                ],
                if (backgroundImageWidget == null &&
                    backgroundImage != null) ...[
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: 1,
                    child: OctoImage(
                      image: ExtendedImage.network(backgroundImage!).image,
                      fit: BoxFit.cover,
                      // errorBuilder: OctoError.blurHash(
                      //   'L7KAmKP900~p?G_39F%L.T^lR50K',
                      //   iconColor: Colors.white,
                      // ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: 1,
                    child: Container(
                      color: backgroundImageMaskColor ??
                          const Color.fromRGBO(0, 0, 0, 0.65),
                    ),
                  ),
                ],
                Positioned(
                  bottom: tabBarHeight,
                  left: 0,
                  right: 0,
                  // top: navBarHeight,
                  child: AnimatedOpacity(
                    opacity: 1 - makeStickyHeaderBgColor(shrinkOffset),
                    duration: Duration(milliseconds: _fadeDuration),
                    child: Container(
                      child: title,
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  child: SoapAppBar(
                    height: navBarHeight,
                    // backdrop: shrink,
                    elevation: 0,
                    brightness: Brightness.dark,
                    automaticallyImplyLeading: true,
                    textColor: Colors.white,
                    backgroundColor: Colors.transparent,
                    centerTitle: barCenterTitle,
                    title: AnimatedOpacity(
                      opacity: makeStickyHeaderBgColor(shrinkOffset),
                      duration: Duration(milliseconds: _fadeDuration),
                      child: bar,
                    ),
                    actions: actions,
                  ),
                ),
              ],
            ),
          ),
          if (tabBar != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SizedBox(
                height: tabBarHeight,
                // color: theme.cardColor,
                child: tabBar,
              ),
            ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => navBarHeight + titleHeight + tabBarHeight;

  @override
  double get minExtent => navBarHeight + tabBarHeight;

  // @override
  // FloatingHeaderSnapConfiguration get snapConfiguration => FloatingHeaderSnapConfiguration() ;

  @override
  OverScrollHeaderStretchConfiguration get stretchConfiguration =>
      OverScrollHeaderStretchConfiguration(
        stretchTriggerOffset: maxExtent,
        // ignore: missing_return
        onStretchTrigger: () async {},
      );

  double get maxShrinkOffset => maxExtent - minExtent;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    //TODO: implement specific rebuild checks
    return true;
  }
}
