import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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
    return ClipOval(
      child: OctoImage(
        width: size,
        height: size,
        image: CachedNetworkImageProvider(image),
        placeholderBuilder: OctoPlaceholder.circleAvatar(
            backgroundColor: Colors.white12, text: Text('')),
        errorBuilder: OctoError.icon(color: Colors.red),
        fit: BoxFit.cover,
      ),
    );
  }
}
