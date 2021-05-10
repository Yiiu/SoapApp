import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

void showBasicModalBottomSheet({
  required BuildContext context,
  required Widget Function(BuildContext) builder,
}) {
  final ThemeData theme = Theme.of(context);
  showCustomModalBottomSheet<dynamic>(
    enableDrag: false,
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
              color: theme.cardColor.withOpacity(.9),
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
    duration: const Duration(milliseconds: 200),
    context: context,
    builder: builder,
  );
}
