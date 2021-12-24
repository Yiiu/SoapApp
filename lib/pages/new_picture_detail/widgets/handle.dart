import 'package:decorated_icon/decorated_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:soap_app/model/picture.dart';

import '../constants.dart';

class NewPictureDetailHandle extends StatefulWidget {
  NewPictureDetailHandle({
    Key? key,
    required this.picture,
  }) : super(key: key);

  Picture picture;

  @override
  _NewPictureDetailHandleState createState() => _NewPictureDetailHandleState();
}

class _NewPictureDetailHandleState extends State<NewPictureDetailHandle> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0,
      bottom: 0,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Container(
              child: Column(
                children: [
                  Column(
                    children: const <Widget>[
                      DecoratedIcon(
                        Icons.favorite,
                        size: 26,
                        color: Colors.white,
                        shadows: <Shadow>[
                          Shadow(
                            offset: Offset(0.0, 1.0),
                            blurRadius: 10,
                            color: Colors.black12,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    (widget.picture.likedCount ?? 0).toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      shadows: shadow,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            Container(
              child: Column(
                children: [
                  Column(
                    children: const <Widget>[
                      DecoratedIcon(
                        Icons.mode_comment,
                        size: 26,
                        color: Colors.white,
                        shadows: <Shadow>[
                          Shadow(
                            offset: Offset(0.0, 1.0),
                            blurRadius: 10,
                            color: Colors.black12,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    (widget.picture.commentCount ?? 0).toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      shadows: shadow,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            Container(
              child: Column(
                children: [
                  Column(
                    children: const <Widget>[
                      DecoratedIcon(
                        Icons.bookmark,
                        size: 26,
                        color: Colors.white,
                        shadows: <Shadow>[
                          Shadow(
                            offset: Offset(0.0, 1.0),
                            blurRadius: 10,
                            color: Colors.black12,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
