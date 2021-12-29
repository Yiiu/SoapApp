import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:jiffy/jiffy.dart';

import '../../../graphql/fragments.dart';
import '../../../graphql/gql.dart';
import '../../../graphql/query.dart' as query;
import '../../../model/comment.dart';
import '../../../utils/exception.dart';
import '../../../widget/avatar.dart';
import '../../../widget/list/empty.dart';

class PictureDetailComment extends StatelessWidget {
  const PictureDetailComment({
    Key? key,
    required this.id,
    this.commentCount,
  }) : super(key: key);

  final int id;
  final int? commentCount;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Map<String, int> variables = {
      'id': id,
    };
    return Query(
      options: QueryOptions(
        document: addFragments(
          query.comments,
          [...commentListFragmentDocumentNode],
        ),
        fetchPolicy: FetchPolicy.cacheFirst,
        variables: variables,
      ),
      builder: (
        QueryResult result, {
        Refetch? refetch,
        FetchMore? fetchMore,
      }) {
        Widget content = const Center(
          child: CupertinoActivityIndicator(radius: 8),
        );

        if (result.hasException) {
          captureException(result.exception);
        }
        if (result.data != null) {
          final List<Comment> data = Comment.fromListJson(
              result.data!['comments']['data'] as List<dynamic>);
          if (data.isNotEmpty) {
            content = Column(
              children: data
                  .map(
                    (Comment comment) => Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Avatar(
                            image: comment.user!.avatarUrl,
                          ),
                          const SizedBox(width: 6),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(
                                    comment.user!.fullName,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: theme.textTheme.bodyText2!.color!
                                          .withOpacity(.8),
                                    ),
                                  ),
                                  Center(
                                    widthFactor: 6,
                                    child: ClipOval(
                                      child: Container(
                                        width: 3,
                                        height: 3,
                                        color: theme.textTheme.bodyText2!.color!
                                            .withOpacity(.6),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    Jiffy(comment.createTime.toString())
                                        .fromNow(),
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: theme.textTheme.bodyText2!.color!
                                          .withOpacity(.6),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                comment.content,
                                style: TextStyle(
                                  color: theme.textTheme.bodyText2!.color!,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                  .toList(),
            );
          } else {
            content = Center(
              child: SoapListEmpty(
                message: FlutterI18n.translate(context, 'comment.label.empty'),
              ),
            );
          }
        }
        return Container(
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (commentCount != null)
                Text(
                  '$commentCount 条评论',
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.textTheme.bodyText2!.color!.withOpacity(.6),
                  ),
                ),
              const SizedBox(height: 8),
              content,
            ],
          ),
        );
      },
    );
  }
}
