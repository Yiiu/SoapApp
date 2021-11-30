import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:octo_image/octo_image.dart';

class Avatar extends StatelessWidget {
  const Avatar({
    Key? key,
    required this.image,
    this.size = 32,
    this.placeholder,
    this.heroTag,
    this.radius,
  }) : super(key: key);

  final Uint8List? placeholder;
  final String image;
  final double size;
  final double? radius;
  final Object? heroTag;

  @override
  Widget build(BuildContext context) {
    Widget img = OctoImage(
      image: ExtendedImage.network(image).image,
      placeholderBuilder: OctoPlaceholder.circleAvatar(
        backgroundColor: Colors.white12,
        text: Text(''),
      ),
      errorBuilder: OctoError.icon(color: Colors.red),
      fit: BoxFit.cover,
    );
    if (heroTag != null) {
      img = Hero(
        tag: heroTag!,
        child: img,
      );
    }

    if (image == '//cdn.soapphoto.com/default.svg') {
      return SizedBox(
        child: Icon(
          FeatherIcons.smile,
          size: size,
        ),
      );
    }
    return SizedBox(
      width: size,
      height: size,
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: radius,
        child: SizedBox.expand(
          child: ClipOval(
            child: img,
          ),
        ),
      ),
    );
  }
}
