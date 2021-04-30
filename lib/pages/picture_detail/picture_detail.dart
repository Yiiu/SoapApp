import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:soap_app/graphql/fragments.dart';
import 'package:soap_app/graphql/gql.dart';
import 'package:soap_app/graphql/query.dart' as query;
import 'package:soap_app/model/picture.dart';
import 'package:soap_app/model/tag.dart';
import 'package:soap_app/pages/picture_detail/image.dart';
import 'package:soap_app/pages/picture_detail/tag_item.dart';
import 'package:soap_app/widget/app_bar.dart';
import 'package:soap_app/widget/avatar.dart';

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
        appBar: SoapAppBar(
          automaticallyImplyLeading: true,
          elevation: 0.2,
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
              print(data.tags);
              return MediaQuery.removePadding(
                removeTop: true,
                context: context,
                child: Container(
                  color: theme.backgroundColor,
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: <Widget>[
                      PictureDetailImage(
                        picture: data,
                        heroLabel: heroLabel,
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
                            if (data.tags != null) ...[
                              SizedBox(height: 6),
                              Row(
                                children: data.tags!
                                    .map(
                                      (Tag tag) => TagItem(
                                        tag: tag,
                                      ),
                                    )
                                    .toList(),
                              )
                            ]
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
