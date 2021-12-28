import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soap_app/utils/image.dart';
import 'package:soap_app/widget/modal_bottom_sheet.dart';
import 'package:soap_app/widget/more_handle_modal/more_handle_modal.dart';
import 'package:soap_app/widget/select_list.dart';

class HeroPhotoView extends StatefulWidget {
  const HeroPhotoView({
    Key? key,
    this.heroLabel,
    required this.image,
    required this.id,
  }) : super(key: key);

  final String image;
  final int id;
  final String? heroLabel;

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
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: GestureDetector(
        onTap: () {
          slidePagekey.currentState?.popPage();
          Navigator.pop(context);
        },
        onLongPress: () {
          showBasicModalBottomSheet(
            context: context,
            builder: (_) => MoreHandleModal(
              title: '操作',
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: SoapSelectList<int>(
                  value: 2,
                  onChange: (int value) {
                    Navigator.pop(_);
                    saveImage(widget.image);
                  },
                  config: <SelectTileConfig<int>>[
                    SelectTileConfig<int>(
                      title: '保存到本地',
                      value: 1,
                    ),
                  ],
                ),
              ),
              // child: Padding(
              //   padding: const EdgeInsets.only(bottom: 16),
              //   child: ListTile(
              //     dense: false,
              //     contentPadding: const EdgeInsets.symmetric(
              //       vertical: 0,
              //       horizontal: 0,
              //     ),
              //     title: const Center(
              //       child: Text('保存到相册'),
              //     ),
              //     onTap: () {
              //       Navigator.pop(_);
              //       saveImage(widget.image);
              //     },
              //   ),
              // ),
            ),
          );
          // print('长按');
        },
        child: Container(
          constraints: BoxConstraints.expand(
            height: MediaQuery.of(context).size.height,
          ),
          color: Colors.black,
          // TODO: issues: 345 会报错，临时解决方案
          child: ExtendedImage.network(
            widget.image,
            clearMemoryCacheWhenDispose: true,
            enableSlideOutPage: true,
            handleLoadingProgress: true,
            loadStateChanged: (ExtendedImageState state) {
              if (state.extendedImageLoadState == LoadState.loading) {
                final ImageChunkEvent? loadingProgress = state.loadingProgress;
                if (loadingProgress == null) {
                  return Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(
                        Colors.white.withOpacity(.9),
                      ),
                    ),
                  );
                }
                final double? progress =
                    loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null;
                if (progress == null) {
                  return Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(
                        Colors.white.withOpacity(.9),
                      ),
                    ),
                  );
                }
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.white.withOpacity(.4),
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(
                          Colors.white.withOpacity(.9),
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Material(
                        type: MaterialType.transparency,
                        child: Text(
                          '${(progress * 100).toInt()}%',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
            mode: ExtendedImageMode.gesture,
            onDoubleTap: (ExtendedImageGestureState state) {
              ///you can use define pointerDownPosition as you can,
              ///default value is double tap pointer down position.
              final Offset? pointerDownPosition = state.pointerDownPosition;
              final double begin = state.gestureDetails!.totalScale!;
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
            // flightShuttleBuilder: (BuildContext flightContext,
            //     Animation<double> animation,
            //     HeroFlightDirection flightDirection,
            //     BuildContext fromHeroContext,
            //     BuildContext toHeroContext) {
            //   final Hero hero = (flightDirection == HeroFlightDirection.pop
            //       ? fromHeroContext.widget
            //       : toHeroContext.widget) as Hero;
            //   return hero.child;
            // },
          ),
        ),
      ),
    );
  }
}
