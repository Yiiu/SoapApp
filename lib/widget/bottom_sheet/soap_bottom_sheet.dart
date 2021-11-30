import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pedantic/pedantic.dart';
import 'package:soap_app/config/config.dart';

/// Shows a harpy styled modal bottom sheet with the [child] in a column.
Future<T?> showSoapBottomSheet<T>(
  BuildContext context, {
  required Widget child,
  bool hapticFeedback = false,
  bool isScrollControlled = false,
}) async {
  if (hapticFeedback) {
    unawaited(HapticFeedback.lightImpact());
  }

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
    builder: (_) => Material(
      type: MaterialType.transparency,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(_).backgroundColor.withOpacity(.94),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: child,
          ),
        ),
      ),
    ),
  );
}
