import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jiffy/jiffy.dart';
import 'package:octo_image/octo_image.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:soap_app/config/const.dart';
import 'package:soap_app/config/router.dart';
import 'package:soap_app/config/theme.dart';
import 'package:soap_app/graphql/query.dart';
import 'package:soap_app/model/picture.dart';
import 'package:soap_app/model/tag.dart';
import 'package:soap_app/pages/picture_detail/stores/picture_detail_store.dart';
import 'package:soap_app/pages/picture_detail/widgets/app_bar_title.dart';
import 'package:soap_app/pages/picture_detail/widgets/comment.dart';
import 'package:soap_app/pages/picture_detail/widgets/handle.dart';
import 'package:soap_app/pages/picture_detail/widgets/image.dart';
import 'package:soap_app/pages/picture_detail/widgets/info.dart';
import 'package:soap_app/pages/picture_detail/widgets/location_info.dart';
import 'package:soap_app/pages/picture_detail/widgets/more_handle.dart';
import 'package:soap_app/pages/picture_detail/widgets/related_picture.dart';
import 'package:soap_app/pages/picture_detail/widgets/tag_item.dart';
import 'package:soap_app/store/index.dart';
import 'package:soap_app/utils/picture.dart';
import 'package:soap_app/widget/app_bar.dart';
import 'package:soap_app/widget/hero_dialog_route.dart';
import 'package:soap_app/widget/hero_photo_view.dart';
import 'package:soap_app/widget/medal.dart';
import 'package:soap_app/widget/modal_bottom_sheet.dart';
import 'package:soap_app/widget/router/transparent_route.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

import 'widgets/title_info.dart';

class PictureDetailPage extends StatefulWidget {
  const PictureDetailPage({
    Key? key,
    required this.picture,
    this.heroLabel,
  }) : super(key: key);
  final Picture picture;
  final String? heroLabel;

  @override
  _PictureDetailPageState createState() => _PictureDetailPageState();
}

class _PictureDetailPageState extends State<PictureDetailPage> {
  final PictureDetailPageStore _pageStore = PictureDetailPageStore();

  @override
  void initState() {
    _pageStore.init(widget.picture);
    _pageStore.watchQuery();
    super.initState();
  }

  @override
  void dispose() {
    _pageStore.close();
    super.dispose();
  }

  Widget _flightShuttleBuilder(
    int index,
    Animation<double> animation,
    HeroFlightDirection flightDirection,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  ) {
    final hero = flightDirection == HeroFlightDirection.push
        ? fromHeroContext.widget as Hero
        : toHeroContext.widget as Hero;

    final tween = BorderRadiusTween(
      begin: BorderRadius.all(Radius.circular(6)),
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
    final ThemeData theme = Theme.of(context);
    return FixedAppBarWrapper(
      backdropBar: true,
      appBar: SoapAppBar(
        backdrop: true,
        border: false,
        automaticallyImplyLeading: true,
        elevation: 0,
        title: PictureAppBarTitle(
          avatar: widget.picture.user!.avatarUrl,
          fullName: widget.picture.user!.fullName,
          openUserPage: () => Navigator.of(context).pushNamed(
            RouteName.user,
            arguments: {
              'user': widget.picture.user!,
              'heroId': '',
            },
          ),
        ),
        actions: [
          TouchableOpacity(
            activeOpacity: activeOpacity,
            onTap: () {
              showBasicModalBottomSheet(
                enableDrag: true,
                context: context,
                builder: (BuildContext context) => PictureDetailMoreHandle(
                  picture: _pageStore.picture!,
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Icon(
                FeatherIcons.moreHorizontal,
                color: theme.textTheme.bodyText2!.color,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        color: theme.cardColor,
        child: ListView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          children: <Widget>[
            // const Test(),
            const SizedBox(height: appBarHeight),
            TouchableOpacity(
              activeOpacity: activeOpacity,
              onTap: () {
                Navigator.of(context).push<dynamic>(
                  HeroDialogRoute<void>(
                    builder: (_) => PhotoViewGallery.builder(
                      scrollPhysics: const BouncingScrollPhysics(),
                      itemCount: 1,
                      pageController: PageController(initialPage: 0),
                      backgroundDecoration:
                          const BoxDecoration(color: Colors.transparent),
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
                                  child: ExtendedImage.network(
                                    _pageStore.picture!.pictureUrl(
                                      style: PictureStyle.full,
                                    ),
                                  ),
                                  // child: OctoImage(
                                  //   placeholderBuilder: (context) {
                                  //     return Hero(
                                  //       flightShuttleBuilder: (
                                  //         _,
                                  //         animation,
                                  //         flightDirection,
                                  //         fromHeroContext,
                                  //         toHeroContext,
                                  //       ) =>
                                  //           _flightShuttleBuilder(
                                  //         index,
                                  //         animation,
                                  //         flightDirection,
                                  //         fromHeroContext,
                                  //         toHeroContext,
                                  //       ),
                                  //       tag:
                                  //           'picture-${widget.heroLabel}-${_pageStore.picture!.id}',
                                  //       child: OctoImage(
                                  //         image: ExtendedImage.network(
                                  //           _pageStore.picture!.pictureUrl(
                                  //             style: appStore.imgMode == 1
                                  //                 ? PictureStyle.regular
                                  //                 : PictureStyle.mediumLarge,
                                  //           ),
                                  //         ).image,
                                  //         fit: BoxFit.cover,
                                  //       ),
                                  //     );
                                  //   },
                                  //   image: ExtendedImage.network(
                                  //     _pageStore.picture!.pictureUrl(
                                  //       style: PictureStyle.full,
                                  //     ),
                                  //   ).image,
                                  //   fit: BoxFit.cover,
                                  //   imageBuilder: (_, w) {
                                  //     return Hero(
                                  //       flightShuttleBuilder: (
                                  //         _,
                                  //         animation,
                                  //         flightDirection,
                                  //         fromHeroContext,
                                  //         toHeroContext,
                                  //       ) =>
                                  //           _flightShuttleBuilder(
                                  //         index,
                                  //         animation,
                                  //         flightDirection,
                                  //         fromHeroContext,
                                  //         toHeroContext,
                                  //       ),
                                  //       tag:
                                  //           'picture-${widget.heroLabel}-${_pageStore.picture!.id}',
                                  //       child: w,
                                  //     );
                                  //   },
                                  // ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // TransparentRoute(
                  //   builder: (_) => HeroPhotoView(
                  //     id: _pageStore.picture!.id,
                  //     heroLabel: widget.heroLabel,
                  //     image: getPictureUrl(
                  //       key: _pageStore.picture!.key,
                  //       style: PictureStyle.full,
                  //     ),
                  //   ),
                  // ),
                );
              },
              child: RepaintBoundary(
                child: Observer(builder: (_) {
                  return PictureDetailImage(
                    picture: _pageStore.picture!,
                    heroLabel: widget.heroLabel,
                  );
                }),
              ),
            ),
            Observer(builder: (_) {
              return PictureTitleInfo(picture: _pageStore.picture!);
            }),
            Container(
              height: 8,
              color: theme.backgroundColor,
            ),
            Observer(builder: (_) {
              if (_pageStore.picture?.location == null) {
                return SizedBox();
              }
              return PictureLocationInfo(
                  location: _pageStore.picture!.location!);
            }),
            Container(
              color: theme.cardColor,
              child: Column(
                children: <Widget>[
                  Observer(builder: (_) {
                    return PictureDetailInfo(picture: _pageStore.picture!);
                  }),
                  if (widget.picture.make != null ||
                      widget.picture.model != null)
                    Container(
                      height: 8,
                      color: theme.backgroundColor,
                    ),
                  // Center(
                  //   child: Container(
                  //     width: MediaQuery.of(context).size.width - 160,
                  //     height: .5,
                  //     color: theme.textTheme.bodyText2!.color!
                  //         .withOpacity(.15),
                  //   ),
                  // ),
                  PictureDetailComment(store: _pageStore),
                ],
              ),
            ),
            if (_pageStore.picture!.isPrivate == null ||
                _pageStore.picture!.isPrivate == false) ...[
              Container(
                height: 8,
                color: theme.backgroundColor,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 8,
                  left: 16,
                  right: 16,
                ),
                child: Text(
                  '相关图片',
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.textTheme.bodyText2!.color!.withOpacity(.6),
                  ),
                ),
              ),
              FutureBuilder<dynamic>(
                future:
                    Future<dynamic>.delayed(const Duration(milliseconds: 300)),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done)
                    return RelatedPicture(id: _pageStore.picture!.id);
                  else
                    return const SizedBox();
                },
              ),
            ],
            const SizedBox(
              height: pictureDetailHandleHeight,
            ),
          ],
        ),
      ),
      position: Observer(builder: (_) {
        return PictureDetailHandle(picture: _pageStore.picture!);
      }),
    );
  }
}
