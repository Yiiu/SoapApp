import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:soap_app/model/picture.dart';
import 'package:soap_app/model/tag.dart';
import 'package:soap_app/provider/picture_detail.dart';
import 'package:tuple/tuple.dart';

class PictureDetailInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      color: theme.cardColor,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Selector<PictureDetailProvider, String>(
              selector: (context, provider) => provider.picture.title,
              builder: (BuildContext context, String provider, Widget child) {
                return Text(provider);
              },
            ),
          ),
          Selector<PictureDetailProvider, List<Tag>>(
            selector: (context, provider) => provider.picture.tags,
            builder: (context, tags, child) {
              if (tags != null && tags.length > 1)
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: tags.map((e) {
                      return Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 5),
                        decoration: BoxDecoration(
                          color: theme.backgroundColor,
                          borderRadius:
                              const BorderRadius.all(Radius.elliptical(50, 50)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            ClipOval(
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: theme.textTheme.bodyText2.color
                                      .withOpacity(.8),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(2)),
                                ),
                                child: Icon(
                                  FeatherIcons.hash,
                                  size: 11,
                                  color: theme.cardColor,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 6, right: 6),
                              child: Text(
                                e.name,
                                style: theme.textTheme.bodyText2.copyWith(
                                  color: theme.textTheme.bodyText2.color
                                      .withOpacity(.8),
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                );
              return Container();
            },
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: Selector<PictureDetailProvider, DateTime>(
              selector: (context, provider) => provider.picture.createTime,
              builder: (context, createTime, child) {
                return Text(
                  Jiffy(createTime.toString()).format('M月dd日'),
                  style: theme.textTheme.bodyText2.copyWith(
                    fontSize: 12,
                    color: theme.textTheme.bodyText2.color.withOpacity(.6),
                  ),
                );
              },
            ),
          ),
          Container(
            child: Row(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: Selector<PictureDetailProvider, bool>(
                    selector: (context, provider) => provider.picture.isLike,
                    builder: (context, isLike, child) {
                      final Color color = isLike
                          ? theme.errorColor
                          : theme.textTheme.bodyText2.color;
                      return ClipOval(
                        child: Container(
                          width: 30,
                          height: 30,
                          alignment: Alignment.center,
                          color: color.withOpacity(.1),
                          child: Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              Positioned(
                                top: 6,
                                child: SvgPicture.asset(
                                  'assets/feather/thumbs-up.svg',
                                  width: 16,
                                  height: 16,
                                  color: color.withOpacity(.8),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Selector<PictureDetailProvider, int>(
                  selector: (context, provider) => provider.picture.likedCount,
                  builder: (context, likedCount, child) {
                    return Text(
                      likedCount.toString(),
                      style: theme.textTheme.bodyText2.copyWith(
                          fontSize: 14,
                          color:
                              theme.textTheme.bodyText2.color.withOpacity(.8)),
                    );
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
