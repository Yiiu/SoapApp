import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../config/config.dart';

/// Shows a harpy styled modal bottom sheet with the [child] in a column.
Future<T?> showSoapBottomSheet<T>(
  BuildContext context, {
  required Widget child,
  bool hapticFeedback = false,
  bool isScrollControlled = false,
  double? height,
  Color? backgroundColor,
}) async {
  // if (hapticFeedback) {
  //   unawaited(HapticFeedback.lightImpact());
  // }

  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: isScrollControlled,
    backgroundColor: Colors.transparent,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: radius,
        topRight: radius,
      ),
    ),
    builder: (_) {
      Widget content = Material(
        type: MaterialType.transparency,
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Container(
              decoration: BoxDecoration(
                color: backgroundColor ??
                    Theme.of(_).backgroundColor.withOpacity(.94),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: child,
            ),
          ),
        ),
      );

      if (height != null) {
        content = SizedBox(
          height: height,
          child: content,
        );
      }
      return content;
    },
  );
}
