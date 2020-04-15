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

class PictureDetail extends StatefulWidget {
  PictureDetail({Key key, this.picture}) : super(key: key);

  final Picture picture;

  @override
  _PictureDetailState createState() => _PictureDetailState();
}

class _PictureDetailState extends State<PictureDetail> {
  Picture picture;

  @override
  initState() {
    super.initState();
    picture = widget.picture;
  }

  Widget userHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      child: Flex(
        direction: Axis.horizontal,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Row(
              children: <Widget>[
                ClipOval(
                  child: Image(
                    width: 40,
                    height: 40,
                    image: NetworkImage(picture.user.avatarUrl),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(bottom: 6),
                        child: Text(
                          picture.title,
                          style: GoogleFonts.rubik(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        picture.user.fullName,
                        style: GoogleFonts.rubik(
                          textStyle: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
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
    );
  }

  Widget container() {
    var id = picture.id;
    Uint8List bytes = base64
        .decode(picture.blurhashSrc.replaceAll('data:image/png;base64,', ''));
    return Container(
      child: AspectRatio(
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
    );
  }

  Widget handleContent() {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              CupertinoButton(
                onPressed: () {},
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Color(0xFFE1E7EF), width: 1),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 14),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          FeatherIcons.heart,
                          color: Colors.red,
                          size: 16,
                        ),
                        SizedBox(width: 6),
                        Text(
                          picture.likedCount.toString(),
                          style: GoogleFonts.rubik(
                            textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Container(
        color: theme.backgroundColor,
        child: Stack(
          children: <Widget>[
            Expanded(
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: <Widget>[
                  // userHeader(),
                  container(),
                  handleContent(),
                ],
              ),
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
    );
  }
}
