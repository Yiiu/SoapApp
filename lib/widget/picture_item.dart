import 'dart:convert';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:jiffy/jiffy.dart';
import 'package:octo_image/octo_image.dart';
import 'package:soap_app/config/router.dart';

import 'package:soap_app/model/picture.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

import 'avatar.dart';

class PictureInfoWidget {
  PictureInfoWidget({
    required this.icon,
    required this.color,
    required this.text,
  });

  IconData icon;
  Color color;
  String text;
}

class PictureItem extends StatefulWidget {
  const PictureItem({required this.picture});

  final Picture picture;

  @override
  PictureItemState createState() => PictureItemState();
}

class PictureItemState extends State<PictureItem> {
  PictureItemState();

  late Picture picture;
  late Uint8List imageDataBytes;

  @override
  void initState() {
    super.initState();
    picture = widget.picture;
  }

  Widget header() {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      child: Flex(
        direction: Axis.horizontal,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Row(
              children: <Widget>[
                TouchableOpacity(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      RouteName.user,
                      arguments: picture.user,
                    );
                  },
                  child: Avatar(
                    size: 36,
                    image: picture.user!.avatarUrl,
                  ),
                ),
                TouchableOpacity(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      RouteName.user,
                      arguments: picture.user,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      picture.user!.fullName,
                      style: theme.textTheme.bodyText2!.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Align(
              alignment: FractionalOffset.centerRight,
              child: Text(
                Jiffy(picture.createTime.toString()).fromNow(),
                style: theme.textTheme.bodyText2!.copyWith(
                  color: theme.textTheme.bodyText2!.color!.withOpacity(.6),
                  fontSize: 14,
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        child: AspectRatio(
          aspectRatio: picture.width / picture.height,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Hero(
              tag: 'picture-$id',
              child: OctoImage(
                placeholderBuilder: OctoPlaceholder.blurHash(
                  picture.blurhash,
                ),
                image: CachedNetworkImageProvider(picture.pictureUrl()),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget bottom() {
    final List<PictureInfoWidget> list = [
      PictureInfoWidget(
        icon: FeatherIcons.eye,
        color: Colors.blue[300]!,
        text: picture.views.toString(),
      ),
      PictureInfoWidget(
        icon: FeatherIcons.messageSquare,
        color: Colors.pink[300]!,
        text: picture.commentCount.toString(),
      ),
      PictureInfoWidget(
        icon: FeatherIcons.heart,
        color: Colors.red[300]!,
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
