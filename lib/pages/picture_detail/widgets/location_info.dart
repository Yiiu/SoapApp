import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PictureLocationInfo extends StatelessWidget {
  const PictureLocationInfo({
    Key? key,
    required this.location,
  }) : super(key: key);

  final Map location;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border(
          bottom: BorderSide(
            color: theme.textTheme.overline!.color!.withOpacity(.2),
            width: .2,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 16,
      ),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
            height: 20,
            child: SvgPicture.asset(
              'assets/svg/emoji/garden.svg',
            ),
          ),
          const SizedBox(width: 12),
          Text(
            location['city'] ?? '',
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
          const Text('·'),
          Text(
            location['name'] ?? '',
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
