import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:google_fonts/google_fonts.dart';

class Header extends SliverPersistentHeaderDelegate {
  Header({this.title}) : super();

  double scrollAnimationValue(double shrinkOffset) {
    double maxScrollAllowed = maxExtent - minExtent;
    return ((maxScrollAllowed - shrinkOffset) / maxScrollAllowed)
        .clamp(0, 1)
        .toDouble();
  }

  final Widget title;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final double visibleMainHeight = max(maxExtent - shrinkOffset, minExtent);
    final double animationVal = scrollAnimationValue(shrinkOffset);
    print('full height: ${visibleMainHeight}');
    return Container(
      // color: Colors.white,
      // height: 70 + MediaQuery.of(context).padding.top,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color.fromRGBO(243, 243, 244, 1), width: 1),
        ),
      ),
      // height: visibleMainHeight,
      width: MediaQuery.of(context).size.width,
      child: SizedBox(
          child: SafeArea(
        child: Stack(
          children: <Widget>[
            // Padding(
            //   padding: const EdgeInsets.only(top: 4),
            //   child: Container(
            //     width: AppBar().preferredSize.height - 8,
            //     height: AppBar().preferredSize.height - 8,
            //   ),
            // ),
            Positioned(
              left: 12,
              bottom: 18,
              child: Text(
                'home',
                style: GoogleFonts.rubik(
                  textStyle: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 20,
              bottom: 8,
              child: Container(
                width: AppBar().preferredSize.height - 8,
                height: AppBar().preferredSize.height - 8,
                color: Colors.white,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(
                      AppBar().preferredSize.height,
                    ),
                    child: Icon(
                      FeatherIcons.bell,
                    ),
                    onTap: () {},
                  ),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }

  @override
  double get maxExtent => 70.0;

  @override
  double get minExtent => 0.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
