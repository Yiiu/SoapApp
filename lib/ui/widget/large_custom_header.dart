import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_fade/image_fade.dart';
import 'package:soap_app/ui/widget/app_bar.dart';
import 'package:soap_app/ui/widget/transparent_image.dart';

class LargeCustomHeader extends SliverPersistentHeaderDelegate {
  LargeCustomHeader({
    this.tabBar,
    this.tabBarHeight = 0,
    this.title,
    this.backgroundImage,
    this.titleHeight = 44,
    this.titleMaxLines = 1,
    this.navBarHeight = 75,
    @required this.bar,
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

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    bool shrink = shrinkOffset >= (titleHeight / 3) + 40;
    return Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          // borderRadius: BorderRadius.vertical(bottom: Radius.circular(35.0)),
          color: Colors.white,
        ),
        child: Flex(
          direction: Axis.vertical,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 1,
              child: Container(
                height: double.infinity,
                color: Colors.red,
                child: Stack(
                  fit: StackFit.loose,
                  children: <Widget>[
                    if (this.backgroundImage != null) ...[
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: ImageFade(
                          placeholder: Image.memory(
                            transparentImage,
                            fit: BoxFit.cover,
                          ),
                          image: CachedNetworkImageProvider(backgroundImage),
                          fit: BoxFit.cover,
                          alignment: Alignment.center,
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          color: Color.fromRGBO(0, 0, 0, 0.65),
                        ),
                      ),
                    ],
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      // top: navBarHeight,
                      child: Container(
                        child: title,
                      ),
                    ),
                    SoapAppBar(
                      elevation: 0,
                      brightness: shrink ? Brightness.light : Brightness.dark,
                      automaticallyImplyLeading: true,
                      textColor: shrink ? null : Colors.white,
                      backgroundColor:
                          shrink ? Colors.white : Colors.transparent,
                      centerTitle: barCenterTitle,
                      title: AnimatedOpacity(
                        opacity: shrink ? 1 : 0,
                        duration: Duration(milliseconds: _fadeDuration),
                        child: bar,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: tabBarHeight,
              child: tabBar,
            ),
          ],
        ));
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
        onStretchTrigger: () {},
      );

  double get maxShrinkOffset => maxExtent - minExtent;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    //TODO: implement specific rebuild checks
    return true;
  }
}
