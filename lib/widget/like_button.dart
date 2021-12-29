import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:like_button/like_button.dart';
import 'package:soap_app/repository/repository.dart';
import 'package:soap_app/store/index.dart';
import 'package:soap_app/widget/widgets.dart';

class SoapLikeButton extends StatelessWidget {
  SoapLikeButton({
    Key? key,
    required this.isLike,
    required this.likedCount,
    required this.id,
    this.iconSize = 24,
    this.textStyle,
  }) : super(key: key);

  final bool isLike;
  final int likedCount;
  final int id;

  final double iconSize;
  final TextStyle? textStyle;

  final PictureRepository _pictureRepository = PictureRepository();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        children: <Widget>[
          LikeButton(
            isLiked: isLike,
            size: iconSize,
            onTap: (bool like) async {
              if (!accountStore.isLogin) {
                SoapToast.error('请登录后再操作！');
                return like;
              }
              if (!like) {
                await _pictureRepository.liked(id);
              } else {
                await _pictureRepository.unLike(id);
              }
              return !like;
            },
            animationDuration: const Duration(milliseconds: 600),
            circleColor: const CircleColor(
                start: Color(0xff00ddff), end: Color(0xff0099cc)),
            bubblesColor: const BubblesColor(
              dotPrimaryColor: Color(0xff33b5e5),
              dotSecondaryColor: Color(0xff0099cc),
            ),
            likeBuilder: (bool isLiked) {
              if (isLiked) {
                return ShaderMask(
                  child: SvgPicture.asset(
                    'assets/remix/heart-3-fill.svg',
                    color: const Color(0xfffe2341),
                  ),
                  blendMode: BlendMode.srcATop,
                  shaderCallback: (Rect bounds) => RadialGradient(
                    center: Alignment.topLeft.add(const Alignment(0.66, 0.66)),
                    colors: const [
                      Color(0xffEF6F6F),
                      Color(0xffF03E3E),
                    ],
                  ).createShader(bounds),
                );
              }
              return SvgPicture.asset(
                'assets/remix/heart-3-line.svg',
                color: const Color(0xffEF6F6F),
              );
            },
            likeCount: likedCount,
            countBuilder: (int? count, bool isLiked, String text) =>
                const SizedBox(),
          ),
          IntrinsicWidth(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  child: AnimatedNumber(
                    number: likedCount,
                    textStyle: textStyle,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
