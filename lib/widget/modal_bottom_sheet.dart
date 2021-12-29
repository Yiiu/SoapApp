import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../config/config.dart';

void showBasicModalBottomSheet({
  bool enableDrag = false,
  String? title,
  required BuildContext context,
  required Widget Function(BuildContext) builder,
}) {
  showCustomModalBottomSheet<dynamic>(
    enableDrag: enableDrag,
    containerWidget: (
      BuildContext _,
      Animation<double> animation,
      Widget child,
    ) =>
        Material(
      type: MaterialType.transparency,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(_).backgroundColor.withOpacity(.95),
              borderRadius: const BorderRadius.only(
                topLeft: radius,
                topRight: radius,
              ),
            ),
            child: child,
          ),
        ),
      ),
    ),
    context: context,
    builder: builder,
  );
}
