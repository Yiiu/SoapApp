import 'package:flutter/material.dart';
import 'package:soap_app/ui/widget/app_bar.dart';

class FollowModal extends StatefulWidget {
  @override
  _FollowModalState createState() => _FollowModalState();
}

class _FollowModalState extends State<FollowModal> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      // color: theme.backgroundColor,
      decoration: BoxDecoration(
        color: theme.backgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            width: double.infinity,
            child: Text(
              '关注 (12)',
              style: theme.textTheme.headline5,
            ),
          )
        ],
      ),
    );
  }
}
