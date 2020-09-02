import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_fade/image_fade.dart';
import 'package:provider/provider.dart';
import 'package:soap_app/provider/picture_detail.dart';

class PictureDetailImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double minFactor = MediaQuery.of(context).size.width / 500;
    return Container(
      child: Consumer<PictureDetailProvider>(
        builder: (
          BuildContext context,
          PictureDetailProvider detail,
          Widget child,
        ) {
          final _content = Hero(
            tag: 'picture-${detail.picture.id}',
            child: ImageFade(
              fadeDuration: const Duration(milliseconds: 100),
              placeholder: Image.memory(
                base64.decode(detail.picture.blurhashSrc.split(',')[1]),
                fit: BoxFit.cover,
              ),
              image: CachedNetworkImageProvider(detail.picture.pictureUrl()),
              fit: BoxFit.cover,
            ),
          );
          final double num = detail.picture.width / detail.picture.height;
          if (num < minFactor && num < 1) {
            return Container(
              color: const Color(0xFFF8FAFC),
              height: 500,
              child: FractionallySizedBox(
                widthFactor: detail.picture.width / detail.picture.height,
                child: _content,
              ),
            );
          } else {
            return AspectRatio(
              aspectRatio: detail.picture.width / detail.picture.height,
              child: _content,
            );
          }
        },
      ),
    );
  }
}
