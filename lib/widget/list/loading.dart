import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:soap_app/widget/list/widget.dart';

class SoapListLoading extends StatelessWidget {
  const SoapListLoading({
    Key? key,
    this.notScrollView,
    required this.controller,
  }) : super(key: key);

  final RefreshController controller;
  final bool? notScrollView;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return SoapListWidget(
      controller: controller,
      notScrollView: notScrollView,
      child: Container(
        padding: EdgeInsets.only(top: 16),
        height: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Column(
              children: <Widget>[
                const CupertinoActivityIndicator(radius: 14),
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
