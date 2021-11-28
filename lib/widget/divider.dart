import 'package:flutter/material.dart';

class SoapDivider extends StatelessWidget {
  const SoapDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      height: 1,
      color: theme.cardColor,
      child: Center(
        child: Container(
          height: 0.4,
          color: theme.textTheme.overline!.color!.withOpacity(.1),
        ),
      ),
    );
  }
}
