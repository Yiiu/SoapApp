import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:octo_image/octo_image.dart';

class Avatar extends StatelessWidget {
  const Avatar({
    Key? key,
    this.size = 32,
    this.placeholder,
    required this.image,
  }) : super(key: key);

  final Uint8List? placeholder;
  final String image;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (image == '//cdn.soapphoto.com/default.svg') {
      return SizedBox(
        width: size,
        height: size,
        child: Icon(
          FeatherIcons.smile,
          size: size,
        ),
      );
    }
    return ClipOval(
      child: OctoImage(
        width: size,
        height: size,
        image: ExtendedImage.network(image).image,
        placeholderBuilder: OctoPlaceholder.circleAvatar(
          backgroundColor: Colors.white12,
          text: Text(''),
        ),
        errorBuilder: OctoError.icon(color: Colors.red),
        fit: BoxFit.cover,
      ),
    );
  }
}
