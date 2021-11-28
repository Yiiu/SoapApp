import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:soap_app/config/const.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

class SettingItem extends StatelessWidget {
  const SettingItem({
    Key? key,
    required this.title,
    this.actionIcon = true,
    this.action,
    this.onPressed,
    this.border = true,
    this.height = 64,
  }) : super(key: key);

  final String title;
  final Widget? action;
  final Function()? onPressed;
  final double height;
  final bool actionIcon;
  final bool border;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Container content = Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
      ),
      width: double.infinity,
      child: Container(
        decoration: border
            ? BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: theme.textTheme.overline!.color!.withOpacity(.2),
                    width: 0.5,
                  ),
                ),
              )
            : null,
        child: Flex(
          direction: Axis.horizontal,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: SizedBox(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            if (action != null)
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[action!],
                ),
              ),
            const SizedBox(width: 6),
            if (onPressed != null && actionIcon)
              SizedBox(
                width: 24,
                height: 24,
                child: Icon(
                  FeatherIcons.chevronRight,
                  color: theme.textTheme.bodyText2!.color!.withOpacity(.4),
                  size: 18,
                ),
              ),
            // if (onPressed == null && !actionIcon)
            //   const SizedBox(
            //     width: 24,
            //     height: 24,
            //   ),
          ],
        ),
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
