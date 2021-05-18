import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:soap_app/config/const.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

class MoreHandleModalItem extends StatelessWidget {
  const MoreHandleModalItem({
    Key? key,
    required this.svg,
    required this.title,
    this.color,
  }) : super(key: key);

  final String svg;
  final String title;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color baseColor = color ?? theme.textTheme.bodyText2!.color!;
    return TouchableOpacity(
      activeOpacity: activeOpacity,
      child: Column(
        children: <Widget>[
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: baseColor.withOpacity(.05),
            ),
            child: Center(
              child: SvgPicture.asset(
                svg,
                color: baseColor.withOpacity(.9),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: baseColor.withOpacity(.7),
            ),
          ),
        ],
      ),
    );
  }
}