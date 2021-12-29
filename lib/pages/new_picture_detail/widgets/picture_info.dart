import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import '../../../model/picture.dart';
import '../../../widget/widgets.dart';

class PictureInfoModal extends StatelessWidget {
  const PictureInfoModal({
    Key? key,
    required this.picture,
  }) : super(key: key);
  final Picture picture;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return MoreHandleModal(
      title: FlutterI18n.translate(context, 'picture.info.title'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.only(bottom: 12),
          child: Flex(
            direction: Axis.vertical,
            children: <Widget>[
              Flex(
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                direction: Axis.horizontal,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          FlutterI18n.translate(context, 'common.label.like'),
                          style: TextStyle(
                            fontSize: 11,
                            color: theme.textTheme.bodyText2!.color!
                                .withOpacity(.6),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          picture.likedCount.toString(),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          FlutterI18n.translate(context, 'common.label.views'),
                          style: TextStyle(
                            fontSize: 11,
                            color: theme.textTheme.bodyText2!.color!
                                .withOpacity(.6),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          picture.views.toString(),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Flex(
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                direction: Axis.horizontal,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          FlutterI18n.translate(context, 'common.label.views'),
                          style: TextStyle(
                            fontSize: 11,
                            color: theme.textTheme.bodyText2!.color!
                                .withOpacity(.6),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          picture.make ?? '--',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          FlutterI18n.translate(context, 'picture.info.model'),
                          style: TextStyle(
                            fontSize: 11,
                            color: theme.textTheme.bodyText2!.color!
                                .withOpacity(.6),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          picture.model ?? '--',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Flex(
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                direction: Axis.horizontal,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          FlutterI18n.translate(
                              context, 'picture.info.focalLength'),
                          style: TextStyle(
                            fontSize: 11,
                            color: theme.textTheme.bodyText2!.color!
                                .withOpacity(.6),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          picture.exif?.focalLength != null
                              ? '${picture.exif!.focalLength}mm'
                              : '--',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          FlutterI18n.translate(
                              context, 'picture.info.aperture'),
                          style: TextStyle(
                            fontSize: 11,
                            color: theme.textTheme.bodyText2!.color!
                                .withOpacity(.6),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          picture.exif?.aperture != null
                              ? 'f/${picture.exif!.aperture}'
                              : '--',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Flex(
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                direction: Axis.horizontal,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          FlutterI18n.translate(
                              context, 'picture.info.exposureTime'),
                          style: TextStyle(
                            fontSize: 11,
                            color: theme.textTheme.bodyText2!.color!
                                .withOpacity(.6),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          picture.exif?.exposureTime != null
                              ? '${picture.exif!.exposureTime}s'
                              : '--',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          FlutterI18n.translate(context, 'picture.info.ISO'),
                          style: TextStyle(
                            fontSize: 11,
                            color: theme.textTheme.bodyText2!.color!
                                .withOpacity(.6),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          picture.exif?.ISO != null
                              ? picture.exif!.ISO.toString()
                              : '--',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Flex(
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                direction: Axis.horizontal,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          FlutterI18n.translate(
                              context, 'picture.info.dimension'),
                          style: TextStyle(
                            fontSize: 11,
                            color: theme.textTheme.bodyText2!.color!
                                .withOpacity(.6),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          picture.width != null
                              ? '${picture.width} x ${picture.height}'
                              : '--',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          FlutterI18n.translate(context, 'picture.info.size'),
                          style: TextStyle(
                            fontSize: 11,
                            color: theme.textTheme.bodyText2!.color!
                                .withOpacity(.6),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          picture.sizeStr,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              if (picture.classify != null)
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        FlutterI18n.translate(
                            context, 'picture.info.smart_tags'),
                        style: TextStyle(
                          fontSize: 11,
                          color:
                              theme.textTheme.bodyText2!.color!.withOpacity(.6),
                        ),
                      ),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        alignment: WrapAlignment.start,
                        runAlignment: WrapAlignment.end,
                        children: picture.classify!
                            .map(
                              (e) => Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                  horizontal: 12,
                                ),
                                margin: const EdgeInsets.only(top: 6),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(4),
                                  ),
                                  color: theme.backgroundColor,
                                ),
                                child: Text(
                                  e['keyword'] as String,
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
