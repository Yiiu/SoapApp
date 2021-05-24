import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SoapListEmpty extends StatelessWidget {
  const SoapListEmpty({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: 220,
        height: 220,
        child: SvgPicture.asset(
          'assets/svg/null.svg',
        ),
      ),
    );
  }
}
