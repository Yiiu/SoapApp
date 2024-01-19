import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

import '../../config/config.dart';
import '../../model/picture.dart';
import '../avatar.dart';

class PictureItemHeader extends StatelessWidget {
  const PictureItemHeader({
    Key? key,
    this.heroLabel,
    required this.mainAxisSpacing,
    required this.crossAxisSpacing,
    required this.picture,
  }) : super(key: key);

  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final String? heroLabel;
  final Picture picture;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 8,
        horizontal: mainAxisSpacing,
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
                      image: picture.user!.avatarUrl,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Flex(
                    direction: Axis.vertical,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
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
                          padding: const EdgeInsets.only(),
                          child: Text(
                            picture.user!.fullName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        Jiffy.parse(picture.createTime.toString()).fromNow(),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color:
                              theme.textTheme.bodyText2!.color!.withOpacity(.6),
                          fontSize: 12,
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
}
