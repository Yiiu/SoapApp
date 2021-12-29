import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

import '../../config/config.dart';
import '../../model/picture.dart';
import '../../pages/picture_detail/widgets/widgets.dart';
import '../widgets.dart';

class CommentBottomModal extends StatelessWidget {
  const CommentBottomModal({
    Key? key,
    required this.picture,
    required this.id,
    this.handle = true,
    this.commentCount = 0,
  }) : super(key: key);

  final int id;
  final int? commentCount;
  final Picture picture;
  final bool handle;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        MoreHandleModal(
          title: FlutterI18n.translate(context, 'comment.title.all_comment'),
          child: Expanded(
            child: SizedBox(
              width: double.infinity,
              child: FutureBuilder<dynamic>(
                future: Future<dynamic>.delayed(
                  Duration(milliseconds: screenDelayTimer),
                ),
                builder: (
                  BuildContext context,
                  AsyncSnapshot<dynamic> snapshot,
                ) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return PictureDetailComment(
                      id: id,
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ),
          ),
        ),
        PictureDetailHandle(
          picture: picture,
          handle: handle,
        ),
      ],
    );
  }
}
