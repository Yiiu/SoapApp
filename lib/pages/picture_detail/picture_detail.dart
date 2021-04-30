import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:jiffy/jiffy.dart';
import 'package:soap_app/config/theme.dart';
import 'package:soap_app/graphql/fragments.dart';
import 'package:soap_app/graphql/gql.dart';
import 'package:soap_app/graphql/query.dart' as query;
import 'package:soap_app/model/picture.dart';
import 'package:soap_app/model/tag.dart';
import 'package:soap_app/pages/picture_detail/image.dart';
import 'package:soap_app/pages/picture_detail/tag_item.dart';
import 'package:soap_app/utils/picture.dart';
import 'package:soap_app/widget/app_bar.dart';
import 'package:soap_app/widget/avatar.dart';
import 'package:soap_app/widget/hero_photo_view.dart';
import 'package:soap_app/widget/router/transparent_route.dart';
import 'package:touchable_opacity/touchable_opacity.dart';
import 'package:extended_image/extended_image.dart';

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
    print(picture.isDark);
    final Map<String, int> variables = {
      'id': picture.id,
    };
    return Material(
      child: FixedAppBarWrapper(
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
                Avatar(
                  size: 38,
                  image: picture.user!.avatarUrl,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    picture.user!.fullName,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        body: Query(
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
            return Stack(
              children: [
                Container(
                  color: theme.cardColor,
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: <Widget>[
                      SizedBox(
                        height: appBarHeight,
                      ),
                      TouchableOpacity(
                        onTap: () {
                          Navigator.of(context).push<dynamic>(
                            TransparentRoute(
                              builder: (context) => HeroPhotoView(
                                id: data.id,
                                heroLabel: heroLabel,
                                image: getPictureUrl(
                                  key: data.key,
                                  style: PictureStyle.full,
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
                      Container(
                        color: theme.cardColor,
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 16,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                        color: theme.backgroundColor,
                        height: 8,
                        width: double.infinity,
                      ),
                      SizedBox(
                        height: 1000,
                      )
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    width: double.infinity,
                    height: 54,
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: const Color(0xff000000).withOpacity(.05),
                          blurRadius: 12,
                          offset: Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Flex(
                      direction: Axis.horizontal,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: double.infinity,
                            padding: const EdgeInsets.only(left: 12),
                            decoration: const BoxDecoration(
                              color: Color(0xffF5F5F5),
                              borderRadius: BorderRadius.all(
                                Radius.circular(100),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  FeatherIcons.edit3,
                                  size: 16,
                                  color: theme.textTheme.bodyText2!.color!
                                      .withOpacity(.7),
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  '说点什么吧',
                                  style: TextStyle(
                                    color: theme.textTheme.bodyText2!.color!
                                        .withOpacity(.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Container(
                          height: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                FeatherIcons.heart,
                                color: theme.textTheme.bodyText2!.color!
                                    .withOpacity(.8),
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(data.likedCount.toString())
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
