import 'dart:convert';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_fade/image_fade.dart';
import 'package:jiffy/jiffy.dart';

import 'package:soap_app/model/picture.dart';
import 'package:soap_app/screens/picture_detail/index.dart';
import 'package:soap_app/ui/widget/avatar.dart';

class PictureInfoWidget {
  PictureInfoWidget({this.icon, this.color, this.text});

  IconData icon;
  Color color;
  String text;
}

class PictureItem extends StatefulWidget {
  const PictureItem({this.picture});

  final Picture picture;

  @override
  PictureItemState createState() => PictureItemState();
}

class PictureItemState extends State<PictureItem> {
  PictureItemState({this.picture});

  Picture picture;
  Uint8List imageDataBytes;

  @override
  void initState() {
    super.initState();
    picture = widget.picture;
  }

  Widget header() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      child: Flex(
        direction: Axis.horizontal,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Row(
              children: <Widget>[
                Avatar(
                  size: 36,
                  image: picture.user.avatarUrl,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    picture.user.fullName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
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
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.black38,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget container() {
    final int id = picture.id;
    final Uint8List bytes = base64
        .decode(picture.blurhashSrc.replaceAll('data:image/png;base64,', ''));
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: OpenContainerWrapper(
        closedBuilder: (BuildContext _, VoidCallback openContainer) {
          return GestureDetector(
            onTap: () {
              openContainer();
            },
            child: AspectRatio(
              aspectRatio: picture.width / picture.height,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Hero(
                  tag: 'picture-$id',
                  child: ImageFade(
                    fadeDuration: const Duration(milliseconds: 100),
                    placeholder: Image.memory(
                      base64.decode(picture.blurhashSrc.split(',')[1]),
                      fit: BoxFit.cover,
                      gaplessPlayback: true,
                    ),
                    image: CachedNetworkImageProvider(picture.pictureUrl()),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          );
        },
        picture: picture,
      ),
    );
  }

  Widget bottom() {
    final List<PictureInfoWidget> list = [
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
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: list.map((PictureInfoWidget data) {
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Icon(
                        data.icon,
                        color: data.color,
                        size: 20,
                      ),
                    ),
                    Text(
                      data.text,
                      style: const TextStyle(color: Colors.black54),
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
      decoration: const BoxDecoration(
        // color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Color.fromRGBO(243, 243, 244, 1),
            width: 0,
          ),
        ),
      ),
      child: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              header(),
              container(),
              // bottom(),
            ],
          ),
        ],
      ),
    );
  }
}
