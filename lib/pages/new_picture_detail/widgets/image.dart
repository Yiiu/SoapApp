import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:soap_app/model/picture.dart';
import 'package:soap_app/utils/utils.dart';
import 'package:soap_app/widget/hero/hero_widget.dart';

typedef DoubleClickAnimationListener = void Function();

class NewPictureDetailImage extends StatefulWidget {
  NewPictureDetailImage({Key? key, required this.picture}) : super(key: key);

  Picture picture;

  @override
  _NewPictureDetailImageState createState() => _NewPictureDetailImageState();
}

class _NewPictureDetailImageState extends State<NewPictureDetailImage>
    with TickerProviderStateMixin {
  GlobalKey<ExtendedImageSlidePageState> slidePagekey =
      GlobalKey<ExtendedImageSlidePageState>();

  late AnimationController _doubleClickAnimationController;
  Animation<double>? _doubleClickAnimation;
  late DoubleClickAnimationListener _doubleClickAnimationListener;

  List<double> doubleTapScales = <double>[1.0, 2.0];

  @override
  void initState() {
    super.initState();
    _doubleClickAnimationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ExtendedImageSlidePage(
      key: slidePagekey,
      child: HeroWidget(
        tag: 'new-picture-detail-${widget.picture.id}',
        slideType: SlideType.onlyImage,
        slidePagekey: slidePagekey,
        child: ExtendedImage.network(
          getPictureUrl(
            key: widget.picture.key,
            style: PictureStyle.regular,
          ),
          fit: BoxFit.contain,
          mode: ExtendedImageMode.gesture,
          imageCacheName: 'CropImage',
          initGestureConfigHandler: (ExtendedImageState state) {
            double? initialScale = 1.0;
            // if (state.extendedImageInfo != null) {
            //   initialScale = initScale(
            //       size: size,
            //       initialScale: initialScale,
            //       imageSize: Size(
            //           state.extendedImageInfo!.image.width.toDouble(),
            //           state.extendedImageInfo!.image.height
            //               .toDouble()));
            // }
            return GestureConfig(
              minScale: 1,
              animationMinScale: 0.7,
              maxScale: 3.0,
              animationMaxScale: 3.5,
              speed: 1.0,
              inertialSpeed: 100.0,
              initialScale: 1.0,
              inPageView: true,
              initialAlignment: InitialAlignment.center,
            );
          },
          onDoubleTap: (ExtendedImageGestureState state) {
            ///you can use define pointerDownPosition as you can,
            ///default value is double tap pointer down postion.
            final Offset? pointerDownPosition = state.pointerDownPosition;
            final double? begin = state.gestureDetails!.totalScale;
            double end;

            //remove old
            _doubleClickAnimation
                ?.removeListener(_doubleClickAnimationListener);

            //stop pre
            _doubleClickAnimationController.stop();

            //reset to use
            _doubleClickAnimationController.reset();

            if (begin == doubleTapScales[0]) {
              end = doubleTapScales[1];
            } else {
              end = doubleTapScales[0];
            }

            _doubleClickAnimationListener = () {
              //print(_animation.value);
              state.handleDoubleTap(
                  scale: _doubleClickAnimation!.value,
                  doubleTapPosition: pointerDownPosition);
            };
            _doubleClickAnimation = _doubleClickAnimationController
                .drive(Tween<double>(begin: begin, end: end));

            _doubleClickAnimation!.addListener(_doubleClickAnimationListener);

            _doubleClickAnimationController.forward();
          },
        ),
      ),
      slideAxis: SlideAxis.vertical,
      slideType: SlideType.onlyImage,
    );
  }
}
