import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:soap_app/config/config.dart';
import 'package:soap_app/config/router.dart';
import 'package:soap_app/model/picture.dart';
import 'package:soap_app/widget/avatar.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

class PictureItemHeader extends StatelessWidget {
  PictureItemHeader({
    Key? key,
    this.heroLabel,
    required this.mainAxisSpacing,
    required this.crossAxisSpacing,
    required this.picture,
  }) : super(key: key);

  double crossAxisSpacing;
  double mainAxisSpacing;
  String? heroLabel;
  Picture picture;

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
                      size: 32,
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
                          padding: const EdgeInsets.only(bottom: 0),
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
                        Jiffy(picture.createTime.toString()).fromNow(),
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
