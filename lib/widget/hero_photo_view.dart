import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class HeroPhotoView extends StatefulWidget {
  HeroPhotoView({
    required this.image,
    required this.id,
    this.heroLabel,
  });

  final String image;
  final int id;
  String? heroLabel;

  @override
  _HeroPhotoViewState createState() => _HeroPhotoViewState();
}

class _HeroPhotoViewState extends State<HeroPhotoView>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Animation<double>? _animation;
  void Function()? animationListener;
  List<double> doubleTapScales = <double>[1, 3.0];
  List<double> scales = <double>[1, 3.0];

  GlobalKey<ExtendedImageSlidePageState> slidePagekey =
      GlobalKey<ExtendedImageSlidePageState>();

  @override
  void initState() {
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 150), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    clearGestureDetailsCache();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExtendedImageSlidePage(
      key: slidePagekey,
      slideAxis: SlideAxis.both,
      slideType: SlideType.onlyImage,
      resetPageDuration: Duration(milliseconds: 250),
      child: GestureDetector(
        onTap: () {
          slidePagekey.currentState?.popPage();
          Navigator.pop(context);
        },
        child: Container(
          constraints: BoxConstraints.expand(
            height: MediaQuery.of(context).size.height,
          ),
          // color: Colors.black,
          // TODO: isuess: 345 会报错，临时解决方案
          child: Hero(
            tag: 'picture-${widget.heroLabel}-${widget.id}',
            child: ExtendedImage.network(
              widget.image,
              enableSlideOutPage: true,
              // heroBuilderForSlidingPage: (Widget result) {
              //   return Hero(
              //     tag: 'picture-${widget.heroLabel}-${widget.id}',
              //     child: result,
              //     flightShuttleBuilder: (BuildContext flightContext,
              //         Animation<double> animation,
              //         HeroFlightDirection flightDirection,
              //         BuildContext fromHeroContext,
              //         BuildContext toHeroContext) {
              //       final Hero hero =
              //           (flightDirection == HeroFlightDirection.pop
              //               ? fromHeroContext.widget
              //               : toHeroContext.widget) as Hero;
              //       return hero.child;
              //     },
              //   );
              // },
              mode: ExtendedImageMode.gesture,
              onDoubleTap: (ExtendedImageGestureState state) {
                ///you can use define pointerDownPosition as you can,
                ///default value is double tap pointer down position.
                var pointerDownPosition = state.pointerDownPosition;
                double begin = state.gestureDetails!.totalScale!;
                double end;

                //remove old
                _animation?.removeListener(animationListener!);

                //stop pre
                _animationController?.stop();

                //reset to use
                _animationController?.reset();

                if (begin == doubleTapScales[0]) {
                  end = doubleTapScales[1];
                } else {
                  end = doubleTapScales[0];
                }

                animationListener = () {
                  //print(_animation.value);
                  state.handleDoubleTap(
                      scale: _animation?.value,
                      doubleTapPosition: pointerDownPosition);
                };
                _animation = _animationController
                    ?.drive(Tween<double>(begin: begin, end: end));

                _animation?.addListener(animationListener!);

                _animationController?.forward();
              },
              initGestureConfigHandler: (state) {
                return GestureConfig(
                  minScale: scales[0],
                  animationMinScale: scales[0] - 0.3,
                  maxScale: scales[1],
                  animationMaxScale: scales[1] + 0.5,
                  speed: 1.0,
                  inertialSpeed: 100.0,
                  initialScale: 1.0,
                  initialAlignment: InitialAlignment.center,
                );
              },
            ),
            flightShuttleBuilder: (BuildContext flightContext,
                Animation<double> animation,
                HeroFlightDirection flightDirection,
                BuildContext fromHeroContext,
                BuildContext toHeroContext) {
              final Hero hero = (flightDirection == HeroFlightDirection.pop
                  ? fromHeroContext.widget
                  : toHeroContext.widget) as Hero;
              return hero.child;
            },
          ),
        ),
      ),
    );
  }
}
