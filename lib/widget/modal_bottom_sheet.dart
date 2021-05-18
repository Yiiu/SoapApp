import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

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
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(_).cardColor.withOpacity(.9),
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
    context: context,
    builder: builder,
  );
}
