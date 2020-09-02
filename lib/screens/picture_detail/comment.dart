import 'package:flutter/material.dart';

class PictureDetailComment extends StatefulWidget {
  @override
  PictureCommentState createState() {
    return PictureCommentState();
  }
}

class PictureCommentState extends State<PictureDetailComment> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      color: Colors.white,
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
                '0',
                style: theme.textTheme.bodyText2.copyWith(
                  color: theme.textTheme.bodyText2.color.withOpacity(.6),
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 12,
            ),
            child: Center(
              child: Text(
                '暂无评论',
                style: theme.textTheme.bodyText2.copyWith(fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
