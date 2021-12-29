import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../model/picture.dart';

class PictureDetailInfo extends StatelessWidget {
  const PictureDetailInfo({
    Key? key,
    required this.picture,
  }) : super(key: key);

  final Picture picture;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    if (picture.make == null && picture.model == null) {
      return Container();
    }
    return Container(
      // margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 16,
      ),
      color: theme.cardColor,
      child: Column(
        children: <Widget>[
          SizedBox(
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 22.0,
                  height: 22.0,
                  child: SvgPicture.asset(
                    'assets/remix/camera-3-line.svg',
                    width: 4,
                    color: theme.textTheme.bodyText2!.color,
                  ),
                ),
                const SizedBox(width: 12),
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Row(
                    children: <Widget>[
                      Text(
                        picture.make!,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        picture.model!,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            child: Row(
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
                    children: <Widget>[
                      if (picture.exif?.focalLength != null) ...<Widget>[
                        Text(
                          '${picture.exif!.focalLength!.toInt()}mm',
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 14),
                      ],
                      if (picture.exif?.aperture != null) ...<Widget>[
                        Text(
                          'f/${picture.exif!.aperture!}',
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 14),
                      ],
                      if (picture.exif?.exposureTime != null) ...<Widget>[
                        Text(
                          '${picture.exif!.exposureTime}s',
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 14),
                      ],
                      if (picture.exif?.ISO != null) ...<Widget>[
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
