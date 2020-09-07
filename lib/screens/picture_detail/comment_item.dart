import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:soap_app/model/comment.dart';
import 'package:soap_app/ui/widget/avatar.dart';

class CommentItem extends StatefulWidget {
  const CommentItem({
    @required this.comment,
    this.isChild = false,
  });

  final Comment comment;

  final bool isChild;

  @override
  _CommentItemState createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  Comment comment;
  bool isChild;

  double _avatarSize = 32;

  @override
  initState() {
    comment = widget.comment;
    isChild = widget.isChild;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (!isChild) ...[
                Avatar(
                  image: comment.user.avatarUrl,
                  size: _avatarSize,
                ),
                SizedBox(
                  width: 8,
                ),
              ],
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        Text(
                          comment.user.fullName,
                          style: theme.textTheme.bodyText2.copyWith(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            '·',
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.textTheme.bodyText2.color
                                  .withOpacity(.6),
                            ),
                          ),
                        ),
                        Text(
                          Jiffy(comment.createTime.toString()).fromNow(),
                          style: theme.textTheme.bodyText2.copyWith(
                            fontSize: 12,
                            color:
                                theme.textTheme.bodyText2.color.withOpacity(.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    comment.content,
                    style: theme.textTheme.bodyText2.copyWith(
                      fontSize: 14,
                    ),
                  ),
                ],
              )
            ],
          ),
          if (comment.childComments != null &&
              comment.childComments.isNotEmpty) ...[
            Stack(
              children: <Widget>[
                Positioned(
                  left: _avatarSize / 2,
                  top: 0,
                  child: Container(
                    height: 400,
                    width: .5,
                    color: theme.textTheme.bodyText2.color.withOpacity(.2),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: _avatarSize + 8),
                  child: Column(
                    children: comment.childComments.map(
                      (Comment e) {
                        return CommentItem(
                          isChild: false,
                          comment: e,
                        );
                      },
                    ).toList(),
                  ),
                )
              ],
            )
          ],
        ],
      ),
    );
  }
}
