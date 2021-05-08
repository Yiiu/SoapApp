import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:jiffy/jiffy.dart';
import 'package:soap_app/graphql/fragments.dart';
import 'package:soap_app/graphql/gql.dart';
import 'package:soap_app/model/comment.dart';
import 'package:soap_app/model/picture.dart';
import 'package:soap_app/graphql/query.dart' as query;
import 'package:soap_app/utils/picture.dart';
import 'package:soap_app/widget/avatar.dart';

class PictureDetailComment extends StatefulWidget {
  PictureDetailComment({
    Key? key,
    required this.picture,
  }) : super(key: key);
  Picture picture;

  @override
  _PictureDetailCommentState createState() => _PictureDetailCommentState();
}

class _PictureDetailCommentState extends State<PictureDetailComment> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final variables = {
      'id': widget.picture.id,
    };
    return Query(
      options: QueryOptions(
        document: addFragments(
          query.comments,
          [...commentListFragmentDocumentNode],
        ),
        variables: variables,
      ),
      builder: (
        QueryResult result, {
        Refetch? refetch,
        FetchMore? fetchMore,
      }) {
        Widget content = Center(
          child: CupertinoActivityIndicator(radius: 8),
        );
        if (result.data != null) {
          final List<Comment> data =
              Comment.fromListJson(result.data!['comments']['data'] as List);
          if (data.isNotEmpty) {
            content = Column(
              children: data
                  .map(
                    (comment) => Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Avatar(
                            image: getPictureUrl(key: comment.user!.avatar),
                          ),
                          const SizedBox(width: 6),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    comment.user!.fullName,
                                    style: GoogleFonts.rubik(
                                      textStyle: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: theme.textTheme.bodyText2!.color!
                                            .withOpacity(.8),
                                      ),
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
                                    style: GoogleFonts.rubik(
                                      textStyle: TextStyle(
                                        color: theme.textTheme.bodyText2!.color!
                                            .withOpacity(.6),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                comment.content,
                                style: GoogleFonts.rubik(
                                  textStyle: TextStyle(
                                    color: theme.textTheme.bodyText2!.color!,
                                    fontSize: 16,
                                  ),
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
              child: Text(
                '暂无评论',
                style: TextStyle(
                  fontSize: 16,
                  color: theme.textTheme.bodyText2!.color!.withOpacity(.6),
                ),
              ),
            );
          }
        }
        return Container(
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 16,
          ),
          color: theme.cardColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                (widget.picture.commentCount ?? 0).toString() + ' 条评论',
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
