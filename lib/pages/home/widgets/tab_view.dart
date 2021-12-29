import 'package:flutter/material.dart';

import '../../../widget/list/scroll_direction_listener.dart';
import 'bottom_tab.dart';

typedef OnChangeFunc = Future<void> Function(int index);

class HomeTabView extends StatefulWidget {
  const HomeTabView({
    Key? key,
    required this.child,
    required this.tabController,
    required this.onChange,
    required this.selectedIndex,
  }) : super(key: key);

  final Widget child;
  final TabController tabController;
  final OnChangeFunc onChange;
  final int selectedIndex;

  @override
  State<HomeTabView> createState() => _HomeTabViewState();
}

class _HomeTabViewState extends State<HomeTabView> {
  VerticalDirection vertical = VerticalDirection.up;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                child: ScrollDirectionListener(
                  child: widget.child,
                  onScrollDirectionChanged: (VerticalDirection dir) {
                    if (widget.selectedIndex == 0) {
                      setState(() {
                        vertical = dir;
                      });
                    }
                  },
                ),
              ),
            ],
          ),
          HomeBottomTab(
            onChange: widget.onChange,
            selectedIndex: widget.selectedIndex,
            vertical: vertical,
          ),
        ],
      ),
    );
  }
}
