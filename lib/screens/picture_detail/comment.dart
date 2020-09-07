import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import 'package:jiffy/jiffy.dart';
import 'package:soap_app/model/comment.dart';
import 'package:soap_app/model/pagination.dart';
import 'package:soap_app/repository/comment_repository.dart';
import 'package:soap_app/screens/picture_detail/comment_item.dart';
import 'package:soap_app/ui/widget/avatar.dart';
import 'package:soap_app/utils/storage.dart';

class PictureDetailComment extends StatefulWidget {
  PictureDetailComment({
    this.id,
    this.total,
  }) {}

  int id;
  int total;

  @override
  PictureCommentState createState() {
    return PictureCommentState();
  }
}

class PictureCommentState extends State<PictureDetailComment> {
  @override
  void initState() {
    total = widget.total;
    super.initState();
    getCache();
    getComments();
  }

  int total;

  dynamic commentData;

  List<Comment> get comments {
    if (commentData == null) {
      return [];
    }
    return Comment.fromListJson(commentData['data'] as List<dynamic>);
  }

  Future<void> getComments() async {
    final QueryResult data = await CommentRepository.comment(
      widget.id,
      Pagination(
        page: 1,
      ),
    );
    if (data.data != null && data.data['comments'] != null) {
      print('123123');
      StorageUtil.setString(
          'comments.${widget.id}', json.encode(data.data['comments']));
      setState(() {
        commentData = data.data['comments'];
      });
    }
  }

  void getCache() {
    final cache = StorageUtil.getString('comments.${widget.id}');

    if (cache != null) {
      setState(() {
        commentData = json.decode(cache);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      color: theme.cardColor,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            children: <Widget>[
              Text(
                '评论',
                style: theme.textTheme.bodyText2.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                total.toString(),
                style: theme.textTheme.bodyText2.copyWith(
                  color: theme.textTheme.bodyText2.color.withOpacity(.6),
                ),
              ),
            ],
          ),
          ...comments.map((Comment comment) {
            return CommentItem(
              comment: comment,
            );
          }).toList()
        ],
      ),
    );
  }
}
