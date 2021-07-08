import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jiffy/jiffy.dart';
import 'package:soap_app/config/const.dart';
import 'package:soap_app/config/router.dart';
import 'package:soap_app/config/theme.dart';
import 'package:soap_app/model/picture.dart';
import 'package:soap_app/model/tag.dart';
import 'package:soap_app/pages/picture_detail/stores/picture_detail_store.dart';
import 'package:soap_app/pages/picture_detail/widgets/app_bar_title.dart';
import 'package:soap_app/pages/picture_detail/widgets/comment.dart';
import 'package:soap_app/pages/picture_detail/widgets/handle.dart';
import 'package:soap_app/pages/picture_detail/widgets/image.dart';
import 'package:soap_app/pages/picture_detail/widgets/info.dart';
import 'package:soap_app/pages/picture_detail/widgets/more_handle.dart';
import 'package:soap_app/pages/picture_detail/widgets/tag_item.dart';
import 'package:soap_app/utils/picture.dart';
import 'package:soap_app/widget/app_bar.dart';
import 'package:soap_app/widget/hero_photo_view.dart';
import 'package:soap_app/widget/medal.dart';
import 'package:soap_app/widget/modal_bottom_sheet.dart';
import 'package:soap_app/widget/router/transparent_route.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

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
                  TransparentRoute(
                    builder: (_) => HeroPhotoView(
                      id: _pageStore.picture!.id,
                      heroLabel: widget.heroLabel,
                      image: getPictureUrl(
                        key: _pageStore.picture!.key,
                        style: PictureStyle.full,
                      ),
                    ),
                  ),
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
            Container(
              color: theme.cardColor,
              padding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 16,
              ),
              child: RepaintBoundary(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: [
                        if (widget.picture.isChoice) ...[
                          Medal(
                            type: MedalType.choice,
                            size: 24,
                          ),
                          const SizedBox(
                            width: 4,
                          )
                        ],
                        Observer(builder: (_) {
                          return Text(
                            _pageStore.picture!.title,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              color: theme.textTheme.bodyText2!.color,
                            ),
                          );
                        })
                      ],
                    ),
                    Observer(
                      builder: (_) {
                        if (_pageStore.picture!.tags == null ||
                            _pageStore.picture!.tags!.isNotEmpty) {
                          return const SizedBox();
                        }
                        return SizedBox(
                          width: double.infinity,
                          child: Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            alignment: WrapAlignment.start,
                            runAlignment: WrapAlignment.end,
                            children: _pageStore.picture!.tags!
                                .map(
                                  (Tag tag) => TagItem(
                                    tag: tag,
                                  ),
                                )
                                .toList(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Observer(builder: (_) {
                          return Visibility(
                            visible: _pageStore.picture!.isPrivate != null &&
                                _pageStore.picture!.isPrivate!,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  height: 14,
                                  width: 14,
                                  child: SvgPicture.asset(
                                    'assets/remix/lock-fill.svg',
                                    color: theme.textTheme.bodyText2!.color!
                                        .withOpacity(.6),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '私密',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: theme.textTheme.bodyText2!.color!
                                        .withOpacity(.6),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                        Observer(builder: (_) {
                          return Text(
                            '发布于 ${Jiffy(_pageStore.picture!.createTime.toString()).fromNow()}',
                            style: TextStyle(
                              color: theme.textTheme.bodyText2!.color!
                                  .withOpacity(.6),
                              fontSize: 13,
                            ),
                          );
                        }),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Container(
              height: 8,
              color: theme.backgroundColor,
            ),
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
