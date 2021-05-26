import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SoapListEmpty extends StatelessWidget {
  const SoapListEmpty({
    Key? key,
    this.message,
    this.onlyImage = false,
  }) : super(key: key);

  final String? message;
  final bool? onlyImage;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Column(
        children: <Widget>[
          SizedBox(
            width: 220,
            height: 220,
            child: SvgPicture.asset(
              'assets/svg/null.svg',
            ),
          ),
          if (!onlyImage!)
            Text(
              message ?? '空荡荡',
              style: TextStyle(
                color: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .color!
                    .withOpacity(.4),
              ),
            )
        ],
      ),
    );
  }
}
