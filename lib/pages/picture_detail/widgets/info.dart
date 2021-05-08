import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:soap_app/graphql/query.dart';
import 'package:soap_app/model/picture.dart';

class PictureDetailInfo extends StatelessWidget {
  const PictureDetailInfo({
    Key? key,
    required this.picture,
  }) : super(key: key);

  final Picture picture;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    if (picture.make == null && picture.model == null) return Container();
    return Container(
      // margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 16,
      ),
      color: theme.cardColor,
      child: Column(
        children: [
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 22.0,
                  height: 22.0,
                  child: SvgPicture.asset(
                    'assets/remix/camera-3-line.svg',
                    width: 4,
                    color: theme.textTheme.bodyText2!.color,
                  ),
                ),
                SizedBox(width: 12),
                Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: Row(
                    children: [
                      Text(
                        picture.make!,
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(width: 4),
                      Text(
                        picture.model!,
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 22.0,
                  height: 22.0,
                  child: SvgPicture.asset(
                    'assets/remix/camera-lens-line.svg',
                    color: theme.textTheme.bodyText2!.color,
                  ),
                ),
                const SizedBox(width: 12),
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Row(
                    children: [
                      if (picture.exif?.focalLength != null) ...[
                        Text(
                          '${picture.exif!.focalLength!.toInt()}mm',
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      if (picture.exif?.aperture != null) ...[
                        Text(
                          'f/${picture.exif!.aperture!.toInt()}',
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      if (picture.exif?.exposureTime != null) ...[
                        Text(
                          '${picture.exif!.exposureTime}s',
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      if (picture.exif?.ISO != null) ...[
                        Text(
                          'ISO ${picture.exif!.ISO}',
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
