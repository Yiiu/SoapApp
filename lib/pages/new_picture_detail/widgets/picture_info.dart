import 'package:flutter/material.dart';
import 'package:soap_app/model/picture.dart';
import 'package:soap_app/widget/widgets.dart';

class PictureInfoModal extends StatelessWidget {
  const PictureInfoModal({
    Key? key,
    required this.picture,
  }) : super(key: key);
  final Picture picture;

  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return MoreHandleModal(
      title: '图片信息',
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
            children: [
              Flex(
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                direction: Axis.horizontal,
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '点赞',
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
                      children: [
                        Text(
                          '浏览量',
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
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '设备',
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
                      children: [
                        Text(
                          '型号',
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
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '焦距',
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
                      children: [
                        Text(
                          '光圈',
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
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '快门速度',
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
                      children: [
                        Text(
                          'ISO',
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
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '尺寸',
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
                      children: [
                        Text(
                          '大小',
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
                Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        '智能标签',
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
                                  e['keyword'],
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
