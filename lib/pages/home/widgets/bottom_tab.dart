import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'tab_view.dart';

class SoapBottomNavigationBarItem {
  const SoapBottomNavigationBarItem({
    required this.icon,
    required this.title,
  });

  final String icon;
  final String title;
}

class HomeBottomTab extends StatelessWidget {
  const HomeBottomTab({
    Key? key,
    required this.onChange,
    required this.selectedIndex,
  }) : super(key: key);

  final OnChangeFunc onChange;
  final int selectedIndex;

  static List<SoapBottomNavigationBarItem> get bottomBar =>
      <SoapBottomNavigationBarItem>[
        const SoapBottomNavigationBarItem(
          icon: 'assets/svg/home.svg',
          title: 'Home',
        ),
        const SoapBottomNavigationBarItem(
          icon: 'assets/svg/plus.svg',
          title: 'Add',
        ),
        const SoapBottomNavigationBarItem(
          icon: 'assets/remix/user.svg',
          title: 'Profile',
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 16,
            sigmaY: 16,
          ),
          child: Container(
            color: theme.cardColor.withOpacity(.85),
            height: 56 + MediaQuery.of(context).padding.bottom,
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).padding.bottom,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: bottomBar
                  .map<Widget>(
                    (SoapBottomNavigationBarItem bar) => GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        onChange(bottomBar.indexOf(bar));
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 22),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              height: 26,
                              width: 26,
                              child: SvgPicture.asset(
                                bar.icon,
                                color: selectedIndex == bottomBar.indexOf(bar)
                                    ? theme.primaryColor
                                    : theme.textTheme.bodyText2!.color!
                                        .withOpacity(.5),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}
