import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:octo_image/octo_image.dart';
import 'package:extended_image/extended_image.dart';
import 'package:soap_app/config/const.dart';
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
  PictureItem({
    Key? key,
    required this.picture,
    this.heroLabel = 'list',
    this.header = true,
    this.crossAxisSpacing = 16,
    this.mainAxisSpacing = 20,
  }) : super(key: key);

  final Picture picture;
  bool header;
  String heroLabel;
  double crossAxisSpacing;
  double mainAxisSpacing;

  @override
  PictureItemState createState() => PictureItemState();
}

class PictureItemState extends State<PictureItem> {
  PictureItemState();

  late Picture picture;
  late String heroLabel;
  late Uint8List imageDataBytes;

  @override
  void initState() {
    super.initState();
    picture = widget.picture;
    heroLabel = widget.heroLabel;
  }

  Widget header() {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: widget.crossAxisSpacing,
        horizontal: widget.mainAxisSpacing,
      ),
      child: Flex(
        direction: Axis.horizontal,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Row(
              children: <Widget>[
                TouchableOpacity(
                  activeOpacity: activeOpacity,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      RouteName.user,
                      arguments: {
                        'user': picture.user,
                        'heroId': picture.id.toString(),
                      },
                    );
                  },
                  child: Hero(
                    tag:
                        'user-${picture.user!.username}-${picture.id.toString()}',
                    child: Avatar(
                      size: 36,
                      image: picture.user!.avatarUrl,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Flex(
                    direction: Axis.vertical,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TouchableOpacity(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            RouteName.user,
                            arguments: {
                              'user': picture.user,
                              'heroId': picture.id.toString(),
                            },
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: Text(
                            picture.user!.fullName,
                            style: GoogleFonts.rubik(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Text(
                        Jiffy(picture.createTime.toString()).fromNow(),
                        textAlign: TextAlign.left,
                        style: GoogleFonts.rubik(
                          textStyle: TextStyle(
                            color: theme.textTheme.bodyText2!.color!
                                .withOpacity(.6),
                            fontSize: 12,
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
    final int id = picture.id;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.crossAxisSpacing),
      child: TouchableOpacity(
        activeOpacity: activeOpacity,
        onTap: () {
          print(heroLabel);
          Navigator.of(context).pushNamed(
            RouteName.picture_detail,
            arguments: {
              'picture': picture,
              'heroLabel': heroLabel,
            },
          );
        },
        child: AspectRatio(
          aspectRatio: picture.width / picture.height,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Hero(
              tag: 'picture-$heroLabel-$id',
              child: OctoImage(
                placeholderBuilder: OctoPlaceholder.blurHash(
                  picture.blurhash,
                ),
                image: ExtendedImage.network(picture.pictureUrl()).image,
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
              if (widget.header) header(),
              container(),
              // bottom(),
            ],
          ),
        ],
      ),
    );
  }
}
