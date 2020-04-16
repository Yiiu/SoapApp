import 'dart:convert';
import 'dart:typed_data';

import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:soap_app/model/picture.dart';
import 'package:soap_app/ui/widget/app_bar.dart';
import 'package:soap_app/ui/widget/avatar.dart';

class PictureDetail extends StatefulWidget {
  PictureDetail({Key key, this.picture, this.scrollController})
      : super(key: key);

  final Picture picture;

  final ScrollController scrollController;

  @override
  _PictureDetailState createState() => _PictureDetailState();
}

class _PictureDetailState extends State<PictureDetail> {
  Picture picture;
  ScrollController scrollController;

  @override
  initState() {
    super.initState();
    picture = widget.picture;
    scrollController = widget.scrollController;
  }

  Uint8List get bytes => base64
      .decode(picture.blurhashSrc.replaceAll('data:image/png;base64,', ''));

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var id = picture.id;
    // blurhash
    double num = picture.width / picture.height;
    double minFactor = MediaQuery.of(context).size.width / 500;
    return Material(
      child: CupertinoPageScaffold(
        child: SafeArea(
          top: false,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              ListView(
                shrinkWrap: true,
                controller: scrollController,
                physics: BouncingScrollPhysics(),
                children: <Widget>[
                  Container(
                    child: (num < minFactor && num < 1)
                        ? Container(
                            color: Color(0xFFF8FAFC),
                            height: 500,
                            child: FractionallySizedBox(
                              widthFactor: picture.width / picture.height,
                              child: Hero(
                                tag: 'picture-$id',
                                child: new FadeInImage.memoryNetwork(
                                  placeholder: bytes,
                                  fadeInDuration: Duration(milliseconds: 400),
                                  image: picture.pictureUrl(),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          )
                        : AspectRatio(
                            aspectRatio: picture.width / picture.height,
                            child: Hero(
                              tag: 'picture-$id',
                              child: new FadeInImage.memoryNetwork(
                                placeholder: bytes,
                                fadeInDuration: Duration(milliseconds: 400),
                                image: picture.pictureUrl(),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                  ),
                  Container(
                    child: Column(
                      children: <Widget>[
                        Flex(
                          direction: Axis.horizontal,
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Row(
                                children: <Widget>[
                                  CupertinoButton(
                                    onPressed: () {},
                                    child: Container(
                                      height: 36,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(36.0),
                                        border: Border.all(
                                            color: Color(0xFFE1E7EF), width: 1),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Row(
                                          children: <Widget>[
                                            Icon(
                                              FeatherIcons.heart,
                                              color: Colors.red,
                                              size: 18,
                                            ),
                                            SizedBox(width: 6),
                                            Text(
                                              picture.likedCount.toString(),
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Row(
                                textDirection: TextDirection.rtl,
                                children: <Widget>[
                                  CupertinoButton(
                                    onPressed: () {},
                                    child: Container(
                                      height: 36,
                                      width: 36,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(36.0),
                                        border: Border.all(
                                            color: Color(0xFFE1E7EF), width: 1),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          FeatherIcons.bookmark,
                                          color: Colors.black87,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 16, horizontal: 20),
                          child: Flex(
                            direction: Axis.horizontal,
                            children: <Widget>[
                              Expanded(
                                flex: 2,
                                child: Row(
                                  children: <Widget>[
                                    Avatar(
                                      size: 46,
                                      image: picture.user.avatarUrl,
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 12),
                                      child: Column(
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.only(bottom: 6),
                                            child: Text(
                                              picture.user.fullName,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                right: 16,
                top: 16,
                child: CupertinoButton(
                  onPressed: () => Navigator.pop(context),
                  pressedOpacity: .8,
                  child: ClipOval(
                    child: Container(
                      color: Color.fromRGBO(0, 0, 0, .6),
                      width: 34,
                      height: 34,
                      child: Icon(
                        FeatherIcons.x,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
