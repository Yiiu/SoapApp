import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:soap_app/config/const.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

class SettingItem extends StatelessWidget {
  SettingItem({
    Key? key,
    required this.title,
    this.actionIcon = true,
    this.action,
    this.onPressed,
    this.height = 62,
  }) : super(key: key);

  String title;
  Widget? action;
  Function()? onPressed;
  double height = 62;
  bool actionIcon;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Container content = Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
      ),
      width: double.infinity,
      child: Flex(
        direction: Axis.horizontal,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              child: Text(
                title,
              ),
            ),
          ),
          if (action != null) action!,
          const SizedBox(width: 6),
          if (onPressed != null && actionIcon) ...[
            Container(
              child: SvgPicture.asset(
                'assets/feather/chevron-right.svg',
                width: 26,
                height: 26,
                color: theme.textTheme.bodyText2!.color,
              ),
            ),
          ]
        ],
      ),
    );
    if (onPressed == null) {
      return Container(
        height: height,
        color: theme.cardColor,
        child: content,
      );
    }
    return Container(
      height: height,
      color: theme.cardColor,
      child: TouchableOpacity(
        activeOpacity: activeOpacity,
        behavior: HitTestBehavior.opaque,
        onTap: onPressed,
        child: content,
      ),
    );
  }
}
