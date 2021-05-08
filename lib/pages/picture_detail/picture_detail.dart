import 'package:flutter/material.dart';
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
import 'package:soap_app/pages/picture_detail/widgets/comment.dart';
import 'package:soap_app/pages/picture_detail/widgets/handle.dart';
import 'package:soap_app/pages/picture_detail/widgets/image.dart';
import 'package:soap_app/pages/picture_detail/widgets/info.dart';
import 'package:soap_app/pages/picture_detail/widgets/tag_item.dart';
import 'package:soap_app/utils/picture.dart';
import 'package:soap_app/widget/app_bar.dart';
import 'package:soap_app/widget/avatar.dart';
import 'package:soap_app/widget/hero_photo_view.dart';
import 'package:soap_app/widget/router/transparent_route.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

class PictureDetailPage extends StatelessWidget {
  PictureDetailPage({
    required this.picture,
    this.heroLabel,
  });
  Picture picture;
  String? heroLabel;
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
              border: true,
              automaticallyImplyLeading: true,
              elevation: 0,
              title: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Row(
                  children: <Widget>[
                    TouchableOpacity(
                      activeOpacity: activeOpacity,
                      onTap: () => Navigator.of(context).pushNamed(
                        RouteName.user,
                        arguments: {
                          'user': picture.user,
                          'heroId': '',
                        },
                      ),
                      child: Avatar(
                        size: 38,
                        image: picture.user!.avatarUrl,
                      ),
                    ),
                    TouchableOpacity(
                      activeOpacity: activeOpacity,
                      behavior: HitTestBehavior.opaque,
                      onTap: () => Navigator.of(context).pushNamed(
                        RouteName.user,
                        arguments: {
                          'user': picture.user,
                          'heroId': '',
                        },
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: Text(
                          picture.user!.fullName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            body: Container(
              color: theme.backgroundColor,
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: <Widget>[
                  const SizedBox(height: appBarHeight),
                  SizedBox(
                    child: TouchableOpacity(
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
                      child: PictureDetailImage(
                        picture: data,
                        heroLabel: heroLabel,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    color: theme.cardColor,
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          picture.title,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: theme.textTheme.bodyText2!.color,
                          ),
                        ),
                        if (data.tags != null && data.tags!.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Row(
                            children: data.tags!
                                .map(
                                  (Tag tag) => TagItem(
                                    tag: tag,
                                  ),
                                )
                                .toList(),
                          )
                        ],
                        const SizedBox(height: 6),
                        Text(
                          '发布于 ${Jiffy(data.createTime.toString()).fromNow()}',
                          style: TextStyle(
                            color: theme.textTheme.bodyText2!.color!
                                .withOpacity(.6),
                            fontSize: 13,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    color: theme.cardColor,
                    child: Column(
                      children: [
                        PictureDetailInfo(picture: data),
                        Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width - 160,
                            height: .5,
                            color: theme.backgroundColor,
                          ),
                        ),
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
