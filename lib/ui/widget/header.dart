import 'dart:math';

import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';

class Header extends SliverPersistentHeaderDelegate {
  Header({this.title}) : super();

  double scrollAnimationValue(double shrinkOffset) {
    final double maxScrollAllowed = maxExtent - minExtent;
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
    final ThemeData theme = Theme.of(context);
    return Container(
      // color: theme.cardColor,
      // height: 70 + MediaQuery.of(context).padding.top,
      decoration: BoxDecoration(
        color: theme.cardColor,
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
            const Positioned(
              left: 12,
              bottom: 18,
              child: Text(
                'home',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Positioned(
              right: 20,
              bottom: 8,
              child: Container(
                width: AppBar().preferredSize.height - 8,
                height: AppBar().preferredSize.height - 8,
                color: theme.cardColor,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(
                      AppBar().preferredSize.height,
                    ),
                    child: const Icon(
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
