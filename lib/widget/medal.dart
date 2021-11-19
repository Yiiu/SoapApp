import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MedalType {
  const MedalType({
    required this.icon,
    this.iconColor,
  });

  final String icon;
  final Color? iconColor;

  static MedalType choice = MedalType(
    icon: 'assets/svg/planet.svg',
    iconColor: Colors.white.withOpacity(.8),
  );
}

// 勋章
class Medal extends StatelessWidget {
  const Medal({
    Key? key,
    this.size = 34,
    required this.type,
  }) : super(key: key);

  final double? size;

  final MedalType type;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size ?? 34,
      height: size ?? 34,
      child: Stack(
        children: [
          SizedBox(
            width: size ?? 34,
            height: size ?? 34,
            child: SvgPicture.asset('assets/svg/ordinary.svg'),
            // child: ShaderMask(
            //   child: SvgPicture.asset('assets/svg/hexagon.svg'),
            //   blendMode: BlendMode.srcATop,
            //   shaderCallback: (Rect bounds) => const LinearGradient(
            //     begin: Alignment.topCenter,
            //     end: Alignment.bottomCenter,
            //     colors: <Color>[
            //       Color(0xffF5C164),
            //       Color(0xffFF9500),
            //     ],
            //   ).createShader(bounds),
            // ),
          ),
          // Align(
          //   child: SizedBox(
          //     width: (size ?? 34) - 8,
          //     height: (size ?? 34) - 8,
          //     child: SvgPicture.asset(
          //       type.icon,
          //       color: type.iconColor,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
