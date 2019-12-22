import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';


class HomeSecondFloorOuter extends StatelessWidget {
  final Widget child;

  HomeSecondFloorOuter(this.child);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30 + MediaQuery.of(context).padding.top + 20,
      decoration: BoxDecoration(),
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Text('跌跌撞撞中,依旧热爱这个世界.',
                style: Theme.of(context).textTheme.overline.copyWith(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    )),
          ),
          Align(alignment: Alignment(0, 0.85), child: child),
        ],
      ),
      alignment: Alignment.bottomCenter,
    );
  }
}

class HomeRefreshHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var strings = RefreshLocalizations.of(context)?.currentLocalization ??
        EnRefreshString();
    return ClassicHeader(
      textStyle: TextStyle(color: Colors.white),
      outerBuilder: (child) => HomeSecondFloorOuter(child),
      twoLevelView: Container(),
      height: 70 + MediaQuery.of(context).padding.top / 3,
      releaseText: strings.canRefreshText,
    );
  }
}
