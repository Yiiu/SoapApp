import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TouchableOpacity extends StatelessWidget {
  const TouchableOpacity({
    Key key,
    @required this.child,
    @required this.onPressed,
    this.activeOpacity = 0.6,
  }) : super(key: key);

  final double activeOpacity;
  final Widget child;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return CupertinoButton(
      padding: const EdgeInsets.all(0),
      pressedOpacity: activeOpacity,
      borderRadius: const BorderRadius.all(Radius.circular(0)),
      onPressed: onPressed,
      child: DefaultTextStyle(
        style: theme.textTheme.bodyText2,
        child: IconTheme(
          data: IconThemeData(color: theme.textTheme.bodyText2.color),
          child: child,
        ),
      ),
    );
  }
}
