import 'dart:typed_data';

import 'package:flutter/material.dart';
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
      child: FadeInImage.memoryNetwork(
        width: size,
        height: size,
        placeholder: placeholder ?? transparentImage,
        fadeInDuration: const Duration(milliseconds: 400),
        image: image,
        fit: BoxFit.cover,
      ),
    );
  }
}
