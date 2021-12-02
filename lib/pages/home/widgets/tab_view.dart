import 'package:flutter/material.dart';
import 'package:soap_app/pages/home/widgets/bottom_tab.dart';

typedef OnChangeFunc = Future<void> Function(int index);

class HomeTabView extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                child: child,
              ),
            ],
          ),
          HomeBottomTab(onChange: onChange, selectedIndex: selectedIndex),
        ],
      ),
    );
  }
}
