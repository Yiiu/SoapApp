// ignore_for_file: unnecessary_brace_in_string_interps

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:octo_image/octo_image.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:soap_app/config/config.dart';
import 'package:soap_app/widget/app_bar.dart';
import 'package:soap_app/widget/custom_dismissible.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

class HeroPhotoGallery extends StatefulWidget {
  const HeroPhotoGallery({
    Key? key,
    required this.url,
    this.heroLabel,
    this.radius = const Radius.circular(6),
  }) : super(key: key);

  final String url;

  final String? heroLabel;

  final Radius radius;

  @override
  _HeroPhotoGalleryState createState() => _HeroPhotoGalleryState();
}

class _HeroPhotoGalleryState extends State<HeroPhotoGallery>
    with SingleTickerProviderStateMixin<HeroPhotoGallery>, RouteAware {
  late AnimationController _controller;
  late Animation<Offset> _topAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _topAnimation = Tween(
      begin: Offset.zero,
      end: const Offset(0, -1),
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.reverse(from: 1);
  }

  @override
  void didPop() {
    _controller.forward();
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
      begin: BorderRadius.all(widget.radius),
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
    if (widget.heroLabel == null) {
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
        tag: widget.heroLabel!,
        child: child,
      );
    }
  }

  Widget _topBuilder() {
    return Positioned(
      child: SlideTransition(
        position: _topAnimation,
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black45,
                Colors.transparent,
              ],
            ),
          ),
          child: SoapAppBar(
            backgroundColor: Colors.transparent,
            textColor: Colors.white,
            brightness: Brightness.dark,
            actions: <Widget>[
              TouchableOpacity(
                activeOpacity: activeOpacity,
                onTap: () {
                  Navigator.of(context).maybePop();
                  // Navigator.pushNamed(context, RouteName.setting);
                },
                child: const Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: Icon(
                    FeatherIcons.x,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bottomBuilder() {
    return Positioned(
      bottom: 0,
      child: Material(
        type: MaterialType.transparency,
        child: TouchableOpacity(
          child: Container(
            child: Text('test'),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) => Stack(
        children: [
          CustomDismissible(
            onDismissed: () => Navigator.of(context).maybePop(),
            child: PhotoViewGallery.builder(
              itemCount: 1,
              pageController: PageController(initialPage: 0),
              backgroundDecoration:
                  const BoxDecoration(color: Colors.transparent),
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
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).maybePop();
                          },
                        ),
                        Center(
                          child: OctoImage(
                            placeholderBuilder:
                                OctoPlaceholder.circularProgressIndicator(),
                            image: ExtendedImage.network(
                              widget.url,
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
            ),
          ),
          _topBuilder(),
          // _bottomBuilder(),
        ],
      ),
    );
  }
}
