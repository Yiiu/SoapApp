import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_fade/image_fade.dart';
import 'package:soap_app/ui/widget/transparent_image.dart';

class Avatar extends StatelessWidget {
  const Avatar({
    Key key,
    this.size = 32,
    this.placeholder,
    this.image,
  }) : super(key: key);

  final Uint8List placeholder;
  final String image;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: ImageFade(
        fadeDuration: const Duration(milliseconds: 100),
        placeholder: Image.memory(
          placeholder ?? transparentImage,
          fit: BoxFit.cover,
        ),
        image: CachedNetworkImageProvider(image),
        fit: BoxFit.cover,
        width: size,
        height: size,
      ),
    );
  }
}
