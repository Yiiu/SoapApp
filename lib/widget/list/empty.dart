import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

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
            width: 240,
            height: 120,
            child: Stack(
              children: <Widget>[
                if (!kIsWeb)
                  Positioned(
                    top: -60,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Lottie.asset(
                      'assets/lottie/cat.json',
                      width: 240,
                      height: 240,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
              ],
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
