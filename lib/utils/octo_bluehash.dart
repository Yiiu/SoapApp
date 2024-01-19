import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:octo_image/octo_image.dart';

class OctoBlurHashFix {
  static OctoPlaceholderBuilder placeHolder(String hash, {BoxFit? fit}) {
    return (context) => SizedBox.expand(
          child: Image(
            image: BlurHashImage(hash),
            fit: fit ?? BoxFit.cover,
          ),
        );
  }

  static OctoErrorBuilder error(
    String hash, {
    BoxFit? fit,
    Text? message,
    IconData? icon,
    Color? iconColor,
    double? iconSize,
  }) {
    return OctoError.placeholderWithErrorIcon(
      placeHolder(hash, fit: fit),
      message: message,
      icon: icon,
      iconColor: iconColor,
      iconSize: iconSize,
    );
  }
}
