import 'dart:convert';
import 'dart:typed_data';

import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:soap_app/config/router.dart';

import '../../model/picture.dart';

class PictureInfoWidget {
  IconData icon;
  Color color;
  String text;

  PictureInfoWidget({this.icon, this.color, this.text});
}

class PictureItem extends StatefulWidget {
  final Picture picture;

  PictureItem({this.picture});

  @override
  PictureItemState createState() => PictureItemState();
}

class PictureItemState extends State<PictureItem> {
  Picture picture;
  Uint8List imageDataBytes;

  PictureItemState({this.picture});

  @override
  void initState() {
    super.initState();
    picture = widget.picture;
  }

  Widget header() {
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
                  child: Text(
                    picture.user.fullName,
                    style: GoogleFonts.rubik(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Align(
              alignment: FractionalOffset.centerRight,
              child: Text(
                Jiffy(picture.createTime.toString()).fromNow(),
                style: GoogleFonts.rubik(
                  textStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black38,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget container() {
    Uint8List bytes = base64
        .decode(picture.blurhashSrc.replaceAll('data:image/png;base64,', ''));
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(RouteName.picture_detail, arguments: picture);
      },
      child: Container(
        child: AspectRatio(
          aspectRatio: picture.width / picture.height,
          child: new FadeInImage.memoryNetwork(
            placeholder: bytes,
            fadeInDuration: Duration(milliseconds: 400),
            image: picture.pictureUrl(),
            fit: BoxFit.cover,
            // imageBuilder: (context, imageProvider) => Container(
            //   decoration: BoxDecoration(
            //     image: DecorationImage(
            //         image: imageProvider,
            //         fit: BoxFit.cover,
            //         colorFilter:
            //             ColorFilter.mode(Colors.red, BlendMode.colorBurn)),
            //   ),
            // ),
          ),
        ),
      ),
    );
  }

  Widget bottom() {
    List<PictureInfoWidget> list = [
      PictureInfoWidget(
        icon: FeatherIcons.eye,
        color: Colors.blue[300],
        text: picture.views.toString(),
      ),
      PictureInfoWidget(
        icon: FeatherIcons.messageSquare,
        color: Colors.pink[300],
        text: picture.commentCount.toString(),
      ),
      PictureInfoWidget(
        icon: FeatherIcons.heart,
        color: Colors.red[300],
        text: picture.likedCount.toString(),
      ),
    ];
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: list.map((data) {
              return Padding(
                padding: EdgeInsets.only(right: 16),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(right: 4),
                      child: Icon(
                        data.icon,
                        color: data.color,
                        size: 20,
                      ),
                    ),
                    Text(
                      data.text,
                      style: GoogleFonts.rubik(
                        textStyle: TextStyle(color: Colors.black54),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color.fromRGBO(243, 243, 244, 1), width: 1),
        ),
      ),
      child: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              header(),
              container(),
              bottom(),
            ],
          ),
        ],
      ),
    );
  }
}
