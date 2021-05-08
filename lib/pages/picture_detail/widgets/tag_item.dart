import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:soap_app/model/tag.dart';

class TagItem extends StatelessWidget {
  const TagItem({
    Key? key,
    required this.tag,
  }) : super(key: key);

  final Tag tag;

  @override
  Widget build(BuildContext context) {
    const double height = 24;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Container(
        padding: const EdgeInsets.only(
          left: 4,
          right: 10,
          bottom: 4,
          top: 4,
        ),
        height: height,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(100),
          ),
          color: const Color(0xFF5789d1).withOpacity(.15),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: height - 8,
              width: height - 8,
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(100),
                ),
                color: Color(0xFF5789d1),
              ),
              child: const Icon(
                FeatherIcons.hash,
                size: 9,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              width: 4,
            ),
            Text(
              tag.name,
              style: const TextStyle(
                color: Color(0xFF5789d1),
                fontSize: 11,
              ),
              strutStyle: const StrutStyle(
                forceStrutHeight: true,
                height: 1,
              ),
              textHeightBehavior: const TextHeightBehavior(
                // 基线 发现不设置也能行
                applyHeightToFirstAscent: false,
                applyHeightToLastDescent: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
