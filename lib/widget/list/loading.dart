import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'widget.dart';

class SoapListLoading extends StatelessWidget {
  const SoapListLoading({
    Key? key,
    this.notScrollView = false,
    required this.controller,
  }) : super(key: key);

  final RefreshController controller;
  final bool notScrollView;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return SoapListWidget(
      controller: controller,
      notScrollView: notScrollView,
      child: Container(
        padding: const EdgeInsets.only(top: 16),
        height: double.infinity,
        child: Column(
          children: <Widget>[
            Column(
              children: <Widget>[
                // const CupertinoActivityIndicator(radius: 14),
                SizedBox(
                  width: 300,
                  height: 100,
                  child: Stack(
                    children: const <Widget>[
                      Center(child: CupertinoActivityIndicator(radius: 14)),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '加载中...',
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.textTheme.bodyText2!.color!.withOpacity(.6),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
