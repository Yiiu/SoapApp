import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:octo_image/octo_image.dart';

import 'app_bar.dart';

class LargeCustomHeader extends SliverPersistentHeaderDelegate {
  LargeCustomHeader({
    required this.tabBar,
    this.tabBarHeight = 0,
    required this.title,
    required this.backgroundImage,
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
  }) {}

  final Widget bar;
  final bool barCenterTitle;

  final Widget tabBar;
  final double tabBarHeight;
  final Widget title;

  final double navBarHeight;

  final String backgroundImage;

  final int _fadeDuration = 250;
  final double titleHeight;
  final int titleMaxLines;

  final TextStyle titleTextStyle;

  double makeStickyHeaderBgColor(double shrinkOffset) {
    double opacity = shrinkOffset / (this.maxExtent - this.minExtent);
    return opacity > 1 ? 1 : opacity;
  }

  double makeStickyTitleBgColor(double shrinkOffset) {
    double opacity = shrinkOffset / (this.maxExtent - this.minExtent);
    return opacity > 1 ? 1 : opacity;
  }

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    bool shrink = shrinkOffset >= titleHeight - 30;
    final ThemeData theme = Theme.of(context);
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.vertical(bottom: Radius.circular(35.0)),
        color: theme.cardColor,
      ),
      child: Stack(
        children: [
          Container(
            color: theme.cardColor,
            height: double.infinity,
            padding: EdgeInsets.only(bottom: tabBarHeight),
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                if (this.backgroundImage != null) ...[
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: OctoImage(
                      image: ExtendedImage.network(this.backgroundImage).image,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      color: const Color.fromRGBO(0, 0, 0, 0.65),
                    ),
                  ),
                ],
                Positioned(
                  bottom: 0,
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
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: tabBarHeight + 1,
              color: theme.cardColor,
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
