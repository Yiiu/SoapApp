import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:soap_app/widget/animations/animated_shifted_position.dart';

import 'tab_view.dart';

class SoapBottomNavigationBarItem {
  const SoapBottomNavigationBarItem({
    required this.icon,
    required this.title,
  });

  final String icon;
  final String title;
}

class HomeBottomTab extends StatefulWidget {
  const HomeBottomTab({
    Key? key,
    required this.onChange,
    required this.selectedIndex,
    required this.vertical,
  }) : super(key: key);

  final OnChangeFunc onChange;
  final int selectedIndex;
  final VerticalDirection vertical;

  static List<SoapBottomNavigationBarItem> get bottomBar =>
      <SoapBottomNavigationBarItem>[
        const SoapBottomNavigationBarItem(
          icon: 'assets/svg/home-ternav.svg',
          title: 'Home',
        ),
        const SoapBottomNavigationBarItem(
          icon: 'assets/svg/add-ternav.svg',
          title: 'Add',
        ),
        const SoapBottomNavigationBarItem(
          icon: 'assets/svg/user-ternav.svg',
          title: 'Profile',
        ),
      ];

  @override
  State<HomeBottomTab> createState() => _HomeBottomTabState();
}

class _HomeBottomTabState extends State<HomeBottomTab>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<Offset> _topAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    _topAnimation = Tween(
      begin: Offset.zero,
      end: const Offset(0, 1),
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.reverse(from: 1);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Widget _iconBuilder(BuildContext context, SoapBottomNavigationBarItem bar) {
    final ThemeData theme = Theme.of(context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        widget.onChange(HomeBottomTab.bottomBar.indexOf(bar));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: bar.title == 'Add' ? 34 : 26,
              width: bar.title == 'Add' ? 34 : 26,
              child: SvgPicture.asset(
                bar.icon,
                color:
                    widget.selectedIndex == HomeBottomTab.bottomBar.indexOf(bar)
                        ? theme.primaryIconTheme.color
                        : bar.title == 'Add'
                            ? const Color(0xffff9f55)
                            : theme.textTheme.bodyText2!.color!.withOpacity(.3),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Positioned(
      bottom: 0,
      child: SlideTransition(
        position: _topAnimation,
        child: AnimatedShiftedPosition(
          shift: widget.vertical == VerticalDirection.down
              ? const Offset(0, 1)
              : Offset.zero,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Container(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom,
                ),
                width: 240,
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(100.0),
                      topRight: Radius.circular(100.0),
                      bottomLeft: Radius.circular(100.0),
                      bottomRight: Radius.circular(100.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x0d000000),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: Offset(0, 2), // changes position of shadow
                      ),
                    ],
                  ),
                  height: 56,
                  margin: const EdgeInsets.only(
                    // left: 60,
                    // right: 60,
                    bottom: 16,
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(100.0),
                      topRight: Radius.circular(100.0),
                      bottomLeft: Radius.circular(100.0),
                      bottomRight: Radius.circular(100.0),
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 16,
                        sigmaY: 16,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: theme.cardColor.withOpacity(.92),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: HomeBottomTab.bottomBar
                              .map<Widget>(
                                (SoapBottomNavigationBarItem bar) =>
                                    _iconBuilder(context, bar),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
