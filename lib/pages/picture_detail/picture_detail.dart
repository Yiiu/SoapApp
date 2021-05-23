import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:jiffy/jiffy.dart';
import 'package:soap_app/config/const.dart';
import 'package:soap_app/config/router.dart';
import 'package:soap_app/config/theme.dart';
import 'package:soap_app/graphql/fragments.dart';
import 'package:soap_app/graphql/gql.dart';
import 'package:soap_app/graphql/query.dart' as query;
import 'package:soap_app/model/picture.dart';
import 'package:soap_app/model/tag.dart';
import 'package:soap_app/pages/picture_detail/widgets/app_bar_title.dart';
import 'package:soap_app/pages/picture_detail/widgets/comment.dart';
import 'package:soap_app/pages/picture_detail/widgets/handle.dart';
import 'package:soap_app/pages/picture_detail/widgets/image.dart';
import 'package:soap_app/pages/picture_detail/widgets/info.dart';
import 'package:soap_app/pages/picture_detail/widgets/more_handle.dart';
import 'package:soap_app/pages/picture_detail/widgets/tag_item.dart';
import 'package:soap_app/utils/picture.dart';
import 'package:soap_app/widget/app_bar.dart';
import 'package:soap_app/widget/avatar.dart';
import 'package:soap_app/widget/hero_photo_view.dart';
import 'package:soap_app/widget/modal_bottom_sheet.dart';
import 'package:soap_app/widget/router/transparent_route.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

class PictureDetailPage extends StatelessWidget {
  const PictureDetailPage({
    Key? key,
    required this.picture,
    this.heroLabel,
  }) : super(key: key);
  final Picture picture;
  final String? heroLabel;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Map<String, int> variables = {
      'id': picture.id,
    };
    return Material(
      child: Query(
        options: QueryOptions(
          document: addFragments(
            query.picture,
            [...pictureDetailFragmentDocumentNode],
          ),
          variables: variables,
        ),
        builder: (
          QueryResult result, {
          Refetch? refetch,
          FetchMore? fetchMore,
        }) {
          Picture data = picture;
          if (result.data != null) {
            data = Picture.fromJson(
                result.data!['picture'] as Map<String, dynamic>);
          }
          return FixedAppBarWrapper(
            backdropBar: true,
            appBar: SoapAppBar(
              backdrop: true,
              border: false,
              automaticallyImplyLeading: true,
              elevation: 0,
              title: PictureAppBarTitle(
                avatar: picture.user!.avatarUrl,
                fullName: picture.user!.fullName,
                openUserPage: () => Navigator.of(context).pushNamed(
                  RouteName.user,
                  arguments: {
                    'user': picture.user!,
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
                      builder: (BuildContext context) =>
                          PictureDetailMoreHandle(
                        picture: data,
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
                physics: const BouncingScrollPhysics(),
                children: <Widget>[
                  const SizedBox(height: appBarHeight),
                  TouchableOpacity(
                    activeOpacity: activeOpacity,
                    onTap: () {
                      Navigator.of(context).push<dynamic>(
                        TransparentRoute(
                          builder: (_) => HeroPhotoView(
                            id: data.id,
                            heroLabel: heroLabel,
                            image: getPictureUrl(
                              key: data.key,
                              style: PictureStyle.regular,
                            ),
                          ),
                        ),
                      );
                    },
                    child: RepaintBoundary(
                      child: PictureDetailImage(
                        picture: data,
                        heroLabel: heroLabel,
                      ),
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
                          Text(
                            data.title,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              color: theme.textTheme.bodyText2!.color,
                            ),
                          ),
                          if (data.tags != null &&
                              data.tags!.isNotEmpty) ...<Widget>[
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: Wrap(
                                spacing: 6,
                                runSpacing: 6,
                                alignment: WrapAlignment.start,
                                runAlignment: WrapAlignment.end,
                                children: data.tags!
                                    .map(
                                      (Tag tag) => TagItem(
                                        tag: tag,
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ],
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              if (data.isPrivate != null &&
                                  data.isPrivate!) ...[
                                Row(
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
                                    SizedBox(
                                      height: 14,
                                      child: Text(
                                        '私密',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: theme
                                              .textTheme.bodyText2!.color!
                                              .withOpacity(.6),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 12),
                              ],
                              Text(
                                '发布于 ${Jiffy(data.createTime.toString()).fromNow()}',
                                style: TextStyle(
                                  color: theme.textTheme.bodyText2!.color!
                                      .withOpacity(.6),
                                  fontSize: 13,
                                ),
                              ),
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
                        PictureDetailInfo(picture: data),
                        if (picture.make != null || picture.model != null)
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
                        PictureDetailComment(picture: data),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: pictureDetailHandleHeight,
                  ),
                ],
              ),
            ),
            position: PictureDetailHandle(picture: data),
          );
        },
      ),
    );
  }
}
