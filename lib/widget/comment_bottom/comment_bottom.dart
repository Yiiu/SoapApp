import 'package:flutter/material.dart';
import 'package:soap_app/config/config.dart';
import 'package:soap_app/model/picture.dart';
import 'package:soap_app/pages/picture_detail/widgets/widgets.dart';
import 'package:soap_app/widget/widgets.dart';

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
      children: [
        MoreHandleModal(
          title: '全部评论',
          child: Expanded(
            child: SizedBox(
              width: double.infinity,
              child: FutureBuilder<dynamic>(
                future: Future<dynamic>.delayed(
                  Duration(milliseconds: screenDelayTimer),
                ),
                builder: (BuildContext context, snapshot) {
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
