import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:octo_image/octo_image.dart';
import 'package:soap_app/model/picture.dart';
import 'package:soap_app/utils/utils.dart';
import 'package:soap_app/widget/hero/hero_widget.dart';

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
    final Size size = MediaQuery.of(context).size;
    return ExtendedImageSlidePage(
      key: slidePagekey,
      child: HeroWidget(
        tag: 'new-picture-detail-${widget.picture.id}',
        slideType: SlideType.onlyImage,
        slidePagekey: slidePagekey,
        child: ExtendedImage.network(
          getPictureUrl(
            key: widget.picture.key,
            style: PictureStyle.full,
          ),
          cache: true,
          fit: BoxFit.contain,
          mode: ExtendedImageMode.gesture,
          loadStateChanged: (ExtendedImageState state) {
            switch (state.extendedImageLoadState) {
              case LoadState.loading:
                // TODO: 第一次获取会闪烁，为了更平滑加上一个placeholder
                return Center(
                  child: AspectRatio(
                    aspectRatio: widget.picture.width / widget.picture.height,
                    child: OctoImage(
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
                          color: HexColor.fromHex(widget.picture.color),
                        );
                      },
                    ),
                  ),
                );
              case LoadState.completed:
                // TODO: Handle this case.
                break;
              case LoadState.failed:
                return ExtendedImage.network(
                  getPictureUrl(
                    key: widget.picture.key,
                    style: widget.pictureStyle,
                  ),
                  cache: true,
                );
                break;
            }
          },
          initGestureConfigHandler: (ExtendedImageState state) {
            double? initialScale = 1.0;
            if (state.extendedImageInfo != null) {
              initialScale = initScale(
                size: size,
                initialScale: initialScale,
                imageSize: Size(
                  state.extendedImageInfo!.image.width.toDouble(),
                  state.extendedImageInfo!.image.height.toDouble(),
                ),
              );
            }
            return GestureConfig(
              minScale: 1,
              animationMinScale: 0.5,
              maxScale: 4.0,
              animationMaxScale: 4.5,
              speed: 1.0,
              inertialSpeed: 150.0,
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
